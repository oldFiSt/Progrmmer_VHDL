import cocotb
import asyncio
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles, Timer
from cocotb import simulator

# Глобальные константы таймаутов
TIMEOUT_GLOBAL = 20

# Глобальный параметр паузы между отправкой слов в тактах
WORD_DELAY = 1

# ============================================================================
# Список всех тестов (для удобства управления)
# ============================================================================
# Все тесты с декоратором @cocotb.test() будут автоматически запущены cocotb
# Этот список служит для справки и может использоваться для фильтрации тестов
ALL_TESTS = [
    "test_write_response",
    "test_multiple_packets_with_varying_write_transactions",
    "test_four_writes_then_four_reads",
    "test_write_then_read_after_delay",
    "test_multiple_writes_then_reads",
    "test_multiple_write_read_cycles",
    "test_ten_writes_then_ten_reads",
    "test_write_ten_then_read_varying_sizes",
    "test_mixed_read_write_combinations",
    "test_mixed_combinations_size_2",
    "test_mixed_combinations_size_3",
    "test_mixed_combinations_size_4",
    "test_mixed_combinations_size_5",
    "test_mixed_combinations_size_6",
    "test_mixed_combinations_size_7",
    "test_mixed_combinations_size_8",
    "test_mixed_combinations_size_9",
    "test_mixed_combinations_size_10",
    "test_write_to_nonexistent_address",
    "test_read_from_nonexistent_address",
]

