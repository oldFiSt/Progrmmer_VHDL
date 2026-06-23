# ============================================================================
#  Тесты обнаружения ошибок (радиационная устойчивость) для pkt2axil
#
#  РАУНД 2: error_flag/error_code теперь реально подключены к pkt2axil_binder
#  (см. pkt2axil_top.sv) и попадают в исходящий AXI Stream пакет через новое
#  состояние ERR_INJECT в pkt2axil_binder.sv. Поэтому помимо внутренних
#  диагностических пинов добавлены СКВОЗНЫЕ тесты (test_e2e_*), которые
#  проверяют именно то, что важно для host'а: реально пришёл пакет-ответ
#  с кодом ошибки на m_axis, а не просто внутренний флаг на кристалле.
#
#  Диагностические выходы pkt2axil_top (продублированы в тестбенче на верхнем
#  уровне, поэтому из cocotb видны как короткие dut.error_flag/dut.error_code/
#  dut.illegal_state — см. tests/pkt2axil_top_tb.sv):
#      dut.error_flag     - флаг обнаруженной ошибки (= вход биндера)
#      dut.error_code     - код ошибки (ERR_*)         (= вход биндера)
#      dut.illegal_state  - нелегальное состояние FSM cutter (SEU)
#  Для теста с прямой инъекцией SEU (test_seu_one_hot_offset_fault_injection)
#  нужен более глубокий путь до внутренних регистров cutter'а, которые в
#  портах никуда не выведены: dut.dut.cutter_inst.current_offset_* (dut.dut —
#  это инстанс pkt2axil_top с именем "dut" внутри тестбенча pkt2axil_top_tb).
#
#  Коды ошибок (см. pkt2axil_cutter.sv):
#      0x01 ERR_UNKNOWN_CMD        - команда не F1/F3
#      0x02 ERR_INSUFFICIENT_DATA  - tlast пришёл, 10 байт команды не набрано
#      0x03 ERR_TIMEOUT            - таймаут ожидания остатка команды
#      0x04 ERR_SEU_FAULT          - нарушение one-hot указателя / нелегальное состояние
#
#  Запуск:
#      make MODULE=pkt2axil_error_test
#  либо отдельным таргетом:
#      make test_errors
#
#  Замечание по стимулу: штатный помощник send_*_transaction поднимает tready
#  только после распознавания валидной команды F1/F3, поэтому неизвестную команду
#  нельзя «вдвинуть» обычным рукопожатием. Для проверки ветви ERROR используется
#  прямое удержание tvalid (намеренное стресс-воздействие на протокол).
# ============================================================================

import cocotb
from cocotb.triggers import RisingEdge, ClockCycles

from pkt2axil_test import Pkt2AxilTester, init_tester

# Коды ошибок
ERR_UNKNOWN_CMD       = 0x01
ERR_INSUFFICIENT_DATA = 0x02
ERR_TIMEOUT           = 0x03
ERR_SEU_FAULT         = 0x04


def _safe_int(sig):
    """Чтение значения сигнала, устойчивое к X/Z."""
    try:
        return int(sig.value)
    except Exception:
        return None


async def _wait_error(dut, cycles=80):
    """Ждём подъёма error_flag в течение cycles тактов.
    Возвращает (flag, code): flag=1 если ошибка обнаружена, иначе 0.
    """
    for _ in range(cycles):
        await RisingEdge(dut.clk)
        if _safe_int(dut.error_flag) == 1:
            return 1, (_safe_int(dut.error_code) or 0)
    return 0, 0


async def _drive_idle(tester):
    """Сброс входных сигналов AXIS в безопасное состояние."""
    tester.s_axis_tvalid.value = 0
    tester.s_axis_tlast.value = 0
    tester.s_axis_tdata.value = 0
    tester.s_axis_tkeep.value = 0
    tester.s_axis_tuser.value = 0


