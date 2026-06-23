# pkt-to-axil

---

## English

### Description

Module for converting AXI Stream packets to AXI-Lite transactions and back. Allows reading and writing registers through the AXI Stream interface using a special command protocol.

The `pkt2axil` module provides bidirectional conversion between AXI Stream and AXI-Lite protocols. Input commands are transmitted via AXI Stream, converted to AXI-Lite transactions, and responses are collected back into AXI Stream format.

### Key Features

- Support for read (F1) and write (F3) register commands
- Mixed packets (read and write in any order)
- Continuous command stream without breaks between transactions
- Error handling with error codes in responses
- Input and output stream buffering via FIFO

### Module Structure

#### pkt2axil_top

Top-level module that combines all system components.

**Architecture:**
```
AXI Stream Input
    ↓
[FIFO RX] → [Cutter] → AXI-Lite → [Binder] → [FIFO TX] → AXI Stream Output
```

**Main Components:**
- `axis_fifo_rx` - input FIFO buffer (depth 8192)
- `cutter_inst` - command parser module
- `binder_inst` - response formatter module
- `axis_fifo_tx` - output FIFO buffer (depth 8192, frame mode)

**Parameters:**
- `TDATA_WIDTH` - data bus width (default 64 bits)
- `TUSER_WIDTH` - tuser field width (default 8 bits)
- `TKEEP_WIDTH` - automatically calculated as `TDATA_WIDTH / 8`

#### pkt2axil_cutter

Module for parsing AXI Stream packets and converting them to AXI-Lite transactions.

**Functionality:**
- Parsing commands from data stream
- Extracting addresses, data, and control signals
- Forming AXI-Lite transactions (read/write)
- Error handling (unknown command, timeout, insufficient data)
- Tracking packet and transaction boundaries

**FSM States:**
- `IDLE` - waiting for command
- `READ` - processing read command
- `WRITE` - processing write command
- `AWAIT` - waiting for AXI-Lite transaction completion
- `END_OF_BATCH` - processing end of transaction group
- `ERROR` - error handling

**Output Signals:**
- `axil_awvalid`, `axil_awaddr`, `axil_awprot` - write address channel
- `axil_wvalid`, `axil_wdata`, `axil_wstrb` - write data channel
- `axil_arvalid`, `axil_araddr`, `axil_arprot` - read address channel
- `error_flag`, `error_code` - error signals
- `last_transaction` - indicator of last transaction in packet

#### pkt2axil_binder

Module for formatting AXI-Lite responses into AXI Stream format.

**Functionality:**
- Monitoring AXI-Lite responses (bresp, rdata, rresp)
- Forming response packets in 10-byte format
- Grouping responses for efficient transmission
- Handling errors from cutter
- Managing packet boundaries (tlast)

**FSM States:**
- `IDLE` - waiting for transaction
- `WRITE` - waiting for write response
- `READ` - waiting for read response
- `AWAIT` - waiting for output stream readiness
- `SEND_END_OF_BATCH` - sending last word in group

**Response Format:**
- **Write response:** `[padding(4)][addr(4)][resp(1)][type(1)]` = 10 bytes
- **Read response:** `[rdata(4)][addr(4)][resp(1)][type(1)]` = 10 bytes
- **Error response:** `[padding(4)][addr(4)][error_code(1)][type=0(1)]` = 10 bytes

### Command Format

#### Read Command (F1 = 0xF1)

Format: `[cmd(1)][strb+prot(1)][addr(4)][padding(4)]` = 10 bytes

- **cmd** (byte 0): `0xF1` - read command code
- **strb+prot** (byte 1): `[strb[3:0], prot[2:0], 1'b0]`
  - `strb[3:0]` - byte mask (usually not used for reads)
  - `prot[2:0]` - AXI-Lite protection (normal/privileged, secure/non-secure, data/instruction)
- **addr** (bytes 2-5): 32-bit address in little-endian format
- **padding** (bytes 6-9): `0x00` - transaction size alignment

#### Write Command (F3 = 0xF3)

Format: `[cmd(1)][strb+prot(1)][addr(4)][data(4)]` = 10 bytes

- **cmd** (byte 0): `0xF3` - write command code
- **strb+prot** (byte 1): `[strb[3:0], prot[2:0], 1'b0]`
  - `strb[3:0]` - byte mask for write (which bytes are valid)
  - `prot[2:0]` - AXI-Lite protection
- **addr** (bytes 2-5): 32-bit address in little-endian format
- **data** (bytes 6-9): 32-bit data for write in little-endian format