class Pkt2AxilTester:
    def __init__(self, dut):
        self.dut = dut
        self.clk = dut.clk
        self.sent_transactions = []
        self.received_responses = []
        # Буфер для сбора байт из потока (сохраняется между вызовами receive_response)
        self.stream_buffer = []
        
        # Входные сигналы AXI Stream
        self.s_axis_tdata = dut.s_axis_tdata
        self.s_axis_tkeep = dut.s_axis_tkeep
        self.s_axis_tuser = dut.s_axis_tuser
        self.s_axis_tvalid = dut.s_axis_tvalid
        self.s_axis_tready = dut.s_axis_tready
        self.s_axis_tlast = dut.s_axis_tlast
        
        # Выходные сигналы AXI Stream
        self.m_axis_tdata = dut.m_axis_tdata
        self.m_axis_tkeep = dut.m_axis_tkeep
        self.m_axis_tuser = dut.m_axis_tuser
        self.m_axis_tvalid = dut.m_axis_tvalid
        self.m_axis_tready = dut.m_axis_tready
        self.m_axis_tlast = dut.m_axis_tlast
        
        # AXI-Lite сигналы для проверки (прямой доступ)
        self.axil_awvalid = dut.axil_awvalid
        self.axil_awready = dut.axil_awready
        self.axil_awaddr = dut.axil_awaddr
        self.axil_awprot = dut.axil_awprot
        self.axil_wvalid = dut.axil_wvalid
        self.axil_wready = dut.axil_wready
        self.axil_wdata = dut.axil_wdata
        self.axil_wstrb = dut.axil_wstrb
        self.axil_arvalid = dut.axil_arvalid
        self.axil_arready = dut.axil_arready
        self.axil_araddr = dut.axil_araddr
        self.axil_arprot = dut.axil_arprot
        
        # Мониторинг AXI-Lite шины (через отдельные сигналы в testbench)
        self.axil_monitor_write_addr = dut.axil_monitor_write_addr
        self.axil_monitor_write_data = dut.axil_monitor_write_data
        self.axil_monitor_write_strb = dut.axil_monitor_write_strb
        self.axil_monitor_write_prot = dut.axil_monitor_write_prot
        self.axil_monitor_write_valid = dut.axil_monitor_write_valid
        self.axil_monitor_write_captured = dut.axil_monitor_write_captured
        
        self.axil_monitor_read_addr = dut.axil_monitor_read_addr
        self.axil_monitor_read_prot = dut.axil_monitor_read_prot
        self.axil_monitor_read_valid = dut.axil_monitor_read_valid
        self.axil_monitor_read_captured = dut.axil_monitor_read_captured
    
    async def reset(self):
        """Полный сброс модуля"""
        # Очищаем буфер потока
        self.stream_buffer = []
        # Сбрасываем все входные сигналы AXI Stream
        self.s_axis_tdata.value = 0
        self.s_axis_tkeep.value = 0
        self.s_axis_tuser.value = 0
        self.s_axis_tvalid.value = 0
        self.s_axis_tlast.value = 0
        
        # Устанавливаем ready для выходного потока
        self.m_axis_tready.value = 1
        
        # Устанавливаем ready для AXI-Lite шины (чтобы транзакции могли завершиться)
        self.dut.axil_awready.value = 1
        self.dut.axil_wready.value = 1
        self.dut.axil_arready.value = 1
        
        # Выполняем сброс
        self.dut.rstn.value = 0
        await ClockCycles(self.clk, 100)
        self.dut.rstn.value = 1
        await ClockCycles(self.clk, 10)
        
        # Очищаем списки транзакций
        self.sent_transactions.clear()
        self.received_responses.clear()
        
        cocotb.log.info("Reset completed - все сигналы сброшены")
    
    async def clear_axis_state(self):
        """Сброс состояния AXI Stream между транзакциями"""
        # Сбрасываем все входные сигналы AXI Stream
        self.s_axis_tdata.value = 0
        self.s_axis_tkeep.value = 0
        self.s_axis_tuser.value = 0
        self.s_axis_tvalid.value = 0
        self.s_axis_tlast.value = 0
        
        # Устанавливаем ready для выходного потока
        self.m_axis_tready.value = 1
        
        # Ждем один такт для стабилизации
        await RisingEdge(self.clk)
    
    def pack_bytes(self, bytes_list):
        """Упаковка списка байтов в значение (little-endian)"""
        result = 0
        for i, byte_val in enumerate(bytes_list):
            result |= (byte_val & 0xFF) << (i * 8)
        return result
    
    def unpack_bytes(self, value, num_bytes=10):
        """Распаковка значения в список байтов (little-endian)
        По умолчанию распаковывает 10 байт для ответов формата 10 байт
        """
        bytes_list = []
        for i in range(num_bytes):
            bytes_list.append((value >> (i * 8)) & 0xFF)
        return bytes_list
    
    async def send_read_transaction(self, addr, prot=0, strb=0, tuser=0, delay=0, is_last_in_packet=True):
        """Отправка AXI-Lite read транзакции через AXI Stream
        Использует команду F1 (0xF1) - чтение одного регистра
        Новый формат: [cmd(1)][strb+prot(1)][addr(4)][padding(4)] = 10 байт
        Структура идентична write транзакции, только вместо data используется padding (0x00)
        
        Args:
            addr: адрес для чтения
            prot: защита AXI-Lite (по умолчанию 0)
            strb: строб-сигналы (по умолчанию 0)
            tuser: пользовательские данные AXI Stream (по умолчанию 0)
            delay: задержка перед началом отправки транзакции в тактах (по умолчанию 0)
            is_last_in_packet: флаг последней транзакции в пакете (по умолчанию True)
        
        Примечание: пауза между словами задается глобальным параметром WORD_DELAY
        """
        if delay > 0:
            await ClockCycles(self.clk, delay)
        
        # Формируем транзакцию: 10 байт
        # Первое слово (байты 0-7)
        byte0 = 0xF1  # Команда F1
        # strb+prot: [strb[3:0], prot[2:0], 1'b0]
        byte1 = (strb & 0x0F) | ((prot & 0x07) << 4)
        byte2 = addr & 0xFF  # addr[7:0]
        byte3 = (addr >> 8) & 0xFF  # addr[15:8]
        byte4 = (addr >> 16) & 0xFF  # addr[23:16]
        byte5 = (addr >> 24) & 0xFF  # addr[31:24]
        byte6 = 0x00  # padding[7:0] (вместо data[7:0])
        byte7 = 0x00  # padding[15:8] (вместо data[15:8])
        
        tdata1 = self.pack_bytes([byte0, byte1, byte2, byte3, byte4, byte5, byte6, byte7])
        tkeep1 = 0xFF  # Все 8 байт валидны
        
        await self._send_transaction_word(tdata1, tkeep1, False, tuser)
        cocotb.log.info(f"Отправка F1 read транзакции, слово 1: payload=0x{tdata1:016X}, tkeep=0x{tkeep1:02X}")
        
        # Пауза между словами, если указана в глобальном параметре
        if WORD_DELAY > 0:
            # Убеждаемся, что tvalid сброшен перед паузой
            self.s_axis_tvalid.value = 0
            # Сбрасываем данные, чтобы не было неопределенных значений
            # Важно: tlast должен всегда иметь определенное значение (0 или 1), никогда не быть неопределенным
            self.s_axis_tdata.value = 0
            self.s_axis_tkeep.value = 0
            self.s_axis_tlast.value = 0  # Устанавливаем tlast=0, так как это не последнее слово
            # Выполняем паузу через ClockCycles - просто и надежно
            # Тесты не должны смотреть внутрь модуля, только оперировать шинами данных
            await ClockCycles(self.clk, WORD_DELAY)
        
        # Второе слово (байты 8-9, остальные padding если последняя транзакция)
        byte0_word2 = 0x00  # padding[23:16] (вместо data[23:16])
        byte1_word2 = 0x00  # padding[31:24] (вместо data[31:24])
        
        if is_last_in_packet:
            # Последняя транзакция, остальные байты - padding
            tdata2 = self.pack_bytes([byte0_word2, byte1_word2, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA])
            tkeep2 = 0x03  # Первые 2 байта валидны, остальные padding
        else:
            # Не последняя транзакция, только 2 байта данных
            tdata2 = self.pack_bytes([byte0_word2, byte1_word2, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
            tkeep2 = 0x03  # Первые 2 байта валидны
        
        await self._send_transaction_word(tdata2, tkeep2, is_last_in_packet, tuser)
        cocotb.log.info(f"Отправка F1 read транзакции, слово 2: payload=0x{tdata2:016X}, tkeep=0x{tkeep2:02X}, tlast={is_last_in_packet}")
        
        self.sent_transactions.append(('read', addr, 0, strb, prot))

    async def send_write_transaction(self, addr, data, wstrb=0xF, prot=0, tuser=0, delay=0, is_last_in_packet=True):
        """Отправка AXI-Lite write транзакции через AXI Stream
        Использует команду F3 (0xF3) - запись в один регистр
        Новый формат: [cmd(1)][strb+prot(1)][addr(4)][data(4)] = 10 байт
        
        Args:
            addr: адрес для записи
            data: данные для записи
            wstrb: строб-сигналы записи (по умолчанию 0xF)
            prot: защита AXI-Lite (по умолчанию 0)
            tuser: пользовательские данные AXI Stream (по умолчанию 0)
            delay: задержка перед началом отправки транзакции в тактах (по умолчанию 0)
            is_last_in_packet: флаг последней транзакции в пакете (по умолчанию True)
        
        Примечание: пауза между словами задается глобальным параметром WORD_DELAY
        """
        if delay > 0:
            await ClockCycles(self.clk, delay)
        
        # Формируем транзакцию: 10 байт
        # Первое слово (байты 0-7)
        byte0 = 0xF3  # Команда F3
        # strb+prot: [strb[3:0], prot[2:0], 1'b0]
        byte1 = (wstrb & 0x0F) | ((prot & 0x07) << 4)
        byte2 = addr & 0xFF  # addr[7:0]
        byte3 = (addr >> 8) & 0xFF  # addr[15:8]
        byte4 = (addr >> 16) & 0xFF  # addr[23:16]
        byte5 = (addr >> 24) & 0xFF  # addr[31:24]
        byte6 = data & 0xFF  # data[7:0]
        byte7 = (data >> 8) & 0xFF  # data[15:8]
        
        tdata1 = self.pack_bytes([byte0, byte1, byte2, byte3, byte4, byte5, byte6, byte7])
        tkeep1 = 0xFF  # Все 8 байт валидны
        
        await self._send_transaction_word(tdata1, tkeep1, False, tuser)
        cocotb.log.info(f"Отправка F3 write транзакции, слово 1: payload=0x{tdata1:016X}, tkeep=0x{tkeep1:02X}")
        
        # Пауза между словами, если указана в глобальном параметре
        if WORD_DELAY > 0:
            # Убеждаемся, что tvalid сброшен перед паузой
            self.s_axis_tvalid.value = 0
            # Сбрасываем данные, чтобы не было неопределенных значений
            # Важно: tlast должен всегда иметь определенное значение (0 или 1), никогда не быть неопределенным
            self.s_axis_tdata.value = 0
            self.s_axis_tkeep.value = 0
            self.s_axis_tlast.value = 0  # Устанавливаем tlast=0, так как это не последнее слово
            # Выполняем паузу через ClockCycles - просто и надежно
            # Тесты не должны смотреть внутрь модуля, только оперировать шинами данных
            await ClockCycles(self.clk, WORD_DELAY)
        
        # Второе слово (байты 8-9, остальные padding если последняя транзакция)
        byte0_word2 = (data >> 16) & 0xFF  # data[23:16]
        byte1_word2 = (data >> 24) & 0xFF  # data[31:24]
        
        if is_last_in_packet:
            # Последняя транзакция, остальные байты - padding
            tdata2 = self.pack_bytes([byte0_word2, byte1_word2, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA])
            tkeep2 = 0x03  # Первые 2 байта валидны, остальные padding
        else:
            # Не последняя транзакция, только 2 байта данных
            tdata2 = self.pack_bytes([byte0_word2, byte1_word2, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
            tkeep2 = 0x03  # Первые 2 байта валидны
        
        await self._send_transaction_word(tdata2, tkeep2, is_last_in_packet, tuser)
        cocotb.log.info(f"Отправка F3 write транзакции, слово 2: payload=0x{tdata2:016X}, tkeep=0x{tkeep2:02X}, tlast={is_last_in_packet}")
        
        self.sent_transactions.append(('write', addr, data, wstrb, prot))

    async def _send_transaction_word(self, tdata, tkeep, tlast, tuser, delay=0):
        if delay > 0:
            await ClockCycles(self.clk, delay)
        
        # Устанавливаем данные заранее
        # Важно: tlast должен всегда иметь определенное значение (0 или 1), никогда не быть неопределенным
        self.s_axis_tdata.value = tdata
        self.s_axis_tkeep.value = tkeep
        self.s_axis_tuser.value = tuser
        self.s_axis_tlast.value = tlast
        self.s_axis_tvalid.value = 0
        
        # Ждем один такт для стабилизации сигналов после установки данных
        await RisingEdge(self.clk)
        
        # Отправляем данные на каждом такте, пока DUT готов принимать
        word_sent = False
        timeout_counter = 0
        max_timeout = 1000
        
        while not word_sent:
            if timeout_counter >= max_timeout:
                cocotb.log.error(f"Таймаут при отправке слова после {max_timeout} тактов")
                assert False, f"Таймаут при отправке слова после {max_timeout} тактов"
            
            # Проверяем готовность DUT ПЕРЕД установкой valid
            ready_before = self.s_axis_tready.value
            
            # Если ready активен, устанавливаем valid
            if ready_before == 1:
                self.s_axis_tvalid.value = 1
            else:
                self.s_axis_tvalid.value = 0
            
            # Ждем такт - передача происходит на границе такта, если оба сигнала активны
            await RisingEdge(self.clk)
            timeout_counter += 1
            
            # Проверяем, что данные были приняты
            if ready_before == 1:
                word_sent = True
                # Снимаем valid и tlast после успешной передачи
                self.s_axis_tvalid.value = 0
                self.s_axis_tlast.value = 0
                # Сбрасываем остальные сигналы для чистого состояния
                self.s_axis_tdata.value = 0
                self.s_axis_tkeep.value = 0
                self.s_axis_tuser.value = 0

    async def send_mixed_transaction_packet(self, transactions, tuser=0, delay=0):
        """Отправка смешанного пакета транзакций (чтение и запись в любом порядке)
        Команды могут идти без разрыва потока - следующая команда может начинаться в середине слова
        
        Args:
            transactions: список кортежей [(cmd, addr, data, wstrb, prot), ...]
                cmd: 'read' (F1) или 'write' (F3)
                Для read: data игнорируется
            tuser: пользовательские данные AXI Stream (по умолчанию 0)
            delay: задержка перед началом отправки пакета в тактах (по умолчанию 0)
        
        Примечание: пауза между словами задается глобальным параметром WORD_DELAY
        """
        if delay > 0:
            await ClockCycles(self.clk, delay)
        
        cocotb.log.info(f"Отправка смешанного пакета из {len(transactions)} транзакций без разрыва потока и без padding")
        
        # Формируем непрерывный поток байтов без padding
        # Новый формат:
        # Read: [cmd(1)][strb+prot(1)][addr(4)][padding(4)] = 10 байт
        # Write: [cmd(1)][strb+prot(1)][addr(4)][data(4)] = 10 байт
        # strb+prot: [strb[3:0], prot[2:0], 1'b0]
        all_bytes = []
        for cmd, addr, data, wstrb, prot in transactions:
            if cmd == 'read':
                # F1: [F1][strb+prot][addr(4)][padding(4)] = 10 байт
                all_bytes.append(0xF1)  # cmd
                # strb+prot: [strb[3:0], prot[2:0], 1'b0]
                strb_prot_byte = (wstrb & 0x0F) | ((prot & 0x07) << 4)
                all_bytes.append(strb_prot_byte)
                all_bytes.append(addr & 0xFF)  # addr[7:0]
                all_bytes.append((addr >> 8) & 0xFF)  # addr[15:8]
                all_bytes.append((addr >> 16) & 0xFF)  # addr[23:16]
                all_bytes.append((addr >> 24) & 0xFF)  # addr[31:24]
                all_bytes.append(0x00)  # padding[7:0]
                all_bytes.append(0x00)  # padding[15:8]
                all_bytes.append(0x00)  # padding[23:16]
                all_bytes.append(0x00)  # padding[31:24]
                # Всего 10 байт для read транзакции
            elif cmd == 'write':
                # F3: [F3][strb+prot][addr(4)][data(4)] = 10 байт
                all_bytes.append(0xF3)  # cmd
                # strb+prot: [strb[3:0], prot[2:0], 1'b0]
                strb_prot_byte = (wstrb & 0x0F) | ((prot & 0x07) << 4)
                all_bytes.append(strb_prot_byte)
                all_bytes.append(addr & 0xFF)  # addr[7:0]
                all_bytes.append((addr >> 8) & 0xFF)  # addr[15:8]
                all_bytes.append((addr >> 16) & 0xFF)  # addr[23:16]
                all_bytes.append((addr >> 24) & 0xFF)  # addr[31:24]
                all_bytes.append(data & 0xFF)  # data[7:0]
                all_bytes.append((data >> 8) & 0xFF)  # data[15:8]
                all_bytes.append((data >> 16) & 0xFF)  # data[23:16]
                all_bytes.append((data >> 24) & 0xFF)  # data[31:24]
                # Всего 10 байт для write транзакции
            else:
                raise ValueError(f"Неизвестная команда: {cmd}")
        
        # Отправляем байты непрерывным потоком по 8 байт в слове
        total_bytes = len(all_bytes)
        word_count = (total_bytes + 7) // 8  # Количество слов
        
        # Логируем структуру пакета
        byte_str = ' '.join([f'{b:02X}' for b in all_bytes])
        cocotb.log.info(f"Отправка непрерывного потока без padding: {total_bytes} байт в {word_count} словах")
        cocotb.log.info(f"Байты пакета: {byte_str}")
        
        for word_idx in range(word_count):
            # Формируем текущее слово (8 байт)
            word_bytes = []
            word_keep = 0
            
            for byte_idx in range(8):
                global_byte_idx = word_idx * 8 + byte_idx
                if global_byte_idx < total_bytes:
                    word_bytes.append(all_bytes[global_byte_idx])
                    word_keep |= (1 << byte_idx)  # Устанавливаем бит tkeep
                else:
                    word_bytes.append(0x00)  # padding
            
            tdata = self.pack_bytes(word_bytes)
            tkeep = word_keep
            is_last_word = (word_idx == word_count - 1)
            
            # Отправляем слово через _send_transaction_word для правильной синхронизации
            await self._send_transaction_word(tdata, tkeep, is_last_word, tuser)
            
            # Пауза между словами (кроме последнего слова), если указана в глобальном параметре
            if WORD_DELAY > 0 and not is_last_word:
                # Убеждаемся, что tvalid сброшен перед паузой
                self.s_axis_tvalid.value = 0
                # Сбрасываем данные, чтобы не было неопределенных значений
                # Важно: tlast должен всегда иметь определенное значение (0 или 1), никогда не быть неопределенным
                self.s_axis_tdata.value = 0
                self.s_axis_tkeep.value = 0
                self.s_axis_tlast.value = 0  # Устанавливаем tlast=0, так как это не последнее слово
                
                # Выполняем паузу через ClockCycles для всей паузы
                # Это может помочь избежать конфликтов с параллельными задачами
                await ClockCycles(self.clk, WORD_DELAY)
        
        # Сохраняем отправленные транзакции
        for cmd, addr, data, wstrb, prot in transactions:
            self.sent_transactions.append((cmd, addr, data, wstrb, prot))
        
        # Сбрасываем состояние шины после отправки пакета
        await self.clear_axis_state()
    
    async def receive_response(self, timeout=TIMEOUT_GLOBAL):
        """Прием ответа через выходной AXI Stream
        Формат ответа (10 байт, little-endian):
        Байт 0: {0,0,0,0,0,0,type[1:0]} - тип транзакции (2 бита)
          type[1:0]: 0 = ошибка, 1 = read, 3 = write
        Байт 1: {0,0,0,0,0,0,resp[1:0]} - статус ответа или код ошибки (2 бита)
          Значения: 0 = OKAY, 1 = EXOKAY, 2 = SLVERR, 3 = DECERR
        Байты 2-5: addr[31:0] - адрес транзакции (little-endian)
        Байты 6-9: для read — rdata[31:0]; для write/ошибка — padding (игнорируются)
        """
        # Устанавливаем ready
        self.m_axis_tready.value = 1
        
        # Ждем валидных данных и обрабатываем транзакции из буфера
        cycles = 0
        while cycles < timeout:
            await RisingEdge(self.clk)
            cycles += 1
            
            # Если valid и ready активны, читаем данные и добавляем в буфер
            if self.m_axis_tvalid.value == 1 and self.m_axis_tready.value == 1:
                # Проверяем, что данные не содержат неопределенных значений (X)
                try:
                    tdata_str = str(self.m_axis_tdata.value)
                    if 'x' in tdata_str.lower() or 'z' in tdata_str.lower():
                        cocotb.log.warning(f"Обнаружены неопределенные значения в tdata: {tdata_str}, пропускаем такт")
                        await RisingEdge(self.clk)
                        continue
                    tdata = self.m_axis_tdata.value.to_unsigned()
                except (ValueError, AttributeError) as e:
                    cocotb.log.warning(f"Ошибка чтения tdata: {e}, пропускаем такт")
                    await RisingEdge(self.clk)
                    continue
                
                try:
                    tkeep = self.m_axis_tkeep.value.to_unsigned()
                except (ValueError, AttributeError):
                    tkeep = 0xFF  # Используем значение по умолчанию
                
                # tuser может быть неопределенным, обрабатываем это безопасно
                try:
                    tuser = self.m_axis_tuser.value.to_unsigned()
                except ValueError:
                    tuser = 0  # Если значение неопределенное, используем 0
                tlast = int(self.m_axis_tlast.value)
                
                # Определяем количество валидных байт из tkeep
                valid_bytes = 0
                for i in range(8):
                    if (tkeep >> i) & 1:
                        valid_bytes += 1
                
                # Распаковываем валидные байты из текущего слова
                word_bytes = self.unpack_bytes(tdata, num_bytes=8)
                
                # Добавляем валидные байты в буфер потока
                for i in range(valid_bytes):
                    self.stream_buffer.append(word_bytes[i])
                
            
            # Пытаемся найти и обработать транзакцию в буфере
            # binder отправляет 10 байт на одну транзакцию
            response_start = -1
            for i in range(len(self.stream_buffer) - 9):  # минимум 10 байт для полного ответа
                byte0 = self.stream_buffer[i]
                if (byte0 & 0xFC) == 0 and (byte0 & 0x03) in [0, 1, 3]:
                    byte1 = self.stream_buffer[i + 1] if i + 1 < len(self.stream_buffer) else 0xFF
                    is_error_type = (byte0 & 0x03) == 0
                    # ФИКС: для error-ответа (type=0) байт resp несёт ПОЛНЫЙ
                    # 8-битный код ошибки (ERR_*, см. pkt2axil_cutter.sv), а не
                    # 2-битный AXI resp. Старая проверка "byte1 & 0xFC == 0"
                    # отбрасывала бы, например, ERR_SEU_FAULT = 0x04 (0b100) —
                    # пакет с такой ошибкой просто не распознавался бы как ответ.
                    if is_error_type or (byte1 & 0xFC) == 0:
                        response_start = i
                        break
            
            if response_start >= 0 and len(self.stream_buffer) >= response_start + 10:
                response_bytes = self.stream_buffer[response_start:response_start + 10]
                self.stream_buffer = self.stream_buffer[response_start + 10:]
                
                byte0 = response_bytes[0]
                resp_type = byte0 & 0x03
                byte1 = response_bytes[1]
                # ФИКС: раньше было "resp = byte1 & 0x03" — для обычных
                # SLVERR/DECERR (axil_bresp/axil_rresp, всегда 2 бита) это
                # ничего не меняло, но для error-ответов от cutter'а (полный
                # 8-битный ERR_*) обрезало бы код ошибки и пряталo SEU-сбои
                # под видом "OKAY". Возвращаем байт целиком.
                resp = byte1
                
                addr_byte2 = response_bytes[2] if response_bytes[2] != 0xEE else 0x00
                addr_byte3 = response_bytes[3] if response_bytes[3] != 0xEE else 0x00
                addr_byte4 = response_bytes[4] if response_bytes[4] != 0xEE else 0x00
                addr_byte5 = response_bytes[5] if response_bytes[5] != 0xEE else 0x00
                addr = addr_byte2 | (addr_byte3 << 8) | (addr_byte4 << 16) | (addr_byte5 << 24)
                
                value = 0
                if resp_type == 1:
                    value = response_bytes[6] | (response_bytes[7] << 8) | \
                           (response_bytes[8] << 16) | (response_bytes[9] << 24)
                elif resp_type == 3:
                    value = resp
                else:
                    value = resp
                
                type_name = "error" if resp_type == 0 else ("read" if resp_type == 1 else "write")
                self.received_responses.append((type_name, resp, addr, value))
                self.m_axis_tready.value = 1
                return resp_type, resp, addr, value
        
        # Таймаут
        self.m_axis_tready.value = 0
        cocotb.log.error(f"Timeout after {cycles} cycles waiting for response")
        assert False, f"Timeout waiting for response (timeout={timeout} cycles)"
    
    async def receive_all_responses(self, expected_count, timeout=TIMEOUT_GLOBAL):
        """Прием всех ожидаемых ответов"""
        cocotb.log.info(f"Waiting for {expected_count} responses...")
        received_count = 0
        
        while received_count < expected_count:
            try:
                resp_type, resp, addr, value = await self.receive_response(timeout=timeout)
                received_count += 1
                cocotb.log.info(
                    f"Received {received_count}/{expected_count} responses: "
                    f"type={'error' if resp_type == 0 else ('read' if resp_type == 1 else 'write')}, resp={resp}, "
                    f"addr=0x{addr:08X}, value=0x{value:08X}"
                )
            except AssertionError as e:
                if "Timeout" in str(e):
                    cocotb.log.error(f"Timeout waiting for response {received_count + 1}/{expected_count}")
                    raise
                else:
                    raise
        
        cocotb.log.info(f"All {expected_count} responses received successfully")
    
    async def check_axil_write_signals(self, expected_addr, expected_data, expected_wstrb, expected_prot, timeout=100):
        """Проверка AXI-Lite сигналов записи через мониторинг testbench
        
        Args:
            expected_addr: ожидаемый адрес
            expected_data: ожидаемые данные
            expected_wstrb: ожидаемый строб (4 бита)
            expected_prot: ожидаемый prot (3 бита)
            timeout: таймаут в тактах
        
        Returns:
            True если все сигналы совпадают, иначе False
        """
        timeout_counter = 0
        while timeout_counter < timeout:
            await RisingEdge(self.clk)
            timeout_counter += 1
            
            # Проверяем флаг захвата транзакции из мониторинга
            if self.axil_monitor_write_captured.value == 1:
                # Извлекаем данные из мониторинга и преобразуем в int для сравнения
                monitor_addr = int(self.axil_monitor_write_addr.value)
                monitor_data = int(self.axil_monitor_write_data.value)
                monitor_strb = int(self.axil_monitor_write_strb.value)
                monitor_prot = int(self.axil_monitor_write_prot.value)
                
                # Проверяем значения
                addr_match = monitor_addr == expected_addr
                data_match = monitor_data == expected_data
                strb_match = monitor_strb == expected_wstrb
                prot_match = monitor_prot == expected_prot
                
                if addr_match and data_match and strb_match and prot_match:
                    cocotb.log.info(
                        f"✓ AXI-Lite write сигналы проверены через мониторинг: "
                        f"addr=0x{monitor_addr:08X}, data=0x{monitor_data:08X}, "
                        f"wstrb=0x{monitor_strb:01X}, awprot=0x{monitor_prot:01X}"
                    )
                    return True
                else:
                    cocotb.log.error(
                        f"✗ AXI-Lite write сигналы не совпадают:\n"
                        f"  addr: ожидалось 0x{expected_addr:08X}, получено 0x{monitor_addr:08X} {'✓' if addr_match else '✗'}\n"
                        f"  data: ожидалось 0x{expected_data:08X}, получено 0x{monitor_data:08X} {'✓' if data_match else '✗'}\n"
                        f"  wstrb: ожидалось 0x{expected_wstrb:01X}, получено 0x{monitor_strb:01X} {'✓' if strb_match else '✗'}\n"
                        f"  awprot: ожидалось 0x{expected_prot:01X}, получено 0x{monitor_prot:01X} {'✓' if prot_match else '✗'}"
                    )
                    return False
        
        cocotb.log.error(f"Таймаут при проверке AXI-Lite write сигналов после {timeout} тактов")
        return False
    
    async def check_axil_read_signals(self, expected_addr, expected_prot, timeout=100):
        """Проверка AXI-Lite сигналов чтения через мониторинг testbench
        
        Args:
            expected_addr: ожидаемый адрес
            expected_prot: ожидаемый prot (3 бита)
            timeout: таймаут в тактах
        
        Returns:
            True если все сигналы совпадают, иначе False
        """
        timeout_counter = 0
        while timeout_counter < timeout:
            await RisingEdge(self.clk)
            timeout_counter += 1
            
            # Проверяем флаг захвата транзакции из мониторинга
            if self.axil_monitor_read_captured.value == 1:
                # Извлекаем данные из мониторинга и преобразуем в int для сравнения
                monitor_addr = int(self.axil_monitor_read_addr.value)
                monitor_prot = int(self.axil_monitor_read_prot.value)
                
                # Проверяем значения
                addr_match = monitor_addr == expected_addr
                prot_match = monitor_prot == expected_prot
                
                if addr_match and prot_match:
                    cocotb.log.info(
                        f"✓ AXI-Lite read сигналы проверены через мониторинг: "
                        f"addr=0x{monitor_addr:08X}, arprot=0x{monitor_prot:01X}"
                    )
                    return True
                else:
                    cocotb.log.error(
                        f"✗ AXI-Lite read сигналы не совпадают:\n"
                        f"  addr: ожидалось 0x{expected_addr:08X}, получено 0x{monitor_addr:08X} {'✓' if addr_match else '✗'}\n"
                        f"  arprot: ожидалось 0x{expected_prot:01X}, получено 0x{monitor_prot:01X} {'✓' if prot_match else '✗'}"
                    )
                    return False
        
        cocotb.log.error(f"Таймаут при проверке AXI-Lite read сигналов после {timeout} тактов")
        return False

async def init_tester(dut, clk_period_ns: int = 10, post_reset_cycles: int = 5) -> Pkt2AxilTester:
    """Универсальная инициализация тестера:
    - запуск тактового сигнала
    - полный сброс DUT (100 тактов rstn=0 внутри reset)
    - дополнительная пауза post_reset_cycles тактов
    """
    tester = Pkt2AxilTester(dut)
    cocotb.start_soon(Clock(dut.clk, clk_period_ns, unit="ns").start())
    await tester.reset()
    if post_reset_cycles > 0:
        await ClockCycles(dut.clk, post_reset_cycles)
    return tester

class TestErrorCollector:
    """Класс для сбора ошибок в тестах"""
    def __init__(self, test_name: str):
        self.test_name = test_name
        self.errors = []
        self.warnings = []
    
    def check(self, condition: bool, error_msg: str, warning_msg: str = None):
        """Проверка условия с сбором ошибки при провале"""
        if not condition:
            self.errors.append(error_msg)
            cocotb.log.error(f"ОШИБКА: {error_msg}")
        elif warning_msg:
            self.warnings.append(warning_msg)
            cocotb.log.warning(f"ПРЕДУПРЕЖДЕНИЕ: {warning_msg}")
        return condition
    
    def assert_check(self, condition: bool, error_msg: str):
        """Проверка с немедленным исключением при провале (для обратной совместимости)"""
        if not condition:
            self.errors.append(error_msg)
            raise AssertionError(error_msg)
        return True
    
    def report(self):
        """Вывод отчета об ошибках в конце теста"""
        if self.errors or self.warnings:
            cocotb.log.info("")
            cocotb.log.info("=" * 80)
            cocotb.log.info(f"ИТОГИ ТЕСТА: {self.test_name}")
            cocotb.log.info("=" * 80)
            
            if self.errors:
                cocotb.log.error(f"ПРОВАЛЕНО ПРОВЕРОК: {len(self.errors)}")
                for idx, error in enumerate(self.errors, 1):
                    cocotb.log.error(f"  {idx}. {error}")
            
            if self.warnings:
                cocotb.log.warning(f"ПРЕДУПРЕЖДЕНИЙ: {len(self.warnings)}")
                for idx, warning in enumerate(self.warnings, 1):
                    cocotb.log.warning(f"  {idx}. {warning}")
            
            cocotb.log.info("=" * 80)
            
            if self.errors:
                raise AssertionError(f"Тест '{self.test_name}' провален: {len(self.errors)} проверок не прошло")
        else:
            cocotb.log.info(f"✓ Тест '{self.test_name}' пройден успешно: все проверки пройдены")

def safe_assert(error_collector, condition, error_msg):
    """Безопасная проверка assert, которая собирает ошибки вместо немедленного прерывания"""
    if not condition:
        error_collector.errors.append(error_msg)
        cocotb.log.error(f"ОШИБКА: {error_msg}")
        return False
    return True

def test_with_error_reporting(test_func):
    """Декоратор для автоматического сбора и вывода ошибок в конце теста"""
    async def wrapper(dut):
        test_name = test_func.__name__
        error_collector = TestErrorCollector(test_name)
        
        try:
            await test_func(dut)
        except AssertionError as e:
            # Собираем ошибку из assert
            error_msg = str(e) if str(e) else "Assertion failed"
            error_collector.errors.append(error_msg)
        except Exception as e:
            # Собираем другие критические ошибки
            error_collector.errors.append(f"Критическая ошибка выполнения теста: {type(e).__name__}: {str(e)}")
        
        # Выводим отчет об ошибках в конце теста
        error_collector.report()
    
    # Сохраняем имя функции для cocotb
    wrapper.__name__ = test_func.__name__
    wrapper.__doc__ = test_func.__doc__
    return wrapper

# ============================================================================
# Тестовые функции (без декораторов @cocotb.test())
# ============================================================================

@cocotb.test()

async def test_write_response(dut):
    """Тест на запись: проверка bresp в ответе"""
    tester = await init_tester(dut)
    
    # Тест: запись значения в регистр по адресу 0x04
    test_addr = 0x04
    test_data = 0x12345678
    
    cocotb.log.info(f"Тест на запись: Запись значения в адрес 0x{test_addr:04X}, данные=0x{test_data:08X}")
    await tester.send_write_transaction(test_addr, test_data, wstrb=0xF, prot=0)
    
    # Ждем обработки записи
    await ClockCycles(dut.clk, 10)
    
    # Принимаем ответ на запись
    resp_type, resp, addr, bresp_value = await tester.receive_response()
    
    # Проверяем тип ответа
    assert resp_type == 3, f"Ответ должен быть write response (type=3), получен тип {resp_type}"
    cocotb.log.info(f"Тип ответа: write (code={resp_type})")
    
    # Проверяем адрес
    assert addr == test_addr, f"Адрес должен быть 0x{test_addr:04X}, получен 0x{addr:04X}"
    cocotb.log.info(f"Адрес в ответе: 0x{addr:04X}")
    
    # Проверяем bresp (должен быть 0 = OKAY для успешной записи)
    assert bresp_value == 0, f"bresp должен быть 0 (OKAY), получен {bresp_value}"
    cocotb.log.info(f"bresp в ответе: {bresp_value} (OKAY)")
    
    # Проверяем resp в байте 0 (должен быть 0 = OKAY)
    assert resp == 0, f"resp в байте 0 должен быть 0 (OKAY), получен {resp}"
    cocotb.log.info(f"resp в байте 0: {resp} (OKAY)")
    
    cocotb.log.info("Тест на запись пройден успешно!")

@cocotb.test()

async def test_multiple_packets_with_varying_write_transactions(dut):
    """Тест: отправка нескольких пакетов с 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 транзакциями записи в одном пакете"""
    tester = await init_tester(dut)
    
    # Базовые адреса для записи (используем последовательные адреса)
    base_addr = 0x0004  # TEST_RW_0
    addr_step = 0x0004  # Шаг между адресами
    
    # Тестовые данные для записи (чередуются между DEADBEEF и CAFEBABE)
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    
    # Список всех транзакций для последующей проверки ответов
    all_transactions = []  # Список кортежей (packet_num, transaction_num, addr, data)
    
    # Список для хранения всех полученных ответов (принимаются параллельно)
    # Каждый элемент - кортеж (resp_type, resp, resp_addr, bresp_value)
    all_received_responses = []
    
    # Событие для остановки приема ответов
    stop_receiving_event = asyncio.Event()
    
    # Параллельная задача для приема ответов
    async def receive_responses_task():
        """Параллельная задача для приема всех ответов и сохранения в список"""
        total_responses_received = 0
        expected_total = 55  # 1+2+3+4+5+6+7+8+9+10 = 55
        
        while not stop_receiving_event.is_set() or total_responses_received < expected_total:
            try:
                # Принимаем ответ с таймаутом
                resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
                
                # Сохраняем ответ в общий список
                all_received_responses.append((resp_type, resp, resp_addr, bresp_value))
                total_responses_received += 1
                
                
                # Если получили все ответы, выходим
                if total_responses_received >= expected_total:
                    break
                
            except AssertionError as e:
                if "Timeout" in str(e):
                    # Если таймаут и мы уже получили все ответы, выходим
                    if total_responses_received >= expected_total:
                        break
                    # Иначе продолжаем ждать - используем Timer вместо RisingEdge для избежания конфликтов
                    # Timer использует системное время, а не тактовый сигнал
                    await Timer(100, unit="ns")  # 100ns = примерно 10 тактов при 10ns периоде
                else:
                    raise
        
    
    # Запускаем параллельную задачу приема ответов
    receive_task = cocotb.start_soon(receive_responses_task())
    
    # Фаза 1: Отправляем все 10 пакетов с интервалом 10 тактов (ответы принимаются параллельно)
    for num_transactions in range(1, 11):
        
        # Формируем список транзакций для текущего пакета
        write_transactions = []
        for i in range(num_transactions):
            addr = base_addr + (i * addr_step)
            # Чередуем данные между DEADBEEF и CAFEBABE
            data = test_data_alternating[i % 2]
            write_transactions.append(('write', addr, data, 0xF, 0))
            # Сохраняем информацию о транзакции для проверки
            all_transactions.append((num_transactions, i+1, addr, data))
            cocotb.log.info(f"  Транзакция {i+1}/{num_transactions}: адрес=0x{addr:04X}, данные=0x{data:08X}")
        
        # Отправляем все транзакции в одном пакете
        await tester.send_mixed_transaction_packet(write_transactions)
        
        # Интервал 10 тактов перед следующим пакетом (кроме последнего)
        if num_transactions < 10:
            await ClockCycles(dut.clk, 100)
    
    # Ждем завершения приема всех ответов
    await ClockCycles(dut.clk, 500)  # Даем время на прием всех ответов
    stop_receiving_event.set()  # Сигнализируем задаче о необходимости остановки
    await ClockCycles(dut.clk, 200)  # Дополнительное время для завершения задачи
    
    # Распределяем полученные ответы по пакетам
    # Массивы для хранения ответов по каждому пакету (10 пакетов)
    packet_responses = [[] for _ in range(10)]
    
    response_idx = 0
    for packet_idx in range(10):
        packet_num = packet_idx + 1
        expected_responses = packet_num
        
        # Берем ответы для текущего пакета из общего списка
        for _ in range(expected_responses):
            if response_idx < len(all_received_responses):
                packet_responses[packet_idx].append(all_received_responses[response_idx])
                response_idx += 1
    
    # Фаза 2: Проверяем все полученные ответы
    
    response_idx = 0
    for packet_idx in range(10):
        packet_num = packet_idx + 1
        expected_responses = packet_num
        received_responses = len(packet_responses[packet_idx])
        
        cocotb.log.info(f"\nПроверка пакета {packet_num}: получено {received_responses}/{expected_responses} ответов")
        
        assert received_responses == expected_responses, \
            f"Пакет {packet_num}: ожидалось {expected_responses} ответов, получено {received_responses}"
        
        # Проверяем каждый ответ в пакете
        for trans_idx, (resp_type, resp, resp_addr, bresp_value) in enumerate(packet_responses[packet_idx]):
            trans_num = trans_idx + 1
            # Находим соответствующую транзакцию
            expected_packet_num, expected_trans_num, expected_addr, expected_data = all_transactions[response_idx]
            
            assert expected_packet_num == packet_num, \
                f"Несоответствие номера пакета: ожидался {packet_num}, найден {expected_packet_num}"
            assert expected_trans_num == trans_num, \
                f"Несоответствие номера транзакции: ожидалась {trans_num}, найдена {expected_trans_num}"
            
            # Проверяем корректность ответа
            assert resp_type == 3, \
                f"Пакет {packet_num}, транзакция {trans_num}: должен быть write response (type=3), получен тип {resp_type}"
            assert resp == 0, \
                f"Пакет {packet_num}, транзакция {trans_num}: должен быть OK (0), получен {resp}"
            assert resp_addr == expected_addr, \
                f"Пакет {packet_num}, транзакция {trans_num}: адрес должен быть 0x{expected_addr:04X}, получен 0x{resp_addr:04X}"
            assert bresp_value == 0, \
                f"Пакет {packet_num}, транзакция {trans_num}: bresp должен быть 0 (OKAY), получен {bresp_value}"
            
            cocotb.log.info(
                f"  ✓ Пакет {packet_num}, транзакция {trans_num}: "
                f"addr=0x{resp_addr:04X}, bresp={bresp_value}"
            )
            
            response_idx += 1
    
    cocotb.log.info("=" * 80)
    cocotb.log.info("Тест пройден успешно! Все 10 пакетов обработаны корректно.")
    cocotb.log.info(f"Всего получено и проверено ответов: {response_idx}")
    cocotb.log.info("=" * 80)

@cocotb.test()

async def test_four_writes_then_four_reads(dut):
    """Тест: 4 транзакции записи в одном пакете, затем через 10 тактов 4 транзакции чтения в одном пакете"""
    tester = await init_tester(dut)
    
    # Определяем 4 транзакции записи: по очереди DEADBEEF, CAFEBABE, DEADBEEF, CAFEBABE
    # Адреса: TEST_RW_0 (0x0004), TEST_RW_1 (0x0008), TEST_RW_2 (0x000c), TEST_RW_3 (0x0010)
    write_transactions = [
        ('write', 0x0004, 0xDEADBEEF, 0xF, 0),  # TEST_RW_0
        ('write', 0x0008, 0xCAFEBABE, 0xF, 0),  # TEST_RW_1
        ('write', 0x000c, 0xDEADBEEF, 0xF, 0),  # TEST_RW_2
        ('write', 0x0010, 0xCAFEBABE, 0xF, 0),  # TEST_RW_3
    ]
    
    cocotb.log.info(f"Тест: Выполнение {len(write_transactions)} записей в одном пакете...")
    
    # Отправляем все записи в одном пакете
    await tester.send_mixed_transaction_packet(write_transactions)
    
    # Пауза в 10 тактов после отправки транзакций записи
    await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("Все записи отправлены, ожидание 10 тактов перед чтением...")
    
    # Ждем 10 тактов перед чтением (не ждем ответов на записи)
    await ClockCycles(dut.clk, 10)
    
    # Определяем 4 транзакции чтения из тех же адресов
    read_transactions = [
        ('read', 0x0004, 0xDEADBEEF, 0xF, 0),  # TEST_RW_0
        ('read', 0x0008, 0xCAFEBABE, 0xF, 0),  # TEST_RW_1
        ('read', 0x000c, 0xDEADBEEF, 0xF, 0),  # TEST_RW_2
        ('read', 0x0010, 0xCAFEBABE, 0xF, 0),  # TEST_RW_3
    ]
    
    cocotb.log.info(f"Тест: Выполнение {len(read_transactions)} чтений в одном пакете...")
    
    # Отправляем все чтения в одном пакете
    await tester.send_mixed_transaction_packet(read_transactions)
    
    # Ждем обработки
    await ClockCycles(dut.clk, 10)
    
    # Принимаем ответы на все чтения
    for i, (cmd, addr, expected_data, wstrb, prot) in enumerate(read_transactions):
        cocotb.log.info(f"Ожидание ответа чтения {i+1}/{len(read_transactions)} для адреса 0x{addr:04X}")
        resp_type, resp, resp_addr, read_data = await tester.receive_response(timeout=200)
        
        assert resp_type == 1, f"Ответ {i+1} должен быть read response (type=1), получен тип {resp_type}"
        assert resp == 0, f"Ответ {i+1} должен быть OK (0), получен {resp}"
        assert resp_addr == addr, f"Адрес в ответе {i+1} должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
        assert read_data == expected_data, \
            f"Прочитанные данные 0x{read_data:08X} должны совпадать с записанными 0x{expected_data:08X} для адреса 0x{addr:04X}"
        
        cocotb.log.info(f"\033[94mОтвет чтения {i+1}/{len(read_transactions)} получен:\033[0m addr=0x{resp_addr:04X}, data=0x{read_data:08X}")
    
    cocotb.log.info("Тест на 4 записи и 4 чтения пройден успешно!")

@cocotb.test()

async def test_write_then_read_after_delay(dut):
    """Тест 1: запись значения, ожидание 10 тактов, затем чтение записанного значения"""
    tester = await init_tester(dut)
    
    # Тест: запись значения в регистр TEST_RW_0 (0x0004) - rw регистр
    test_addr = 0x0004
    test_data = 0x12345678
    
    cocotb.log.info(f"Тест 1: Запись значения в адрес 0x{test_addr:04X} (TEST_RW_0), данные=0x{test_data:08X}")
    await tester.send_write_transaction(test_addr, test_data, wstrb=0xF, prot=0)
    
    # Ждем обработки записи
    await ClockCycles(dut.clk, 10)
    
    # Принимаем ответ на запись
    resp_type, resp, addr, value = await tester.receive_response(timeout=200)
    assert resp_type == 3, f"Ответ должен быть write response (type=3), получен тип {resp_type}"
    assert resp == 0, "Ответ должен быть OK (0)"
    assert addr == test_addr, f"Адрес должен быть 0x{test_addr:04X}, получен 0x{addr:04X}"
    
    cocotb.log.info("Запись выполнена успешно")
    
    # Ждем 10 тактов перед чтением
    cocotb.log.info("Ожидание 10 тактов перед чтением...")
    await ClockCycles(dut.clk, 10)
    
    # Тест: чтение значения из того же регистра
    cocotb.log.info(f"Чтение значения из адреса 0x{test_addr:04X}")
    await tester.send_read_transaction(test_addr, prot=0)
    
    # Ждем обработки чтения
    await ClockCycles(dut.clk, 10)
    
    # Принимаем ответ на чтение
    resp_type, resp, addr, read_data = await tester.receive_response(timeout=200)
    assert resp_type == 1, f"Ответ должен быть read response (type=1), получен тип {resp_type}"
    assert resp == 0, "Ответ должен быть OK (0)"
    assert addr == test_addr, f"Адрес должен быть 0x{test_addr:04X}, получен 0x{addr:04X}"
    
    cocotb.log.info(f"Чтение выполнено: данные=0x{read_data:08X}")
    
    # Проверяем, что прочитали правильные данные
    assert read_data == test_data, \
        f"Прочитанные данные 0x{read_data:08X} должны совпадать с записанными 0x{test_data:08X}"
    
    cocotb.log.info("Тест 1 пройден успешно!")

#@cocotb.test()

async def test_multiple_writes_then_reads(dut):
    """Тест 3: по очереди отправляет несколько значений, а потом вычитывает их"""
    tester = await init_tester(dut)
    
    # Определяем несколько адресов и данных для записи
    write_transactions = [
        (0x0004, 0xDEADBEEF),  # TEST_RW_0
        (0x0008, 0xCAFEBABE),  # TEST_RW_1
        (0x000c, 0x12345678),  # TEST_RW_2
    ]
    
    cocotb.log.info(f"Тест 3: Выполнение {len(write_transactions)} записей...")
    
    # Выполняем все записи
    for addr, data in write_transactions:
        cocotb.log.info(f"Запись в адрес 0x{addr:04X}, данные=0x{data:08X}")
        await tester.send_write_transaction(addr, data, wstrb=0xF, prot=0)
        
        # Ждем обработки
        await ClockCycles(dut.clk, 10)
        
        # Принимаем ответ на запись
        resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Ответ должен быть OK (0)"
        assert resp_addr == addr, f"Адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
        
        cocotb.log.info(f"Запись в адрес 0x{addr:04X} выполнена успешно")
    
    cocotb.log.info("Все записи выполнены. Начинаем чтение...")
    
    # Ждем немного перед началом чтения
    await ClockCycles(dut.clk, 10)
    
    # Читаем все записанные значения
    for addr, expected_data in write_transactions:
        cocotb.log.info(f"Чтение из адреса 0x{addr:04X}, ожидаемое значение=0x{expected_data:08X}")
        await tester.send_read_transaction(addr, prot=0)
        
        # Ждем обработки
        await ClockCycles(dut.clk, 10)
        
        # Принимаем ответ на чтение
        resp_type, resp, resp_addr, read_data = await tester.receive_response(timeout=200)
        assert resp_type == 1, f"Ответ должен быть read response (type=1), получен тип {resp_type}"
        assert resp == 0, "Ответ должен быть OK (0)"
        assert resp_addr == addr, f"Адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
        
        cocotb.log.info(f"Чтение из адреса 0x{addr:04X}: данные=0x{read_data:08X}")
        
        # Проверяем, что прочитали правильные данные
        assert read_data == expected_data, \
            f"Прочитанные данные 0x{read_data:08X} должны совпадать с записанными 0x{expected_data:08X} для адреса 0x{addr:04X}"
    
    cocotb.log.info("Тест 3 пройден успешно!")

@cocotb.test()

async def test_multiple_write_read_cycles(dut):
    """Тест 4: несколько циклов запись-чтение (несколько транзакций на запись, потом на чтение, и так несколько раз)"""
    tester = await init_tester(dut)
    
    # Определяем несколько циклов
    cycles = [
        [
            (0x0004, 0x11111111),
            (0x0008, 0x22222222),
        ],
        [
            (0x0004, 0x33333333),
            (0x0008, 0x44444444),
        ],
        [
            (0x0004, 0x55555555),
            (0x0008, 0x66666666),
        ],
    ]
    
    cocotb.log.info(f"Тест 4: Выполнение {len(cycles)} циклов запись-чтение...")
    
    for cycle_idx, cycle_writes in enumerate(cycles):
        cocotb.log.info(f"Цикл {cycle_idx + 1}: Запись {len(cycle_writes)} значений...")
        
        # Выполняем записи в цикле
        for addr, data in cycle_writes:
            await tester.send_write_transaction(addr, data, wstrb=0xF, prot=0)
            await ClockCycles(dut.clk, 10)
            
            # Принимаем ответ на запись
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
            assert resp_type == 3, f"Ответ должен быть write response (type=3), получен тип {resp_type}"
            assert resp == 0, "Ответ должен быть OK (0)"
            assert resp_addr == addr, f"Адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
        
        cocotb.log.info(f"Цикл {cycle_idx + 1}: Чтение {len(cycle_writes)} значений...")
        
        # Читаем значения
        for addr, expected_data in cycle_writes:
            await tester.send_read_transaction(addr, prot=0)
            await ClockCycles(dut.clk, 10)
            
            # Принимаем ответ на чтение
            resp_type, resp, resp_addr, read_data = await tester.receive_response(timeout=200)
            assert resp_type == 1, f"Ответ должен быть read response (type=1), получен тип {resp_type}"
            assert resp == 0, "Ответ должен быть OK (0)"
            assert resp_addr == addr, f"Адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
            assert read_data == expected_data, \
                f"Прочитанные данные 0x{read_data:08X} должны совпадать с записанными 0x{expected_data:08X}"
        
        cocotb.log.info(f"Цикл {cycle_idx + 1} завершен успешно")
    
    cocotb.log.info("Тест 4 пройден успешно!")
    
@cocotb.test()

async def test_ten_writes_then_ten_reads(dut):
    """Тест: 10 транзакций записи в одном пакете, затем через 10 тактов 10 транзакций чтения в одном пакете"""
    tester = await init_tester(dut)
    
    # Определяем 10 транзакций записи: чередуем DEADBEEF и CAFEBABE
    # Адреса: TEST_RW_0 (0x0004), TEST_RW_1 (0x0008), ..., TEST_RW_9 (0x0028)
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    write_transactions = []
    for i in range(10):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        write_transactions.append(('write', addr, data, 0xF, 0))
    
    cocotb.log.info(f"Тест: Выполнение {len(write_transactions)} записей в одном пакете...")
    
    # Отправляем все записи в одном пакете
    await tester.send_mixed_transaction_packet(write_transactions)
    
    # Пауза в 10 тактов после отправки транзакций записи
    await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("Все записи отправлены, принимаем ответы на записи...")
    
    # Принимаем ответы на все записи перед чтением
    for i, (cmd, addr, data, wstrb, prot) in enumerate(write_transactions):
        cocotb.log.info(f"Ожидание ответа записи {i+1}/{len(write_transactions)} для адреса 0x{addr:04X}")
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        
        assert resp_type == 3, f"Ответ {i+1} должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, f"Ответ {i+1} должен быть OK (0), получен {resp}"
        assert resp_addr == addr, f"Адрес в ответе {i+1} должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
        assert bresp_value == 0, f"bresp в ответе {i+1} должен быть 0 (OKAY), получен {bresp_value}"
        
        cocotb.log.info(f"Ответ записи {i+1}/{len(write_transactions)} получен: addr=0x{resp_addr:04X}, bresp={bresp_value}")
    
    cocotb.log.info("Все ответы на записи получены, ожидание 10 тактов перед чтением...")
    
    # Ждем 10 тактов перед чтением
    await ClockCycles(dut.clk, 10)
    
    # Определяем 10 транзакций чтения из тех же адресов
    read_transactions = []
    for i in range(10):
        addr = base_addr + (i * addr_step)
        expected_data = test_data_alternating[i % 2]
        read_transactions.append(('read', addr, expected_data, 0xF, 0))
    
    cocotb.log.info(f"Тест: Выполнение {len(read_transactions)} чтений в одном пакете...")
    
    # Отправляем все чтения в одном пакете
    await tester.send_mixed_transaction_packet(read_transactions)
    
    # Ждем обработки
    await ClockCycles(dut.clk, 10)
    
    # Принимаем ответы на все чтения
    for i, (cmd, addr, expected_data, wstrb, prot) in enumerate(read_transactions):
        cocotb.log.info(f"Ожидание ответа чтения {i+1}/{len(read_transactions)} для адреса 0x{addr:04X}")
        resp_type, resp, resp_addr, read_data = await tester.receive_response(timeout=200)
        
        assert resp_type == 1, f"Ответ {i+1} должен быть read response (type=1), получен тип {resp_type}"
        assert resp == 0, f"Ответ {i+1} должен быть OK (0), получен {resp}"
        assert resp_addr == addr, f"Адрес в ответе {i+1} должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
        assert read_data == expected_data, \
            f"Прочитанные данные 0x{read_data:08X} должны совпадать с записанными 0x{expected_data:08X} для адреса 0x{addr:04X}"
        
        cocotb.log.info(f"\033[94mОтвет чтения {i+1}/{len(read_transactions)} получен:\033[0m addr=0x{resp_addr:04X}, data=0x{read_data:08X}")
    
    cocotb.log.info("Тест на 10 записей и 10 чтений пройден успешно!")

@cocotb.test()
async def test_prot_and_strb_signals(dut):
    """Тест: проверка передачи prot и strb сигналов согласно спецификации AXI-Lite
    
    Спецификация AXI-Lite:
    - AWPROT/ARPROT [2:0]: Protection type
      bit[0]: 0 = Normal, Secure, 1 = Privileged, Secure
      bit[1]: 0 = Data, 1 = Instruction
      bit[2]: 0 = Non-bufferable, 1 = Bufferable
    - WSTRB [3:0]: Write strobe - указывает какие байты валидны
      bit[0]: байт 0 (младший)
      bit[1]: байт 1
      bit[2]: байт 2
      bit[3]: байт 3 (старший)
    """
    tester = await init_tester(dut)
    
    # Устанавливаем ready для AXI-Lite шины
    dut.axil_awready.value = 1
    dut.axil_wready.value = 1
    dut.axil_arready.value = 1
    
    cocotb.log.info("=" * 80)
    cocotb.log.info("Тест: Проверка передачи prot и strb сигналов")
    cocotb.log.info("=" * 80)
    
    # Тест 1: Write транзакция с различными значениями prot и strb
    test_cases_write = [
        (0x0004, 0x12345678, 0xF, 0x0, "Все байты, Normal/Data/Non-bufferable"),
        (0x0008, 0xABCDEF00, 0x3, 0x1, "Только младшие 2 байта, Privileged/Data/Non-bufferable"),
        (0x000C, 0x00FEDCBA, 0xC, 0x2, "Только старшие 2 байта, Normal/Instruction/Non-bufferable"),
        (0x0010, 0xDEADBEEF, 0x5, 0x3, "Байты 0 и 2, Privileged/Instruction/Non-bufferable"),
        (0x0014, 0xCAFEBABE, 0xA, 0x4, "Байты 1 и 3, Normal/Data/Bufferable"),
        (0x0018, 0x12345678, 0x1, 0x5, "Только байт 0, Privileged/Data/Bufferable"),
        (0x001C, 0x87654321, 0x7, 0x6, "Байты 0,1,2, Normal/Instruction/Bufferable"),
        (0x0020, 0x11223344, 0xE, 0x7, "Байты 1,2,3, Privileged/Instruction/Bufferable"),
    ]
    
    cocotb.log.info("\n--- Тест 1: Write транзакции с различными prot и strb ---")
    for addr, data, wstrb, prot, description in test_cases_write:
        cocotb.log.info(f"\nТест: {description}")
        cocotb.log.info(f"  addr=0x{addr:08X}, data=0x{data:08X}, wstrb=0x{wstrb:01X}, prot=0x{prot:01X}")
        
        # Отправляем транзакцию
        await tester.send_write_transaction(addr, data, wstrb=wstrb, prot=prot)
        
        # Ждем обработки
        await ClockCycles(dut.clk, 5)
        
        # Проверяем AXI-Lite сигналы
        signals_ok = await tester.check_axil_write_signals(addr, data, wstrb, prot, timeout=50)
        assert signals_ok, f"Проверка AXI-Lite write сигналов провалена для {description}"
        
        # Ждем завершения транзакции
        await ClockCycles(dut.clk, 5)
        
        # Принимаем ответ
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, f"Ответ должен быть OK (0), получен {resp}"
        assert resp_addr == addr, f"Адрес должен быть 0x{addr:08X}, получен 0x{resp_addr:08X}"
        
        cocotb.log.info(f"  ✓ Write транзакция успешно проверена")
    
    # Тест 2: Read транзакции с различными значениями prot
    test_cases_read = [
        (0x0004, 0x0, "Normal/Data/Non-bufferable"),
        (0x0008, 0x1, "Privileged/Data/Non-bufferable"),
        (0x000C, 0x2, "Normal/Instruction/Non-bufferable"),
        (0x0010, 0x3, "Privileged/Instruction/Non-bufferable"),
        (0x0014, 0x4, "Normal/Data/Bufferable"),
        (0x0018, 0x5, "Privileged/Data/Bufferable"),
        (0x001C, 0x6, "Normal/Instruction/Bufferable"),
        (0x0020, 0x7, "Privileged/Instruction/Bufferable"),
    ]
    
    cocotb.log.info("\n--- Тест 2: Read транзакции с различными prot ---")
    for addr, prot, description in test_cases_read:
        cocotb.log.info(f"\nТест: {description}")
        cocotb.log.info(f"  addr=0x{addr:08X}, prot=0x{prot:01X}")
        
        # Отправляем транзакцию
        await tester.send_read_transaction(addr, prot=prot, strb=0xF)
        
        # Ждем обработки
        await ClockCycles(dut.clk, 5)
        
        # Проверяем AXI-Lite сигналы
        signals_ok = await tester.check_axil_read_signals(addr, prot, timeout=50)
        assert signals_ok, f"Проверка AXI-Lite read сигналов провалена для {description}"
        
        # Ждем завершения транзакции
        await ClockCycles(dut.clk, 5)
        
        # Принимаем ответ
        resp_type, resp, resp_addr, read_data = await tester.receive_response(timeout=200)
        assert resp_type == 1, f"Ответ должен быть read response (type=1), получен тип {resp_type}"
        assert resp == 0, f"Ответ должен быть OK (0), получен {resp}"
        assert resp_addr == addr, f"Адрес должен быть 0x{addr:08X}, получен 0x{resp_addr:08X}"
        
        cocotb.log.info(f"  ✓ Read транзакция успешно проверена")
    
    cocotb.log.info("\n" + "=" * 80)
    cocotb.log.info("Тест передачи prot и strb сигналов пройден успешно!")
    cocotb.log.info("=" * 80)

@cocotb.test()

async def test_write_ten_then_read_varying_sizes(dut):
    """Тест: запись 10 значений, затем чтение пакетами разного размера (1-10 транзакций)"""
    tester = await init_tester(dut)
    
    # Базовые адреса для записи (используем последовательные адреса)
    base_addr = 0x0004  # TEST_RW_0
    addr_step = 0x0004  # Шаг между адресами
    
    # Тестовые данные для записи (чередуются между DEADBEEF и CAFEBABE)
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    cocotb.log.info("=" * 80)
    cocotb.log.info("Тест: Запись 10 значений, затем чтение пакетами разного размера (1-10 транзакций)")
    cocotb.log.info("=" * 80)
    
    # ФАЗА 1: Запись 10 значений в одном пакете
    write_transactions = []
    for i in range(10):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        write_transactions.append(('write', addr, data, 0xF, 0))
        cocotb.log.info(f"  Транзакция записи {i+1}/10: адрес=0x{addr:04X}, данные=0x{data:08X}")
    
    # Отправляем все записи в одном пакете
    await tester.send_mixed_transaction_packet(write_transactions)
    await ClockCycles(dut.clk, 10)
    
    # Принимаем ответы на все записи
    cocotb.log.info("Прием ответов на записи...")
    for i, (cmd, addr, data, wstrb, prot) in enumerate(write_transactions):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Ответ записи {i+1} должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, f"Ответ записи {i+1} должен быть OK (0), получен {resp}"
        assert resp_addr == addr, f"Адрес в ответе записи {i+1} должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
        assert bresp_value == 0, f"bresp в ответе записи {i+1} должен быть 0 (OKAY), получен {bresp_value}"
    
    cocotb.log.info("✓ Все 10 записей выполнены успешно")
    await ClockCycles(dut.clk, 10)
    
    # ФАЗА 2: Чтение пакетами разного размера (1-10 транзакций)
    
    # Список всех транзакций чтения для последующей проверки ответов
    all_read_transactions = []  # Список кортежей (packet_num, transaction_num, addr, expected_data)
    
    # Список для хранения всех полученных ответов (принимаются параллельно)
    all_received_responses = []
    
    # Событие для остановки приема ответов
    stop_receiving_event = asyncio.Event()
    
    # Параллельная задача для приема ответов
    async def receive_responses_task():
        """Параллельная задача для приема всех ответов и сохранения в список"""
        total_responses_received = 0
        expected_total = 55  # 1+2+3+4+5+6+7+8+9+10 = 55
        
        while not stop_receiving_event.is_set() or total_responses_received < expected_total:
            try:
                # Принимаем ответ с таймаутом
                resp_type, resp, resp_addr, read_data = await tester.receive_response(timeout=200)
                
                # Сохраняем ответ в общий список
                all_received_responses.append((resp_type, resp, resp_addr, read_data))
                total_responses_received += 1
                
                
                # Если получили все ответы, выходим
                if total_responses_received >= expected_total:
                    break
                
            except AssertionError as e:
                if "Timeout" in str(e):
                    # Если таймаут и мы уже получили все ответы, выходим
                    if total_responses_received >= expected_total:
                        break
                    # Иначе продолжаем ждать - используем Timer вместо RisingEdge для избежания конфликтов
                    # Timer использует системное время, а не тактовый сигнал
                    await Timer(100, unit="ns")  # 100ns = примерно 10 тактов при 10ns периоде
                else:
                    raise
        
    
    # Запускаем параллельную задачу приема ответов
    receive_task = cocotb.start_soon(receive_responses_task())
    
    # Отправляем все 10 пакетов с интервалом 100 тактов (ответы принимаются параллельно)
    for num_transactions in range(1, 11):
        
        # Формируем список транзакций чтения для текущего пакета
        read_transactions = []
        for i in range(num_transactions):
            addr = base_addr + (i * addr_step)
            expected_data = test_data_alternating[i % 2]
            read_transactions.append(('read', addr, expected_data, 0xF, 0))
            # Сохраняем информацию о транзакции для проверки
            all_read_transactions.append((num_transactions, i+1, addr, expected_data))
            cocotb.log.info(f"  Транзакция {i+1}/{num_transactions}: адрес=0x{addr:04X}, ожидаемые данные=0x{expected_data:08X}")
        
        # Отправляем все транзакции чтения в одном пакете
        await tester.send_mixed_transaction_packet(read_transactions)
        
        # Интервал 100 тактов перед следующим пакетом (кроме последнего)
        if num_transactions < 10:
            await ClockCycles(dut.clk, 100)
    
    cocotb.log.info(f"\n✓ Все 10 пакетов чтения отправлены. Всего транзакций: {len(all_read_transactions)}")
    
    # Ждем завершения приема всех ответов
    cocotb.log.info("\n--- Ожидание завершения приема всех ответов ---")
    await ClockCycles(dut.clk, 500)  # Даем время на прием всех ответов
    stop_receiving_event.set()  # Сигнализируем задаче о необходимости остановки
    await ClockCycles(dut.clk, 200)  # Дополнительное время для завершения задачи
    
    # Распределяем полученные ответы по пакетам
    # Массивы для хранения ответов по каждому пакету (10 пакетов)
    packet_responses = [[] for _ in range(10)]
    
    response_idx = 0
    for packet_idx in range(10):
        packet_num = packet_idx + 1
        expected_responses = packet_num
        
        # Берем ответы для текущего пакета из общего списка
        for _ in range(expected_responses):
            if response_idx < len(all_received_responses):
                packet_responses[packet_idx].append(all_received_responses[response_idx])
                response_idx += 1
    
    cocotb.log.info(f"Распределено ответов по пакетам: {response_idx} из {len(all_received_responses)} полученных")
    
    # ФАЗА 3: Проверяем все полученные ответы
    
    response_idx = 0
    for packet_idx in range(10):
        packet_num = packet_idx + 1
        expected_responses = packet_num
        received_responses = len(packet_responses[packet_idx])
        
        cocotb.log.info(f"\nПроверка пакета {packet_num}: получено {received_responses}/{expected_responses} ответов")
        
        assert received_responses == expected_responses, \
            f"Пакет {packet_num}: ожидалось {expected_responses} ответов, получено {received_responses}"
        
        # Проверяем каждый ответ в пакете
        for trans_idx, (resp_type, resp, resp_addr, read_data) in enumerate(packet_responses[packet_idx]):
            trans_num = trans_idx + 1
            # Находим соответствующую транзакцию
            expected_packet_num, expected_trans_num, expected_addr, expected_data = all_read_transactions[response_idx]
            
            assert expected_packet_num == packet_num, \
                f"Несоответствие номера пакета: ожидался {packet_num}, найден {expected_packet_num}"
            assert expected_trans_num == trans_num, \
                f"Несоответствие номера транзакции: ожидалась {trans_num}, найдена {expected_trans_num}"
            
            # Проверяем корректность ответа
            assert resp_type == 1, \
                f"Пакет {packet_num}, транзакция {trans_num}: должен быть read response (type=1), получен тип {resp_type}"
            assert resp == 0, \
                f"Пакет {packet_num}, транзакция {trans_num}: должен быть OK (0), получен {resp}"
            assert resp_addr == expected_addr, \
                f"Пакет {packet_num}, транзакция {trans_num}: адрес должен быть 0x{expected_addr:04X}, получен 0x{resp_addr:04X}"
            assert read_data == expected_data, \
                f"Пакет {packet_num}, транзакция {trans_num}: прочитанные данные 0x{read_data:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"
            
            cocotb.log.info(
                f"  ✓ Пакет {packet_num}, транзакция {trans_num}: "
                f"addr=0x{resp_addr:04X}, data=0x{read_data:08X}"
            )
            
            response_idx += 1
    
    cocotb.log.info("=" * 80)
    cocotb.log.info("Тест пройден успешно! Все 10 пакетов чтения обработаны корректно.")
    cocotb.log.info(f"Всего получено и проверено ответов: {response_idx}")
    cocotb.log.info("=" * 80)



@cocotb.test()

async def test_mixed_read_write_combinations(dut):
    """Тест: все возможные комбинации чтения и записи по 4 транзакции в одном пакете"""
    tester = await init_tester(dut)
    
    # Базовые адреса для транзакций
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    # Определяем все возможные комбинации из 4 транзакций
    # Каждая комбинация - список кортежей (cmd, addr, data, wstrb, prot)
    # cmd: 'read' или 'write'
    # Примечание: комбинация с 4 записями исключена, так как она уже проверяется в других тестах
    combinations = [
        # 3 записи, 1 чтение
        [
            ('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
            ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
            ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
        ],
        # 2 записи, 2 чтения (чередование)
        [
            ('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
            ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
        ],
        # 2 записи, 2 чтения (сначала записи, потом чтения)
        [
            ('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
            ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
            ('read', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
        ],
        # 2 записи, 2 чтения (сначала чтения, потом записи)
        [
            ('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
            ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
            ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
        ],
        # 1 запись, 3 чтения
        [
            ('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
            ('read', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
        ],
        # 1 запись, 3 чтения (запись в конце)
        [
            ('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
            ('read', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
            ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
        ],
        # 4 чтения
        [
            ('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
            ('read', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
        ],
        # 1 чтение, 1 запись, 1 чтение, 1 запись
        [
            ('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
            ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
            ('read', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
            ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
        ],
        # 1 запись, 1 чтение, 1 запись, 1 чтение
        [
            ('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
            ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
            ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
        ],
    ]
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест: Проверка {len(combinations)} комбинаций чтения и записи по 4 транзакции")
    cocotb.log.info("=" * 80)
    
    # Сначала выполняем начальные записи для всех адресов, чтобы чтения могли прочитать данные
    cocotb.log.info("\n--- Инициализация: запись начальных значений во все адреса ---")
    init_writes = []
    for i in range(4):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        init_writes.append(('write', addr, data, 0xF, 0))
    
    await tester.send_mixed_transaction_packet(init_writes)
    await ClockCycles(dut.clk, 10)
    
    # Принимаем ответы на инициализацию
    for i in range(len(init_writes)):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Инициализация: ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Инициализация: ответ должен быть OK (0)"
    
    cocotb.log.info("Инициализация завершена")
    await ClockCycles(dut.clk, 10)
    
    # Тестируем каждую комбинацию
    for combo_idx, transactions in enumerate(combinations):
        cocotb.log.info(f"\n--- Комбинация {combo_idx + 1}/{len(combinations)} ---")
        
        # Определяем описание комбинации
        write_count = sum(1 for t in transactions if t[0] == 'write')
        read_count = sum(1 for t in transactions if t[0] == 'read')
        combo_desc = f"{write_count}W/{read_count}R"
        cocotb.log.info(f"Комбинация: {combo_desc}")
        
        # Отправляем пакет с транзакциями
        await tester.send_mixed_transaction_packet(transactions)
        await ClockCycles(dut.clk, 10)
        
        # Принимаем и проверяем ответы
        for trans_idx, (cmd, addr, expected_data, wstrb, prot) in enumerate(transactions):
            cocotb.log.info(f"Ожидание ответа транзакции {trans_idx+1}/{len(transactions)}: {cmd} addr=0x{addr:04X}")
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
            
            # Проверяем адрес
            assert resp_addr == addr, \
                f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
            
            # Проверяем тип ответа и данные
            if cmd == 'write':
                assert resp_type == 3, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть write response (type=3), получен тип {resp_type}"
                assert resp == 0, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == 0, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: bresp должен быть 0 (OKAY), получен {value}"
                cocotb.log.info(f"  ✓ Write ответ: addr=0x{resp_addr:04X}, bresp={value}")
            else:  # read
                assert resp_type == 1, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть read response (type=1), получен тип {resp_type}"
                assert resp == 0, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == expected_data, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: прочитанные данные 0x{value:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"
                cocotb.log.info(f"  ✓ Read ответ: addr=0x{resp_addr:04X}, data=0x{value:08X}")
        
        cocotb.log.info(f"Комбинация {combo_idx + 1} завершена успешно")
        
        # Пауза между комбинациями
        await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест пройден успешно! Все {len(combinations)} комбинаций обработаны корректно.")
    cocotb.log.info("=" * 80)
    await ClockCycles(dut.clk, 10)

def generate_combinations(packet_size):
    """Генерация комбинаций чтения и записи для заданного размера пакета"""
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    combinations = []
    
    if packet_size == 2:
        # 2 транзакции: все комбинации
        combinations = [
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0)],
            [('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0)],
            [('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0)],
        ]
    elif packet_size == 3:
        # 3 транзакции: основные комбинации
        combinations = [
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0)],
            [('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0)],
            [('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0)],
            [('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0)],
        ]
    elif packet_size == 4:
        # 4 транзакции: базовые комбинации как в test_mixed_read_write_combinations (WWWW можно оставить для этого теста)
        combinations = [
            # 4 записи
            [('write', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(4)],
            # 3 записи, 1 чтение
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read',  base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0)],
            # 2 записи, 2 чтения (чередование)
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read',  base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read',  base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0)],
            # 2 записи, 2 чтения (сначала записи, потом чтения)
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('read',  base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read',  base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0)],
            # 2 записи, 2 чтения (сначала чтения, потом записи)
            [('read',  base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read',  base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0)],
            # 1 запись, 3 чтения
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read',  base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('read',  base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read',  base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0)],
            # 1 запись, 3 чтения (запись в конце)
            [('read',  base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read',  base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('read',  base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0)],
            # 4 чтения
            [('read', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(4)],
            # RWRW
            [('read',  base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('read',  base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0)],
            # WRWR
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read',  base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read',  base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0)],
        ]
    elif packet_size == 5:
        # 5 транзакций: различные комбинации
        combinations = [
            [('write', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(5)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0)],
            [('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0)],
            [('read', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(5)],
        ]
    elif packet_size == 6:
        # 6 транзакций: различные комбинации
        combinations = [
            [('write', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(6)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0)],
            [('read', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0)],
        ]
    elif packet_size == 7:
        # 7 транзакций: различные комбинации
        combinations = [
            [('write', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(7)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 6*addr_step, test_data_alternating[0], 0xF, 0)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 6*addr_step, test_data_alternating[0], 0xF, 0)],
            [('read', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(7)],
        ]
    elif packet_size == 8:
        # 8 транзакций: различные комбинации
        combinations = [
            [('write', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(8)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 6*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 7*addr_step, test_data_alternating[1], 0xF, 0)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 6*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 7*addr_step, test_data_alternating[1], 0xF, 0)],
            [('read', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(8)],
        ]
    elif packet_size == 9:
        # 9 транзакций: различные комбинации
        combinations = [
            [('write', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(9)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 6*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 7*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 8*addr_step, test_data_alternating[0], 0xF, 0)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 6*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 7*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 8*addr_step, test_data_alternating[0], 0xF, 0)],
            [('read', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(9)],
        ]
    elif packet_size == 10:
        # 10 транзакций: различные комбинации
        combinations = [
            [('write', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(10)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('write', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 6*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 7*addr_step, test_data_alternating[1], 0xF, 0),
             ('read', base_addr + 8*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 9*addr_step, test_data_alternating[1], 0xF, 0)],
            [('write', base_addr + 0*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 1*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 2*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 3*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 4*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 5*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 6*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 7*addr_step, test_data_alternating[1], 0xF, 0),
             ('write', base_addr + 8*addr_step, test_data_alternating[0], 0xF, 0),
             ('read', base_addr + 9*addr_step, test_data_alternating[1], 0xF, 0)],
            [('read', base_addr + i*addr_step, test_data_alternating[i % 2], 0xF, 0) for i in range(10)],
        ]
    
    return combinations

@cocotb.test()

async def test_mixed_combinations_size_2(dut):
    """Тест: комбинации чтения и записи для пакетов из 2 транзакций"""
    tester = await init_tester(dut)
    
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    combinations = generate_combinations(2)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест: Проверка {len(combinations)} комбинаций чтения и записи по 2 транзакции")
    cocotb.log.info("=" * 80)
    
    # Инициализация: запись начальных значений
    cocotb.log.info("\n--- Инициализация: запись начальных значений ---")
    init_writes = []
    for i in range(2):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        init_writes.append(('write', addr, data, 0xF, 0))
    
    await tester.send_mixed_transaction_packet(init_writes)
    await ClockCycles(dut.clk, 10)
    
    for i in range(len(init_writes)):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Инициализация: ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Инициализация: ответ должен быть OK (0)"
    
    cocotb.log.info("Инициализация завершена")
    await ClockCycles(dut.clk, 10)
    
    # Тестируем каждую комбинацию
    for combo_idx, transactions in enumerate(combinations):
        cocotb.log.info(f"\n--- Комбинация {combo_idx + 1}/{len(combinations)} ---")
        write_count = sum(1 for t in transactions if t[0] == 'write')
        read_count = sum(1 for t in transactions if t[0] == 'read')
        cocotb.log.info(f"Комбинация: {write_count}W/{read_count}R")
        
        await tester.send_mixed_transaction_packet(transactions)
        await ClockCycles(dut.clk, 10)
        
        for trans_idx, (cmd, addr, expected_data, wstrb, prot) in enumerate(transactions):
            cocotb.log.info(f"Ожидание ответа транзакции {trans_idx+1}/{len(transactions)}: {cmd} addr=0x{addr:04X}")
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
            
            assert resp_addr == addr, \
                f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
            
            if cmd == 'write':
                assert resp_type == 3, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть write response (type=3), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: bresp должен быть 0 (OKAY), получен {value}"
            else:
                assert resp_type == 1, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть read response (type=1), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == expected_data, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: прочитанные данные 0x{value:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"
        
        await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест пройден успешно! Все {len(combinations)} комбинаций обработаны корректно.")
    cocotb.log.info("=" * 80)
    

@cocotb.test()

async def test_mixed_combinations_size_3(dut):
    """Тест: комбинации чтения и записи для пакетов из 3 транзакций"""
    tester = await init_tester(dut)
    
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    combinations = generate_combinations(3)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест: Проверка {len(combinations)} комбинаций чтения и записи по 3 транзакции")
    cocotb.log.info("=" * 80)
    
    # Инициализация: запись начальных значений
    cocotb.log.info("\n--- Инициализация: запись начальных значений ---")
    init_writes = []
    for i in range(3):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        init_writes.append(('write', addr, data, 0xF, 0))
    
    await tester.send_mixed_transaction_packet(init_writes)
    await ClockCycles(dut.clk, 10)
    
    for i in range(len(init_writes)):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Инициализация: ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Инициализация: ответ должен быть OK (0)"
    
    cocotb.log.info("Инициализация завершена")
    await ClockCycles(dut.clk, 10)
    
    # Тестируем каждую комбинацию
    for combo_idx, transactions in enumerate(combinations):
        cocotb.log.info(f"\n--- Комбинация {combo_idx + 1}/{len(combinations)} ---")
        write_count = sum(1 for t in transactions if t[0] == 'write')
        read_count = sum(1 for t in transactions if t[0] == 'read')
        cocotb.log.info(f"Комбинация: {write_count}W/{read_count}R")
        
        await tester.send_mixed_transaction_packet(transactions)
        await ClockCycles(dut.clk, 10)
        
        for trans_idx, (cmd, addr, expected_data, wstrb, prot) in enumerate(transactions):
            cocotb.log.info(f"Ожидание ответа транзакции {trans_idx+1}/{len(transactions)}: {cmd} addr=0x{addr:04X}")
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
            
            assert resp_addr == addr, \
                f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
            
            if cmd == 'write':
                assert resp_type == 3, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть write response (type=3), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: bresp должен быть 0 (OKAY), получен {value}"
            else:
                assert resp_type == 1, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть read response (type=1), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == expected_data, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: прочитанные данные 0x{value:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"
        
        await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест пройден успешно! Все {len(combinations)} комбинаций обработаны корректно.")
    cocotb.log.info("=" * 80)
    

@cocotb.test()

async def test_mixed_combinations_size_4(dut):
    """Тест: комбинации чтения и записи для пакетов из 4 транзакций"""
    tester = await init_tester(dut)

    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]

    combinations = generate_combinations(4)

    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест: Проверка {len(combinations)} комбинаций чтения и записи по 4 транзакции")
    cocotb.log.info("=" * 80)

    # Инициализация: запись начальных значений
    cocotb.log.info("\n--- Инициализация: запись начальных значений ---")
    init_writes = []
    for i in range(4):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        init_writes.append(('write', addr, data, 0xF, 0))

    await tester.send_mixed_transaction_packet(init_writes)
    await ClockCycles(dut.clk, 10)

    for _ in range(len(init_writes)):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Инициализация: ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Инициализация: ответ должен быть OK (0)"

    cocotb.log.info("Инициализация завершена")
    await ClockCycles(dut.clk, 10)

    # Тестируем каждую комбинацию
    for combo_idx, transactions in enumerate(combinations):
        cocotb.log.info(f"\n--- Комбинация {combo_idx + 1}/{len(combinations)} ---")
        write_count = sum(1 for t in transactions if t[0] == 'write')
        read_count = sum(1 for t in transactions if t[0] == 'read')
        cocotb.log.info(f"Комбинация: {write_count}W/{read_count}R")

        await tester.send_mixed_transaction_packet(transactions)
        await ClockCycles(dut.clk, 10)

        for trans_idx, (cmd, addr, expected_data, wstrb, prot) in enumerate(transactions):
            cocotb.log.info(f"Ожидание ответа транзакции {trans_idx+1}/{len(transactions)}: {cmd} addr=0x{addr:04X}")
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)

            assert resp_addr == addr, \
                f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"

            if cmd == 'write':
                assert resp_type == 3, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть write response (type=3), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: bresp должен быть 0 (OKAY), получен {value}"
            else:
                assert resp_type == 1, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть read response (type=1), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == expected_data, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: прочитанные данные 0x{value:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"

        await ClockCycles(dut.clk, 10)

    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест пройден успешно! Все {len(combinations)} комбинаций обработаны корректно.")
    cocotb.log.info("=" * 80)


@cocotb.test()

async def test_mixed_combinations_size_5(dut):
    """Тест: комбинации чтения и записи для пакетов из 5 транзакций"""
    tester = await init_tester(dut)
    
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    combinations = generate_combinations(5)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест: Проверка {len(combinations)} комбинаций чтения и записи по 5 транзакций")
    cocotb.log.info("=" * 80)
    
    # Инициализация: запись начальных значений
    cocotb.log.info("\n--- Инициализация: запись начальных значений ---")
    init_writes = []
    for i in range(5):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        init_writes.append(('write', addr, data, 0xF, 0))
    
    await tester.send_mixed_transaction_packet(init_writes)
    await ClockCycles(dut.clk, 10)
    
    for i in range(len(init_writes)):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Инициализация: ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Инициализация: ответ должен быть OK (0)"
    
    cocotb.log.info("Инициализация завершена")
    await ClockCycles(dut.clk, 10)
    
    # Тестируем каждую комбинацию
    for combo_idx, transactions in enumerate(combinations):
        cocotb.log.info(f"\n--- Комбинация {combo_idx + 1}/{len(combinations)} ---")
        write_count = sum(1 for t in transactions if t[0] == 'write')
        read_count = sum(1 for t in transactions if t[0] == 'read')
        cocotb.log.info(f"Комбинация: {write_count}W/{read_count}R")
        
        await tester.send_mixed_transaction_packet(transactions)
        await ClockCycles(dut.clk, 10)
        
        for trans_idx, (cmd, addr, expected_data, wstrb, prot) in enumerate(transactions):
            cocotb.log.info(f"Ожидание ответа транзакции {trans_idx+1}/{len(transactions)}: {cmd} addr=0x{addr:04X}")
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
            
            assert resp_addr == addr, \
                f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
            
            if cmd == 'write':
                assert resp_type == 3, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть write response (type=3), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: bresp должен быть 0 (OKAY), получен {value}"
            else:
                assert resp_type == 1, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть read response (type=1), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == expected_data, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: прочитанные данные 0x{value:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"
        
        await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест пройден успешно! Все {len(combinations)} комбинаций обработаны корректно.")
    cocotb.log.info("=" * 80)
    

@cocotb.test()

async def test_mixed_combinations_size_6(dut):
    """Тест: комбинации чтения и записи для пакетов из 6 транзакций"""
    tester = await init_tester(dut)
    
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    combinations = generate_combinations(6)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест: Проверка {len(combinations)} комбинаций чтения и записи по 6 транзакций")
    cocotb.log.info("=" * 80)
    
    # Инициализация: запись начальных значений
    cocotb.log.info("\n--- Инициализация: запись начальных значений ---")
    init_writes = []
    for i in range(6):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        init_writes.append(('write', addr, data, 0xF, 0))
    
    await tester.send_mixed_transaction_packet(init_writes)
    await ClockCycles(dut.clk, 10)
    
    for i in range(len(init_writes)):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Инициализация: ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Инициализация: ответ должен быть OK (0)"
    
    cocotb.log.info("Инициализация завершена")
    await ClockCycles(dut.clk, 10)
    
    # Тестируем каждую комбинацию
    for combo_idx, transactions in enumerate(combinations):
        cocotb.log.info(f"\n--- Комбинация {combo_idx + 1}/{len(combinations)} ---")
        write_count = sum(1 for t in transactions if t[0] == 'write')
        read_count = sum(1 for t in transactions if t[0] == 'read')
        cocotb.log.info(f"Комбинация: {write_count}W/{read_count}R")
        
        await tester.send_mixed_transaction_packet(transactions)
        await ClockCycles(dut.clk, 10)
        
        for trans_idx, (cmd, addr, expected_data, wstrb, prot) in enumerate(transactions):
            cocotb.log.info(f"Ожидание ответа транзакции {trans_idx+1}/{len(transactions)}: {cmd} addr=0x{addr:04X}")
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
            
            assert resp_addr == addr, \
                f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
            
            if cmd == 'write':
                assert resp_type == 3, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть write response (type=3), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: bresp должен быть 0 (OKAY), получен {value}"
            else:
                assert resp_type == 1, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть read response (type=1), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == expected_data, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: прочитанные данные 0x{value:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"
        
        await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест пройден успешно! Все {len(combinations)} комбинаций обработаны корректно.")
    cocotb.log.info("=" * 80)
    

@cocotb.test()

async def test_mixed_combinations_size_7(dut):
    """Тест: комбинации чтения и записи для пакетов из 7 транзакций"""
    tester = await init_tester(dut)
    
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    combinations = generate_combinations(7)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест: Проверка {len(combinations)} комбинаций чтения и записи по 7 транзакций")
    cocotb.log.info("=" * 80)
    
    # Инициализация: запись начальных значений
    cocotb.log.info("\n--- Инициализация: запись начальных значений ---")
    init_writes = []
    for i in range(7):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        init_writes.append(('write', addr, data, 0xF, 0))
    
    await tester.send_mixed_transaction_packet(init_writes)
    await ClockCycles(dut.clk, 10)
    
    for i in range(len(init_writes)):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Инициализация: ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Инициализация: ответ должен быть OK (0)"
    
    cocotb.log.info("Инициализация завершена")
    await ClockCycles(dut.clk, 10)
    
    # Тестируем каждую комбинацию
    for combo_idx, transactions in enumerate(combinations):
        cocotb.log.info(f"\n--- Комбинация {combo_idx + 1}/{len(combinations)} ---")
        write_count = sum(1 for t in transactions if t[0] == 'write')
        read_count = sum(1 for t in transactions if t[0] == 'read')
        cocotb.log.info(f"Комбинация: {write_count}W/{read_count}R")
        
        await tester.send_mixed_transaction_packet(transactions)
        await ClockCycles(dut.clk, 10)
        
        for trans_idx, (cmd, addr, expected_data, wstrb, prot) in enumerate(transactions):
            cocotb.log.info(f"Ожидание ответа транзакции {trans_idx+1}/{len(transactions)}: {cmd} addr=0x{addr:04X}")
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
            
            assert resp_addr == addr, \
                f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
            
            if cmd == 'write':
                assert resp_type == 3, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть write response (type=3), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: bresp должен быть 0 (OKAY), получен {value}"
            else:
                assert resp_type == 1, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть read response (type=1), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == expected_data, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: прочитанные данные 0x{value:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"
        
        await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест пройден успешно! Все {len(combinations)} комбинаций обработаны корректно.")
    cocotb.log.info("=" * 80)
    

@cocotb.test()

async def test_mixed_combinations_size_8(dut):
    """Тест: комбинации чтения и записи для пакетов из 8 транзакций"""
    tester = await init_tester(dut)
    
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    combinations = generate_combinations(8)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест: Проверка {len(combinations)} комбинаций чтения и записи по 8 транзакций")
    cocotb.log.info("=" * 80)
    
    # Инициализация: запись начальных значений
    cocotb.log.info("\n--- Инициализация: запись начальных значений ---")
    init_writes = []
    for i in range(8):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        init_writes.append(('write', addr, data, 0xF, 0))
    
    await tester.send_mixed_transaction_packet(init_writes)
    await ClockCycles(dut.clk, 10)
    
    for i in range(len(init_writes)):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Инициализация: ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Инициализация: ответ должен быть OK (0)"
    
    cocotb.log.info("Инициализация завершена")
    await ClockCycles(dut.clk, 10)
    
    # Тестируем каждую комбинацию
    for combo_idx, transactions in enumerate(combinations):
        cocotb.log.info(f"\n--- Комбинация {combo_idx + 1}/{len(combinations)} ---")
        write_count = sum(1 for t in transactions if t[0] == 'write')
        read_count = sum(1 for t in transactions if t[0] == 'read')
        cocotb.log.info(f"Комбинация: {write_count}W/{read_count}R")
        
        await tester.send_mixed_transaction_packet(transactions)
        await ClockCycles(dut.clk, 10)
        
        for trans_idx, (cmd, addr, expected_data, wstrb, prot) in enumerate(transactions):
            cocotb.log.info(f"Ожидание ответа транзакции {trans_idx+1}/{len(transactions)}: {cmd} addr=0x{addr:04X}")
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
            
            assert resp_addr == addr, \
                f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
            
            if cmd == 'write':
                assert resp_type == 3, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть write response (type=3), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: bresp должен быть 0 (OKAY), получен {value}"
            else:
                assert resp_type == 1, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть read response (type=1), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == expected_data, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: прочитанные данные 0x{value:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"
        
        await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест пройден успешно! Все {len(combinations)} комбинаций обработаны корректно.")
    cocotb.log.info("=" * 80)
    

@cocotb.test()

async def test_mixed_combinations_size_9(dut):
    """Тест: комбинации чтения и записи для пакетов из 9 транзакций"""
    tester = await init_tester(dut)
    
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    combinations = generate_combinations(9)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест: Проверка {len(combinations)} комбинаций чтения и записи по 9 транзакций")
    cocotb.log.info("=" * 80)
    
    # Инициализация: запись начальных значений
    cocotb.log.info("\n--- Инициализация: запись начальных значений ---")
    init_writes = []
    for i in range(9):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        init_writes.append(('write', addr, data, 0xF, 0))
    
    await tester.send_mixed_transaction_packet(init_writes)
    await ClockCycles(dut.clk, 10)
    
    for i in range(len(init_writes)):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Инициализация: ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Инициализация: ответ должен быть OK (0)"
    
    cocotb.log.info("Инициализация завершена")
    await ClockCycles(dut.clk, 10)
    
    # Тестируем каждую комбинацию
    for combo_idx, transactions in enumerate(combinations):
        cocotb.log.info(f"\n--- Комбинация {combo_idx + 1}/{len(combinations)} ---")
        write_count = sum(1 for t in transactions if t[0] == 'write')
        read_count = sum(1 for t in transactions if t[0] == 'read')
        cocotb.log.info(f"Комбинация: {write_count}W/{read_count}R")
        
        await tester.send_mixed_transaction_packet(transactions)
        await ClockCycles(dut.clk, 10)
        
        for trans_idx, (cmd, addr, expected_data, wstrb, prot) in enumerate(transactions):
            cocotb.log.info(f"Ожидание ответа транзакции {trans_idx+1}/{len(transactions)}: {cmd} addr=0x{addr:04X}")
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
            
            assert resp_addr == addr, \
                f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
            
            if cmd == 'write':
                assert resp_type == 3, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть write response (type=3), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: bresp должен быть 0 (OKAY), получен {value}"
            else:
                assert resp_type == 1, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть read response (type=1), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == expected_data, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: прочитанные данные 0x{value:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"
        
        await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест пройден успешно! Все {len(combinations)} комбинаций обработаны корректно.")
    cocotb.log.info("=" * 80)
    

@cocotb.test()

async def test_mixed_combinations_size_10(dut):
    """Тест: комбинации чтения и записи для пакетов из 10 транзакций"""
    tester = await init_tester(dut)
    
    base_addr = 0x0004
    addr_step = 0x0004
    test_data_alternating = [0xDEADBEEF, 0xCAFEBABE]
    
    combinations = generate_combinations(10)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест: Проверка {len(combinations)} комбинаций чтения и записи по 10 транзакций")
    cocotb.log.info("=" * 80)
    
    # Инициализация: запись начальных значений
    cocotb.log.info("\n--- Инициализация: запись начальных значений ---")
    init_writes = []
    for i in range(10):
        addr = base_addr + (i * addr_step)
        data = test_data_alternating[i % 2]
        init_writes.append(('write', addr, data, 0xF, 0))
    
    await tester.send_mixed_transaction_packet(init_writes)
    await ClockCycles(dut.clk, 10)
    
    for i in range(len(init_writes)):
        resp_type, resp, resp_addr, bresp_value = await tester.receive_response(timeout=200)
        assert resp_type == 3, f"Инициализация: ответ должен быть write response (type=3), получен тип {resp_type}"
        assert resp == 0, "Инициализация: ответ должен быть OK (0)"
    
    cocotb.log.info("Инициализация завершена")
    await ClockCycles(dut.clk, 10)
    
    # Тестируем каждую комбинацию
    for combo_idx, transactions in enumerate(combinations):
        cocotb.log.info(f"\n--- Комбинация {combo_idx + 1}/{len(combinations)} ---")
        write_count = sum(1 for t in transactions if t[0] == 'write')
        read_count = sum(1 for t in transactions if t[0] == 'read')
        cocotb.log.info(f"Комбинация: {write_count}W/{read_count}R")
        
        await tester.send_mixed_transaction_packet(transactions)
        await ClockCycles(dut.clk, 10)
        
        for trans_idx, (cmd, addr, expected_data, wstrb, prot) in enumerate(transactions):
            cocotb.log.info(f"Ожидание ответа транзакции {trans_idx+1}/{len(transactions)}: {cmd} addr=0x{addr:04X}")
            resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
            
            assert resp_addr == addr, \
                f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: адрес должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
            
            if cmd == 'write':
                assert resp_type == 3, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть write response (type=3), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: bresp должен быть 0 (OKAY), получен {value}"
            else:
                assert resp_type == 1, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть read response (type=1), получен тип {resp_type}"
                assert resp == 0, f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: должен быть OK (0), получен {resp}"
                assert value == expected_data, \
                    f"Комбинация {combo_idx+1}, транзакция {trans_idx+1}: прочитанные данные 0x{value:08X} должны совпадать с ожидаемыми 0x{expected_data:08X}"
        
        await ClockCycles(dut.clk, 10)
    
    cocotb.log.info("=" * 80)
    cocotb.log.info(f"Тест пройден успешно! Все {len(combinations)} комбинаций обработаны корректно.")
    cocotb.log.info("=" * 80)


@cocotb.test()
async def test_write_to_nonexistent_address(dut):
    """Тест: запись в несуществующий адрес (начиная с 0x200).
    Ожидается ответ с ошибкой: resp_type=0 (error) или resp=SLVERR(2)/DECERR(3).
    """
    tester = await init_tester(dut)

    # Адреса вне карты регистров (валидные адреса: 0x00..0xBC)
    write_transactions = [
        ('write', 0x200, 0xDEADBEEF, 0xF, 0),
        ('write', 0x204, 0xDEADBEEF, 0xF, 0),
        ('write', 0x208, 0xDEADBEEF, 0xF, 0),
        ('write', 0x20C, 0xDEADBEEF, 0xF, 0),
    ]

    cocotb.log.info("Тест: запись в несуществующие адреса 0x200, 0x204, 0x208, 0x20C")
    await tester.send_mixed_transaction_packet(write_transactions)
    await ClockCycles(dut.clk, 10)

    for i, (cmd, addr, data, wstrb, prot) in enumerate(write_transactions):
        resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
        assert resp_addr == addr, f"Адрес в ответе должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
        # Ожидаем ошибку: resp_type=0 (explicit error) ИЛИ resp=2 (SLVERR) / resp=3 (DECERR)
        is_error = (resp_type == 0) or (resp != 0)
        assert is_error, (
            f"Запись в несуществующий адрес 0x{addr:04X}: ожидалась ошибка, "
            f"получен resp_type={resp_type}, resp={resp} (0=OKAY, 2=SLVERR, 3=DECERR)"
        )
        cocotb.log.info(f"Ответ {i+1}: addr=0x{resp_addr:04X}, resp_type={resp_type}, resp={resp} (ошибка — OK)")

    cocotb.log.info("Тест записи в несуществующие адреса пройден успешно!")


@cocotb.test()
async def test_read_from_nonexistent_address(dut):
    """Тест: чтение из несуществующего адреса (начиная с 0x200).
    Ожидается ответ с ошибкой: resp_type=0 (error) или resp=SLVERR(2)/DECERR(3).
    """
    tester = await init_tester(dut)

    # Адреса вне карты регистров (валидные адреса: 0x00..0xBC)
    read_transactions = [
        ('read', 0x200, 0, 0xF, 0),
        ('read', 0x204, 0, 0xF, 0),
        ('read', 0x208, 0, 0xF, 0),
        ('read', 0x20C, 0, 0xF, 0),
    ]

    cocotb.log.info("Тест: чтение из несуществующих адресов 0x200, 0x204, 0x208, 0x20C")
    await tester.send_mixed_transaction_packet(read_transactions)
    await ClockCycles(dut.clk, 10)

    for i, (cmd, addr, expected_data, wstrb, prot) in enumerate(read_transactions):
        resp_type, resp, resp_addr, value = await tester.receive_response(timeout=200)
        assert resp_addr == addr, f"Адрес в ответе должен быть 0x{addr:04X}, получен 0x{resp_addr:04X}"
        # Ожидаем ошибку: resp_type=0 (explicit error) ИЛИ resp=2 (SLVERR) / resp=3 (DECERR)
        is_error = (resp_type == 0) or (resp != 0)
        assert is_error, (
            f"Чтение из несуществующего адреса 0x{addr:04X}: ожидалась ошибка, "
            f"получен resp_type={resp_type}, resp={resp} (0=OKAY, 2=SLVERR, 3=DECERR)"
        )
        cocotb.log.info(f"Ответ {i+1}: addr=0x{resp_addr:04X}, resp_type={resp_type}, resp={resp} (ошибка — OK)")

    cocotb.log.info("Тест чтения из несуществующих адресов пройден успешно!")