@cocotb.test()
async def test_unknown_command(dut):
    """Неизвестная команда (cmd=0xAA, не F1/F3) -> ERR_UNKNOWN_CMD.

    cutter в IDLE по s_axis_tvalid вычисляет next_state=ERROR для любой команды,
    кроме F1/F3. Удерживаем tvalid с неизвестным байтом команды и tlast=1, чтобы
    автомат вошёл в ERROR и затем штатно вернулся в IDLE.
    """
    tester = await init_tester(dut)

    addr = 0x10
    word = tester.pack_bytes([0xAA, 0x00,
                              addr & 0xFF, (addr >> 8) & 0xFF,
                              (addr >> 16) & 0xFF, (addr >> 24) & 0xFF,
                              0x00, 0x00])

    # Прямой стимул: держим tvalid=1 (не ждём tready), tlast=1 для самозавершения
    tester.s_axis_tdata.value = word
    tester.s_axis_tkeep.value = 0xFF
    tester.s_axis_tlast.value = 1
    tester.s_axis_tuser.value = 0
    tester.s_axis_tvalid.value = 1

    flag, code = await _wait_error(dut, cycles=40)

    # Снимаем стимул
    tester.s_axis_tvalid.value = 0
    tester.s_axis_tlast.value = 0
    await _drive_idle(tester)
    await ClockCycles(dut.clk, 5)

    assert flag == 1, "error_flag не выставлен при неизвестной команде 0xAA"
    assert code == ERR_UNKNOWN_CMD, \
        f"ожидался ERR_UNKNOWN_CMD=0x{ERR_UNKNOWN_CMD:02X}, получен 0x{code:02X}"
    cocotb.log.info("test_unknown_command: обнаружена неизвестная команда, code=0x%02X" % code)


@cocotb.test()
async def test_timeout_mid_command(dut):
    """Таймаут: команда начата (F3), но остаток (2-е слово) не приходит -> ERR_TIMEOUT.

    Вводим валидный код команды F3, чтобы автомат перешёл в WRITE, затем
    прекращаем поток. timeout_counter в cutter досчитывает до TIMEOUT_VALUE.
    """
    tester = await init_tester(dut)

    addr = 0x20
    # Первое слово валидной записи: cmd=F3, strb+prot, addr[0..3], data[0..1]
    word1 = tester.pack_bytes([0xF3, 0xF0,
                               addr & 0xFF, (addr >> 8) & 0xFF,
                               (addr >> 16) & 0xFF, (addr >> 24) & 0xFF,
                               0x11, 0x22])

    # Заводим автомат в WRITE: один такт tvalid с командой F3 (tlast=0)
    tester.s_axis_tdata.value = word1
    tester.s_axis_tkeep.value = 0xFF
    tester.s_axis_tlast.value = 0
    tester.s_axis_tuser.value = 0
    tester.s_axis_tvalid.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    # Останавливаем поток — остаток команды не приходит
    await _drive_idle(tester)

    flag, code = await _wait_error(dut, cycles=80)

    await ClockCycles(dut.clk, 5)

    assert flag == 1, "error_flag не выставлен при зависшей (незавершённой) команде"
    assert code in (ERR_TIMEOUT, ERR_INSUFFICIENT_DATA), \
        f"ожидался ERR_TIMEOUT/ERR_INSUFFICIENT_DATA, получен 0x{code:02X}"
    cocotb.log.info("test_timeout_mid_command: обнаружено зависание команды, code=0x%02X" % code)


@cocotb.test()
async def test_insufficient_data_short_packet(dut):
    """Недостаточно данных: команда записи в одном коротком слове с tlast=1.

    Команда занимает 10 байт (2 слова), но передаём только первое слово (8 байт)
    и сразу tlast. Ожидается ERR_INSUFFICIENT_DATA (или ERR_TIMEOUT как защита).
    """
    tester = await init_tester(dut)

    addr = 0x30
    word1 = tester.pack_bytes([0xF3, 0xF0,
                               addr & 0xFF, (addr >> 8) & 0xFF,
                               (addr >> 16) & 0xFF, (addr >> 24) & 0xFF,
                               0x33, 0x44])

    # Валидная команда F3, но tlast=1 уже на первом слове (всего 8 байт < 10)
    tester.s_axis_tdata.value = word1
    tester.s_axis_tkeep.value = 0xFF
    tester.s_axis_tlast.value = 1
    tester.s_axis_tuser.value = 0
    tester.s_axis_tvalid.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    await _drive_idle(tester)

    flag, code = await _wait_error(dut, cycles=80)

    await ClockCycles(dut.clk, 5)

    assert flag == 1, "error_flag не выставлен при неполной команде (8 байт вместо 10)"
    assert code in (ERR_INSUFFICIENT_DATA, ERR_TIMEOUT), \
        f"ожидался ERR_INSUFFICIENT_DATA/ERR_TIMEOUT, получен 0x{code:02X}"
    cocotb.log.info("test_insufficient_data_short_packet: обнаружена неполная команда, code=0x%02X" % code)