#### Format Features

- All fields are transmitted in **little-endian** format
- Commands can start at any byte in a 64-bit word
- Next command can start in the middle of a word without stream break
- Each transaction occupies exactly 10 bytes for alignment

### Installation and Dependencies

#### Requirements

- Python 3.6+
- Cocotb for testing
- Simulator: Icarus Verilog or Verilator
- Make

#### Installing Cocotb

```bash
pip install cocotb
```

For Verilator:
```bash
pip install cocotb[verilator]
```

### Running Tests

#### Basic Run

Navigate to the tests directory:
```bash
cd tests
```

Run all tests:
```bash
make
```

#### Run Parameters

**Simulator Selection:**
```bash
# Use Icarus Verilog (default)
make SIM=icarus

# Use Verilator
make SIM=verilator
```

**Waveform Generation:**
```bash
# With waveform generation (default)
make WAVES=1

# Without waveform generation
make WAVES=0
```

**Run Specific Test:**
```bash
make TESTCASE=test_write_read
```

**Error-Handling / Radiation-Hardening Tests:**

The main 20-odd functional tests in `pkt2axil_test.py` only exercise the
normal read/write datapath. Fault-detection and error-reporting tests live
separately in `pkt2axil_error_test.py`:
```bash
# Same Makefile, different module:
make MODULE=pkt2axil_error_test
# or the dedicated target:
make test_errors
```
Run both `make` and `make test_errors` — passing one does not imply the
other passes; they cover different parts of the design (see
`CHANGES_error_handling.md` for the full story of why this distinction
matters here).

#### Clean Results

```bash
make clean
```

This will remove:
- Generated simulation files
- Waveforms (.fst files)
- Build temporary files

#### Test Structure

Tests are located in `pkt2axil_test.py` and use the `Pkt2AxilTester` class for:
- Sending read/write commands
- Receiving and checking responses
- Testing various scenarios (single transactions, packets, errors)

### Usage Examples

#### Sending Write Command

```python
# Write value 0x12345678 at address 0x1000
await tester.send_write_transaction(
    addr=0x1000,
    data=0x12345678,
    strb=0xF,  # all bytes valid
    prot=0,   # normal, secure, data
    is_last_in_packet=True
)
```

#### Sending Read Command

```python
# Read register at address 0x1000
await tester.send_read_transaction(
    addr=0x1000,
    prot=0,
    is_last_in_packet=True
)
```

#### Receiving Response

```python
# Receive response to transaction
response = await tester.receive_response()
# response contains: addr, data (for read), resp, trans_type
```

### Error Handling

The module detects faults at the parsing/transport layer (this is primarily
aimed at radiation-induced upsets — see "Radiation hardening notes" below)
and reports them as in-band response packets with transaction type `0x00`.

Error codes:

- `0x01` - `ERR_UNKNOWN_CMD` - command byte is neither F1 (read) nor F3 (write)
- `0x02` - `ERR_INSUFFICIENT_DATA` - `tlast` arrived before all 10 bytes of a command were received
- `0x03` - `ERR_TIMEOUT` - the rest of a command never arrived (no more data, no `tlast` either); after this the bus is freed (the FSM returns to `IDLE`/`ERROR`→`IDLE`) instead of staying stuck waiting forever
- `0x04` - `ERR_SEU_FAULT` - integrity check failed: either the one-hot byte-offset pointer (`current_offset_0/2/4/6` in `pkt2axil_cutter.sv`) has 0 or >1 active bits, or the FSM state register holds a value outside the defined states — both are classic signatures of a single bit flip (SEU) in a register

**Architecture note:** `pkt2axil_cutter.sv` detects these faults and drives
`error_flag`/`error_code`. `pkt2axil_binder.sv` picks this up through a
dedicated `ERR_INJECT` state and emits the response **without** waiting for
a real AXI-Lite handshake — this matters because for `ERR_UNKNOWN_CMD` and
`ERR_TIMEOUT`/`ERR_INSUFFICIENT_DATA` no AXI-Lite transaction is ever issued
in the first place (the command was invalid/incomplete), so a design that
only reacted to `axil_bvalid`/`axil_rvalid` would never produce a response
for these cases at all.

For radiation-induced faults, the `addr` field of the error response may not
be meaningful (the failing command may not have been parsed far enough to
have a valid address) — treat it as best-effort/diagnostic for
`ERR_UNKNOWN_CMD`/`ERR_SEU_FAULT`, and as the actual target address for
`ERR_TIMEOUT`/`ERR_INSUFFICIENT_DATA` (the address is normally parsed before
the rest of the command stalls).