@cocotb.test()
async def test_recovery_after_unknown_command(dut):
    """После ошибки модуль должен восстановиться и обработать валидную запись.

    Сначала вводим неизвестную команду (ERROR), затем — корректную запись
    штатным помощником, и проверяем, что приходит нормальный ответ.
    """
    tester = await init_tester(dut)

    # 1) Неизвестная команда
    bad = tester.pack_bytes([0x55, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00])
    tester.s_axis_tdata.value = bad
    tester.s_axis_tkeep.value = 0xFF
    tester.s_axis_tlast.value = 1
    tester.s_axis_tvalid.value = 1
    await _wait_error(dut, cycles=40)
    tester.s_axis_tvalid.value = 0
    tester.s_axis_tlast.value = 0
    await _drive_idle(tester)
    await ClockCycles(dut.clk, 20)

    # 2) Валидная запись штатным помощником (проверенный путь рукопожатия)
    await tester.send_write_transaction(addr=0x10, data=0xCAFEBABE,
                                        wstrb=0xF, prot=0, is_last_in_packet=True)
    await ClockCycles(dut.clk, 10)

    resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
    assert resp_addr == 0x10, f"адрес в ответе 0x{resp_addr:08X}, ожидался 0x10"
    cocotb.log.info("test_recovery: модуль восстановился, ответ type=%d resp=%d addr=0x%X"
                    % (resp_type, resp, resp_addr))


# ============================================================================
#  СКВОЗНЫЕ ТЕСТЫ (РАУНД 2)
#
#  В отличие от тестов выше (которые проверяют только внутренний error_flag
#  на кристалле), эти тесты явно вызывают tester.receive_response() и
#  проверяют, что host РЕАЛЬНО получил пакет-ответ с кодом ошибки через
#  m_axis. Именно это было главной дырой в первой версии: детектор работал,
#  но наружу ничего не уходило (вход error_flag биндера был привязан к 0).
# ============================================================================

@cocotb.test()
async def test_e2e_unknown_command_response(dut):
    """Неизвестная команда -> host должен получить пакет type=error(0),
    resp=ERR_UNKNOWN_CMD. Раньше этот пакет не приходил вообще (тест бы
    свалился по таймауту в receive_response)."""
    tester = await init_tester(dut)

    addr = 0x10
    word = tester.pack_bytes([0xAA, 0x00,
                              addr & 0xFF, (addr >> 8) & 0xFF,
                              (addr >> 16) & 0xFF, (addr >> 24) & 0xFF,
                              0x00, 0x00])

    tester.s_axis_tdata.value = word
    tester.s_axis_tkeep.value = 0xFF
    tester.s_axis_tlast.value = 1
    tester.s_axis_tuser.value = 0
    tester.s_axis_tvalid.value = 1

    flag, code = await _wait_error(dut, cycles=40)
    tester.s_axis_tvalid.value = 0
    tester.s_axis_tlast.value = 0
    await _drive_idle(tester)

    assert flag == 1, "error_flag не выставлен при неизвестной команде"
    assert code == ERR_UNKNOWN_CMD, \
        f"внутри DUT: ожидался ERR_UNKNOWN_CMD=0x{ERR_UNKNOWN_CMD:02X}, получен 0x{code:02X}"

    # ГЛАВНАЯ ПРОВЕРКА: пакет должен реально прийти на выход m_axis
    resp_type, resp, resp_addr, value = await tester.receive_response(timeout=100)
    assert resp_type == 0, f"ожидался type=error(0) в пакете-ответе, получен type={resp_type}"
    assert resp == ERR_UNKNOWN_CMD, \
        f"в байте resp пакета-ответа ожидался ERR_UNKNOWN_CMD=0x{ERR_UNKNOWN_CMD:02X}, получен 0x{resp:02X}"
    cocotb.log.info("test_e2e_unknown_command_response: host получил пакет-ошибку "
                     "type=%d resp=0x%02X addr=0x%X" % (resp_type, resp, resp_addr))