`pkt2axil_top` also exposes `error_flag`, `error_code[7:0]` and
`illegal_state` as separate top-level outputs (tagged
`PAP_MARK_DEBUG`) for ChipScope/ILA-style observation independent of the
response packet.

**Known limitation:** only one error is buffered at a time
(`error_pending` in `pkt2axil_binder.sv` is a single bit, not a queue). If a
new error occurs before the binder has finished emitting the response for a
previous one, only the most recent error code is guaranteed to reach the
host as a packet.

### Synthesis Parameters

The module is fully synthesizable and uses:
- Standard SystemVerilog constructs
- FSM with explicit states
- Non-blocking assignments in sequential logic
- Combinational blocks for data formation

> Synthesis has not been run as part of the error-handling work — verify
> with your toolchain before treating this as production-ready.

### Project Structure

```
pkt-to-axil/
├── rtl/                    # Module source files
│   ├── pkt2axil_top.sv     # Top level
│   ├── pkt2axil_cutter.sv  # Command parser
│   ├── pkt2axil_binder.sv  # Response formatter
│   └── pkt2axil_axis_fifo.sv  # FIFO buffers
├── tests/                  # Tests
│   ├── pkt2axil_test.py    # Python tests (cocotb)
│   ├── pkt2axil_top_tb.sv  # Testbench
│   └── Makefile            # Test build
├── test_regmap/            # Test register block
└── README.md               # This file
```

---

## Русский

### Описание

Модуль преобразования AXI Stream пакетов в AXI-Lite транзакции и обратно. Позволяет выполнять чтение и запись регистров через AXI Stream интерфейс, используя специальный протокол команд.

Модуль `pkt2axil` обеспечивает двунаправленное преобразование между AXI Stream и AXI-Lite протоколами. Входные команды передаются через AXI Stream, преобразуются в AXI-Lite транзакции, а ответы собираются обратно в AXI Stream формат.

### Основные возможности

- Поддержка команд чтения (F1) и записи (F3) регистров
- Смешанные пакеты (чтение и запись в любом порядке)
- Непрерывный поток команд без разрыва между транзакциями
- Обработка ошибок с передачей кодов ошибок в ответах
- Буферизация входного и выходного потоков через FIFO

### Структура модулей

#### pkt2axil_top

Верхний уровень модуля, объединяющий все компоненты системы.

**Архитектура:**
```
AXI Stream Input
    ↓
[FIFO RX] → [Cutter] → AXI-Lite → [Binder] → [FIFO TX] → AXI Stream Output
```

**Основные компоненты:**
- `axis_fifo_rx` - входной FIFO буфер (глубина 8192)
- `cutter_inst` - модуль парсинга команд
- `binder_inst` - модуль формирования ответов
- `axis_fifo_tx` - выходной FIFO буфер (глубина 8192, frame mode)

**Параметры:**
- `TDATA_WIDTH` - ширина шины данных (по умолчанию 64 бита)
- `TUSER_WIDTH` - ширина поля tuser (по умолчанию 8 бит)
- `TKEEP_WIDTH` - автоматически вычисляется как `TDATA_WIDTH / 8`

#### pkt2axil_cutter

Модуль парсинга AXI Stream пакетов и преобразования их в AXI-Lite транзакции.

**Функциональность:**
- Парсинг команд из потока данных
- Извлечение адресов, данных и управляющих сигналов
- Формирование AXI-Lite транзакций (чтение/запись)
- Обработка ошибок (неизвестная команда, таймаут, недостаточно данных)
- Отслеживание границ пакетов и транзакций

**Состояния FSM:**
- `IDLE` - ожидание команды
- `READ` - обработка команды чтения
- `WRITE` - обработка команды записи
- `AWAIT` - ожидание завершения AXI-Lite транзакции
- `END_OF_BATCH` - обработка конца группы транзакций
- `ERROR` - обработка ошибок

**Выходные сигналы:**
- `axil_awvalid`, `axil_awaddr`, `axil_awprot` - канал адреса записи
- `axil_wvalid`, `axil_wdata`, `axil_wstrb` - канал данных записи
- `axil_arvalid`, `axil_araddr`, `axil_arprot` - канал адреса чтения
- `error_flag`, `error_code` - сигналы ошибок
- `last_transaction` - индикатор последней транзакции в пакете

#### pkt2axil_binder

Модуль формирования ответов AXI-Lite в AXI Stream формат.