@cocotb.test()
async def test_e2e_timeout_response_and_bus_recovery(dut):
    """Самая важная проверка из ТЗ: "не пришёл конец пакета -> таймаут ->
    шина становится доступной".

    Проверяем оба требования сразу:
      (1) host реально получает пакет-ответ с ERR_TIMEOUT/ERR_INSUFFICIENT_DATA
          (а не просто внутренний флаг на кристалле);
      (2) после этого автомат cutter'а ДЕЙСТВИТЕЛЬНО освободился и штатно
          обрабатывает следующую валидную команду — а не висит в WRITE/READ
          навсегда, как было до раунда 2.
    """
    tester = await init_tester(dut)

    addr = 0x20
    word1 = tester.pack_bytes([0xF3, 0xF0,
                               addr & 0xFF, (addr >> 8) & 0xFF,
                               (addr >> 16) & 0xFF, (addr >> 24) & 0xFF,
                               0x11, 0x22])
    tester.s_axis_tdata.value = word1
    tester.s_axis_tkeep.value = 0xFF
    tester.s_axis_tlast.value = 0
    tester.s_axis_tuser.value = 0
    tester.s_axis_tvalid.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    # Обрываем поток - конец пакета (tlast) так и не приходит
    await _drive_idle(tester)

    flag, code = await _wait_error(dut, cycles=80)
    assert flag == 1, "error_flag не выставлен при зависшей (незавершённой) команде"
    assert code in (ERR_TIMEOUT, ERR_INSUFFICIENT_DATA), \
        f"ожидался ERR_TIMEOUT/ERR_INSUFFICIENT_DATA, получен 0x{code:02X}"

    # (1) пакет-ответ должен реально прийти
    resp_type, resp, resp_addr, value = await tester.receive_response(timeout=100)
    assert resp_type == 0, f"ожидался type=error(0), получен type={resp_type}"
    assert resp == code, \
        f"resp в пакете (0x{resp:02X}) не совпадает с error_code на DUT (0x{code:02X})"

    # (2) шина должна быть реально доступна — проверяем штатной транзакцией
    await tester.send_write_transaction(addr=0x24, data=0xABCD1234,
                                        wstrb=0xF, prot=0, is_last_in_packet=True)
    resp_type2, resp2, resp_addr2, value2 = await tester.receive_response(timeout=200)
    assert resp_type2 == 3, \
        f"после восстановления ожидался type=write(3), получен type={resp_type2} " \
        f"(автомат, похоже, так и не освободился)"
    assert resp_addr2 == 0x24, f"адрес в ответе 0x{resp_addr2:08X}, ожидался 0x24"
    cocotb.log.info("test_e2e_timeout_response_and_bus_recovery: ошибка дошла до host'а "
                     "(code=0x%02X), и шина реально освободилась — следующая запись "
                     "обработана штатно" % code)


@cocotb.test()
async def test_seu_one_hot_offset_fault_injection(dut):
    """Прямая инъекция SEU: программно сбрасываем все биты one-hot регистра
    current_offset_* внутри cutter'а в 0 (как будто частица "стёрла" указатель
    смещения), не трогая остальной протокол. Проверяем, что детектор (5.2 в
    pkt2axil_cutter.sv) это ловит как ERR_SEU_FAULT, и что ошибка доходит до
    host'а пакетом-ответом.

    Это единственный тест во всём наборе, который реально эмулирует
    одиночный радиационный сбой (bit-flip), а не протокольную ошибку
    (неизвестная команда / таймаут) — то, ради чего вообще затевалась эта
    часть проекта.

    ВНИМАНИЕ (white-box тест): обращается к внутреннему сигналу cutter'а в
    обход портов модуля — dut.dut.cutter_inst.current_offset_0 (dut.dut =
    инстанс pkt2axil_top с именем "dut" внутри pkt2axil_top_tb). Это рабочий
    путь для icarus; если ваш симулятор/настройки оптимизации режут
    видимость внутренних сигналов (характерно для verilator с агрессивными
    флагами), тест аккуратно пропускается с предупреждением, а не падает
    всю сборку.
    """
    tester = await init_tester(dut)

    try:
        cutter = dut.dut.cutter_inst
        _ = cutter.current_offset_0.value  # проверяем доступность сигнала
    except (AttributeError, IndexError) as e:
        cocotb.log.warning(
            "test_seu_one_hot_offset_fault_injection: внутренние сигналы "
            "cutter'а недоступны в этом симуляторе/билде (%s) — тест "
            "пропущен. Попробуйте SIM=icarus, либо откройте иерархию "
            "сигналов в Surfer и поправьте путь dut.dut.cutter_inst.* под "
            "свой симулятор." % e
        )
        return

    await ClockCycles(dut.clk, 3)  # автомат гарантированно в IDLE, указатель в исправном one-hot

    # "Радиационный" сбой: все 4 бита one-hot указателя одновременно в 0
    # (картина "0 активных битов" из 5.2 в pkt2axil_cutter.sv)
    cutter.current_offset_0.value = 0
    cutter.current_offset_2.value = 0
    cutter.current_offset_4.value = 0
    cutter.current_offset_6.value = 0

    flag, code = await _wait_error(dut, cycles=20)

    assert flag == 1, "error_flag не выставлен при инъекции SEU в one-hot указатель"
    assert code == ERR_SEU_FAULT, \
        f"ожидался ERR_SEU_FAULT=0x{ERR_SEU_FAULT:02X}, получен 0x{code:02X}"

    resp_type, resp, resp_addr, value = await tester.receive_response(timeout=100)
    assert resp_type == 0, f"ожидался type=error(0), получен type={resp_type}"
    assert resp == ERR_SEU_FAULT, \
        f"в байте resp ожидался ERR_SEU_FAULT=0x{ERR_SEU_FAULT:02X}, получен 0x{resp:02X}"
    cocotb.log.info("test_seu_one_hot_offset_fault_injection: SEU обнаружен и дошёл "
                     "до host'а как code=0x%02X" % resp)