**Функциональность:**
- Мониторинг AXI-Lite ответов (bresp, rdata, rresp)
- Формирование ответных пакетов в формате 10 байт
- Группировка ответов для эффективной передачи
- Обработка ошибок от cutter
- Управление границами пакетов (tlast)

**Состояния FSM:**
- `IDLE` - ожидание транзакции
- `WRITE` - ожидание ответа на запись
- `READ` - ожидание ответа на чтение
- `AWAIT` - ожидание готовности выходного потока
- `SEND_END_OF_BATCH` - отправка последнего слова в группе

**Формат ответа:**
- **Write ответ:** `[padding(4)][addr(4)][resp(1)][type(1)]` = 10 байт
- **Read ответ:** `[rdata(4)][addr(4)][resp(1)][type(1)]` = 10 байт
- **Error ответ:** `[padding(4)][addr(4)][error_code(1)][type=0(1)]` = 10 байт

### Формат команд

#### Команда чтения (F1 = 0xF1)

Формат: `[cmd(1)][strb+prot(1)][addr(4)][padding(4)]` = 10 байт

- **cmd** (байт 0): `0xF1` - код команды чтения
- **strb+prot** (байт 1): `[strb[3:0], prot[2:0], 1'b0]`
  - `strb[3:0]` - маска байтов (для чтения обычно не используется)
  - `prot[2:0]` - защита AXI-Lite (normal/privileged, secure/non-secure, data/instruction)
- **addr** (байты 2-5): 32-битный адрес в формате little-endian
- **padding** (байты 6-9): `0x00` - выравнивание размера транзакции

#### Команда записи (F3 = 0xF3)

Формат: `[cmd(1)][strb+prot(1)][addr(4)][data(4)]` = 10 байт

- **cmd** (байт 0): `0xF3` - код команды записи
- **strb+prot** (байт 1): `[strb[3:0], prot[2:0], 1'b0]`
  - `strb[3:0]` - маска байтов для записи (какие байты валидны)
  - `prot[2:0]` - защита AXI-Lite
- **addr** (байты 2-5): 32-битный адрес в формате little-endian
- **data** (байты 6-9): 32-битные данные для записи в формате little-endian

#### Особенности формата

- Все поля передаются в формате **little-endian**
- Команды могут начинаться с любого байта в 64-битном слове
- Следующая команда может начинаться в середине слова без разрыва потока
- Каждая транзакция занимает ровно 10 байт для выравнивания

### Установка и зависимости

#### Требования

- Python 3.6+
- Cocotb для тестирования
- Симулятор: Icarus Verilog или Verilator
- Make

#### Установка Cocotb

```bash
pip install cocotb
```

Для Verilator:
```bash
pip install cocotb[verilator]
```

### Запуск тестов

#### Базовый запуск

Перейдите в директорию с тестами:
```bash
cd tests
```

Запустите все тесты:
```bash
make
```

#### Параметры запуска

**Выбор симулятора:**
```bash
# Использовать Icarus Verilog (по умолчанию)
make SIM=icarus

# Использовать Verilator
make SIM=verilator
```

**Включение генерации волновых форм:**
```bash
# С генерацией волн (по умолчанию)
make WAVES=1

# Без генерации волн
make WAVES=0
```

**Запуск конкретного теста:**
```bash
make TESTCASE=test_write_read
```

**Тесты обработки ошибок / радиационной устойчивости:**

Основные ~20 функциональных тестов в `pkt2axil_test.py` проверяют только
штатный путь чтения/записи. Тесты на обнаружение сбоев и формирование
ответа-ошибки лежат отдельно, в `pkt2axil_error_test.py`:
```bash
# Тот же Makefile, другой модуль:
make MODULE=pkt2axil_error_test
# либо отдельный таргет:
make test_errors
```
Запускайте оба варианта (`make` и `make test_errors`) — прохождение одного
НЕ означает прохождение другого, это проверка разных частей модуля
(подробности и история того, почему это важно именно здесь — в
`CHANGES_error_handling.md`).

#### Очистка результатов

```bash
make clean
```

Это удалит:
- Сгенерированные файлы симуляции
- Волновые формы (.fst файлы)
- Временные файлы сборки

#### Структура тестов

Тесты находятся в файле `pkt2axil_test.py` и используют класс `Pkt2AxilTester` для:
- Отправки команд чтения/записи
- Приема и проверки ответов
- Тестирования различных сценариев (одиночные транзакции, пакеты, ошибки)

### Примеры использования

#### Отправка команды записи

```python
# Запись значения 0x12345678 по адресу 0x1000
await tester.send_write_transaction(
    addr=0x1000,
    data=0x12345678,
    strb=0xF,  # все байты валидны
    prot=0,   # normal, secure, data
    is_last_in_packet=True
)
```

#### Отправка команды чтения

```python
# Чтение регистра по адресу 0x1000
await tester.send_read_transaction(
    addr=0x1000,
    prot=0,
    is_last_in_packet=True
)
```

#### Прием ответа

```python
# Прием ответа на транзакцию
response = await tester.receive_response()
# response содержит: addr, data (для read), resp, trans_type
```

### Обработка ошибок

Модуль обнаруживает сбои на уровне разбора команд/транспорта (направлено в
первую очередь на радиационные сбои — см. «Радиационная устойчивость» ниже)
и репортит их пакетами-ответами с типом транзакции `0x00`.

Коды ошибок:

- `0x01` - `ERR_UNKNOWN_CMD` - байт команды не равен ни F1 (чтение), ни F3 (запись)
- `0x02` - `ERR_INSUFFICIENT_DATA` - `tlast` пришёл раньше, чем набрались все 10 байт команды
- `0x03` - `ERR_TIMEOUT` - остаток команды так и не пришёл (нет ни данных, ни `tlast`); после этого шина освобождается (автомат возвращается в `IDLE` через `ERROR`), а не висит в ожидании вечно
- `0x04` - `ERR_SEU_FAULT` - не прошла проверка целостности: либо в one-hot указателе смещения байта (`current_offset_0/2/4/6` в `pkt2axil_cutter.sv`) активно 0 или больше 1 бита, либо регистр состояния автомата принял значение вне списка легальных состояний — обе ситуации характерны именно для одиночного переворота бита (SEU) в триггере

**Архитектурное замечание:** `pkt2axil_cutter.sv` обнаруживает сбой и
выставляет `error_flag`/`error_code`. `pkt2axil_binder.sv` подхватывает это
через отдельное состояние `ERR_INJECT` и формирует ответ **не дожидаясь**
реального AXI-Lite рукопожатия — это принципиально, т.к. для
`ERR_UNKNOWN_CMD` и `ERR_TIMEOUT`/`ERR_INSUFFICIENT_DATA` транзакция на
AXI-Lite вообще не запускается (команда невалидна/неполна), и реализация,
которая реагирует только на `axil_bvalid`/`axil_rvalid`, никогда не
сформировала бы для них ответ.

Для радиационных сбоев поле `addr` в ответе может быть не вполне
содержательным (неудавшаяся команда могла не дойти до разбора адреса) —
для `ERR_UNKNOWN_CMD`/`ERR_SEU_FAULT` считайте его диагностическим, а для
`ERR_TIMEOUT`/`ERR_INSUFFICIENT_DATA` — фактическим целевым адресом (адрес
обычно успевает разобраться раньше, чем стопорится остаток команды).

`pkt2axil_top` также выводит `error_flag`, `error_code[7:0]` и
`illegal_state` отдельными выходами верхнего уровня (с атрибутом
`PAP_MARK_DEBUG`) для наблюдения через ChipScope/ILA независимо от
пакета-ответа.

**Известное ограничение:** буферизуется только одна ошибка одновременно
(`error_pending` в `pkt2axil_binder.sv` — один бит, не очередь). Если новая
ошибка случается раньше, чем binder успел отправить ответ на предыдущую,
до host'а гарантированно дойдёт только код САМОЙ ПОСЛЕДНЕЙ из них.

### Параметры синтеза

Модуль полностью синтезируем и использует:
- Стандартные SystemVerilog конструкции
- FSM с явными состояниями
- Неблокирующие присваивания в последовательной логике
- Комбинаторные блоки для формирования данных

> Синтез в рамках доработки обработки ошибок не прогонялся — перепроверьте
> своим тулчейном, прежде чем считать модуль готовым к продакшену.

### Структура проекта

```
pkt-to-axil/
├── rtl/                    # Исходные файлы модулей
│   ├── pkt2axil_top.sv     # Верхний уровень
│   ├── pkt2axil_cutter.sv  # Парсер команд
│   ├── pkt2axil_binder.sv  # Формирование ответов
│   └── pkt2axil_axis_fifo.sv  # FIFO буферы
├── tests/                  # Тесты
│   ├── pkt2axil_test.py    # Python тесты (cocotb)
│   ├── pkt2axil_top_tb.sv  # Testbench
│   └── Makefile            # Сборка тестов
├── test_regmap/            # Тестовый регистровый блок
└── README.md               # Этот файл
```
