
module pkt2axil_cutter #(
    parameter  int TDATA_WIDTH = 64,
    localparam int TKEEP_WIDTH = TDATA_WIDTH / 8
) 
(
    input   logic                   clk           ,
    input   logic                   rstn          ,

    input   logic [TDATA_WIDTH-1:0] s_axis_tdata  ,
    input   logic [TKEEP_WIDTH-1:0] s_axis_tkeep  ,
    output  logic                   s_axis_tready ,
    input   logic                   s_axis_tvalid ,
    input   logic                   s_axis_tlast  ,

    output  logic                   axil_awvalid  ,
    input   logic                   axil_awready  ,
    output  logic            [31:0] axil_awaddr   ,
    output  logic             [2:0] axil_awprot   ,      
   
    output  logic                   axil_wvalid   ,
    input   logic                   axil_wready   ,
    output  logic            [31:0] axil_wdata    ,
    output  logic             [3:0] axil_wstrb    , 
   
    output  logic                   axil_arvalid  ,
    input   logic                   axil_arready  ,
    output  logic            [31:0] axil_araddr   ,
    output  logic             [2:0] axil_arprot   ,
    
    output  logic                   error_flag    ,
    output  logic             [7:0] error_code    ,
    output  logic                   illegal_state ,   // диагностика: нелегальное состояние FSM (SEU)
    output  logic                   last_transaction
);

// ============================================================================
//  Вспомогательные функции
// ============================================================================
function logic [7:0] get_byte(logic [63:0] data, logic [2:0] offset);
    case (offset)
        3'h0: return data[7:0];
        3'h1: return data[15:8];
        3'h2: return data[23:16];
        3'h3: return data[31:24];
        3'h4: return data[39:32];
        3'h5: return data[47:40];
        3'h6: return data[55:48];
        3'h7: return data[63:56];
        default: return 8'h0;
    endcase
endfunction

// ============================================================================
//  Константы / типы
// ============================================================================
localparam logic [7:0] CMD_READ  = 8'hF1;
localparam logic [7:0] CMD_WRITE = 8'hF3;
localparam logic [7:0] ERR_UNKNOWN_CMD  = 8'h01;
localparam logic [7:0] ERR_INSUFFICIENT_DATA = 8'h02;
localparam logic [7:0] ERR_TIMEOUT     = 8'h03;
localparam logic [7:0] ERR_SEU_FAULT   = 8'h04;   // сбой целостности (one-hot/illegal state)
localparam logic [3:0] TIMEOUT_VALUE   = 4'd10;

typedef enum logic [2:0] {
    IDLE,
    READ,
    WRITE,
    AWAIT,
    END_OF_BATCH,
    ERROR
} state_t;

// ============================================================================
//  Объявления сигналов (все переменные модуля)
// ============================================================================
state_t state;
state_t next_state;

logic [2:0]  wprot_reg;
logic [3:0]  strb_reg;
logic [31:0] addr_reg;
logic [31:0] data_reg;
//logic [2:0]  current_cmd_offset;
logic [3:0]  timeout_counter;
logic [TDATA_WIDTH-1:0] current_word;
logic                   last_received;
logic transaction_complete;
logic end_of_batch;

logic [7:0]  current_cmd;
logic [7:0]  cmd;
logic [7:0]  cmd_error;
logic [7:0]  field_byte;

logic [1:0] readed_words;
logic write_initiated;
logic read_initiated;

logic current_offset_0;
logic current_offset_2;
logic current_offset_4;
logic current_offset_6;

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        write_initiated <= 1'b0;
        read_initiated <= 1'b0;
    end else if (state == WRITE) begin
        write_initiated <= 1'b1;
    end else if (state == READ) begin
        read_initiated <= 1'b1;
    end else if (transaction_complete) begin
        write_initiated <= 1'b0;
        read_initiated <= 1'b0;
    end else if (state == AWAIT) begin
        write_initiated <= write_initiated;
        read_initiated <= read_initiated;
    end else begin
        write_initiated <= 1'b0;
        read_initiated <= 1'b0;
    end
end


always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        readed_words <= 1'b0;
    end else begin
        // Сброс при переходе в новую команду (из IDLE или из AWAIT/END_OF_BATCH)
        if (state == IDLE || state == END_OF_BATCH) begin
            readed_words <= 2'd0;
        end else if ((state == AWAIT || state == END_OF_BATCH) && (next_state == WRITE || next_state == READ)) begin
            readed_words <= 2'd1;
        end 
        // Инкремент при чтении слова в стадиях WRITE/READ
        else if ((state == WRITE || state == READ) && s_axis_tvalid && s_axis_tready) begin
            readed_words <= readed_words + 1'b1;
        end 
        // Сохранение значения в остальных случаях
        else begin
            readed_words <= readed_words;
        end
    end
end


// ============================================================================
//  1) Описание работы автомата (FSM)
//     - next_state (combinational)
//     - state (registered)
//     - внутренние флаги/счётчики, завязанные на переходы
// ============================================================================

// Регистр состояния
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Комбинаторная логика переходов
always_comb begin
    // Инициализация next_state текущим состоянием для предотвращения latch
    next_state = state;

    case (state)
        IDLE, END_OF_BATCH: begin
            if (s_axis_tvalid) begin
                case (cmd)
                    CMD_READ:   next_state = READ;
                    CMD_WRITE:  next_state = WRITE;
                    default:    next_state = ERROR;  // Неизвестная команда - переходим в ERROR
                endcase
            end
            // Иначе остаёмся в IDLE (next_state уже = IDLE)
        end

        WRITE, READ: begin
            // Приоритет условий: сначала проверяем завершение транзакции с последним пакетом
            if (transaction_complete && last_received) begin
                next_state = IDLE;
            end
            // Затем проверяем достаточность данных для отправки (вычитано 2 слова)
            else if (readed_words == 2'd2) begin
                next_state = AWAIT;
            end
            // ФИКС (раунд 2): короткий пакет — tlast пришёл, а 10 байт команды
            // не набрано. Раньше это только взводило error_flag (см. блок 5-bis),
            // но FSM продолжала висеть в WRITE/READ. Теперь реально уходим в ERROR,
            // чтобы автомат и шина освободились.
            else if (last_received && !transaction_complete) begin
                next_state = ERROR;
            end
            // ФИКС (раунд 2): таймаут — продолжение команды так и не пришло
            // (не было даже tlast). Раньше timeout_counter только взводил флаг
            // ошибки, но не двигал автомат. Теперь по истечении TIMEOUT_VALUE
            // тактов простоя уходим в ERROR -> (см. case ERROR) -> IDLE,
            // т.е. шина реально освобождается, как и просил Шахзод.
            else if (!s_axis_tvalid && (timeout_counter >= TIMEOUT_VALUE)) begin
                next_state = ERROR;
            end
        end

        AWAIT: begin
            // Приоритет: сначала проверяем завершение с последним пакетом
            if (last_received && transaction_complete) begin
                next_state = IDLE;
            end
            else if (transaction_complete && end_of_batch && s_axis_tvalid) begin
                next_state = END_OF_BATCH;
            end
            // Затем проверяем завершение транзакции для следующей команды
            else if (transaction_complete && s_axis_tvalid) begin
                // Прямая выборка байта вместо функции для избежания предупреждений компилятора
                case (current_cmd)
                    CMD_READ:   next_state = READ;
                    CMD_WRITE:  next_state = WRITE;
                    default:    next_state = ERROR;
                endcase
            end
            else begin
                next_state = AWAIT;
            end
        end
        ERROR: begin
            // Приоритет условий выхода из ERROR
            if (s_axis_tvalid && s_axis_tready && s_axis_tlast) begin
                next_state = IDLE;
            end else if (last_received) begin
                next_state = IDLE;
            end else if (!s_axis_tvalid && timeout_counter >= TIMEOUT_VALUE) begin
                next_state = IDLE;
            end
            // Иначе остаёмся в ERROR (next_state уже = ERROR)
        end

        default: begin
            next_state = IDLE;  // Безопасное состояние по умолчанию
        end
    endcase
end

always_comb begin
    if (current_offset_0) begin
        cmd = get_byte(s_axis_tdata, 3'd0);
    end else if (current_offset_2) begin
        cmd = get_byte(s_axis_tdata, 3'd2);
    end else if (current_offset_4) begin
        cmd = get_byte(s_axis_tdata, 3'd4);
    end else if (current_offset_6) begin
        cmd = get_byte(s_axis_tdata, 3'd6);
    end else begin
        cmd = 8'h00;   // SEU-защита: потерян one-hot указатель -> неизвестная команда -> ERROR
    end
    //cmd = get_byte(s_axis_tdata, current_cmd_offset);
end

// Регистр текущей команды для использования в состояниях AWAIT
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        current_cmd <= 8'h0;
    end else if (s_axis_tvalid && s_axis_tready) begin
            current_cmd <= cmd;
    end else begin
            current_cmd <= current_cmd;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        current_offset_0 <= 1'b1;
        current_offset_2 <= 1'b0;
        current_offset_4 <= 1'b0;
        current_offset_6 <= 1'b0;
    end else if (s_axis_tvalid && s_axis_tready && !end_of_batch) begin
       current_offset_0 <= current_offset_6;
       current_offset_2 <= current_offset_0;
       current_offset_4 <= current_offset_2;
       current_offset_6 <= current_offset_4;
    end else if (next_state == IDLE) begin
        current_offset_0 <= 1'b1;
        current_offset_2 <= 1'b0;
        current_offset_4 <= 1'b0;
        current_offset_6 <= 1'b0;
    end else begin
        current_offset_0 <= current_offset_0;
        current_offset_2 <= current_offset_2;
        current_offset_4 <= current_offset_4;
        current_offset_6 <= current_offset_6;
    end
end


// Флаг конца "батча" команд
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        end_of_batch <= 1'b0;
    end else begin
        if (state == AWAIT && current_offset_0 && s_axis_tvalid && transaction_complete) begin
            end_of_batch <= 1'b1;
        end else if(state == END_OF_BATCH || state == IDLE) begin
            end_of_batch <= 1'b0;
        end else begin
            end_of_batch <= end_of_batch;
        end
    end
end

// Фиксация факта завершения транзакции AXI-Lite (рукопожатие AR или W)
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        transaction_complete <= 1'b0;
    end else begin
        if (state == AWAIT && next_state == END_OF_BATCH) begin
            transaction_complete <= transaction_complete;
        end else if (state != IDLE && state != ERROR && !transaction_complete) begin
            transaction_complete <= ((axil_arvalid && axil_arready) || (axil_wvalid && axil_wready));
        end else if (state == AWAIT) begin
            transaction_complete <= transaction_complete;
        end else begin
            transaction_complete <= 1'b0;
        end
    end
end

// ============================================================================
//  2) Работа с сигналами шины AXIS
//     - s_axis_tready
//     - приём/буферизация входного слова (tdata/tkeep/tlast)
// ============================================================================

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        s_axis_tready <= 1'b1;
    end else begin
        case (state)
            IDLE, END_OF_BATCH: begin
                if (next_state == WRITE || next_state == READ) begin
                    s_axis_tready <= 1'b1;
                end else begin
                    s_axis_tready <= 1'b0;
                end
            end

            READ, WRITE: begin
                if ((!s_axis_tvalid && readed_words != 2'd2) || !readed_words) begin
                    s_axis_tready <= 1'b1;
                end else  begin
                    s_axis_tready <= 1'b0;
                end 
            end

            AWAIT: begin
                if (next_state == READ || next_state == WRITE) begin
                    s_axis_tready <= 1'b1;
                end else begin
                    s_axis_tready <= 1'b0;
                end
            end
            ERROR: begin
                s_axis_tready <= 1'b1;
            end

            default: begin
                s_axis_tready <= 1'b1;
            end
        endcase
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        current_word   <= '0;
        last_received  <= 1'b0;
    end else begin
        if (s_axis_tvalid && s_axis_tready) begin
            current_word  <= s_axis_tdata;
            last_received <= s_axis_tlast;
        end
        else if (next_state == IDLE) begin
            last_received <= 1'b0;
            current_word <= '0;
        end
        else begin
            last_received <= last_received;
            current_word <= current_word;
        end
    end
end

// Регистры для хранения prot и strb из пакета
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        wprot_reg      <= 3'h0;
        strb_reg       <= 4'h0;
    end else begin
        case (state)
            READ, WRITE: begin
                if (end_of_batch) begin
                    strb_reg   <= strb_reg;
                    wprot_reg  <= wprot_reg;
                end

                else if (s_axis_tvalid && s_axis_tready && !s_axis_tlast) begin
                    if (current_offset_0) begin
                        field_byte = get_byte(s_axis_tdata, 3'd1);
                    end else if (current_offset_2) begin
                        field_byte = get_byte(s_axis_tdata, 3'd3);
                    end else if (current_offset_4) begin
                        field_byte = get_byte(s_axis_tdata, 3'd5);
                    end else if (current_offset_6) begin
                        field_byte = get_byte(s_axis_tdata, 3'd7);
                    end
                    strb_reg   <= field_byte[3:0];  // strb в младших 4 битах
                    wprot_reg  <= field_byte[6:4];  // prot в битах [6:4]
                end
            end
        endcase

        if (next_state == ERROR && state != ERROR) begin
            wprot_reg <= 3'h0;
            strb_reg  <= 4'h0;
        end
    end
end

// TODO   в тесты добавить отслеживание ответов resp и 


// ============================================================================
//  3) Работа с данными и буферами
//     - data_reg (данные записи)
// ============================================================================

// Отдельный блок для data_reg для уменьшения комбинаторных цепей
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        data_reg <= 32'h0;
    end else begin
        case (state)
            IDLE: begin
                data_reg <= 32'h0;
            end
            WRITE: begin
                if (s_axis_tvalid && s_axis_tready && end_of_batch) begin
                        data_reg[7:0] <= get_byte(s_axis_tdata, 3'd4);
                        data_reg[15:8] <= get_byte(s_axis_tdata, 3'd5);
                        data_reg[23:16] <= get_byte(s_axis_tdata, 3'd6);
                        data_reg[31:24] <= get_byte(s_axis_tdata, 3'd7);
                end else if (s_axis_tvalid && s_axis_tready) begin
                    if (current_offset_2) begin
                        data_reg[23:16] <= get_byte(s_axis_tdata, 3'd0);
                        data_reg[31:24] <= get_byte(s_axis_tdata, 3'd1);
                    end else if (current_offset_4) begin
                        data_reg[7:0]   <= get_byte(s_axis_tdata, 3'd0);
                        data_reg[15:8]  <= get_byte(s_axis_tdata, 3'd1);
                        data_reg[23:16] <= get_byte(s_axis_tdata, 3'd2);
                        data_reg[31:24] <= get_byte(s_axis_tdata, 3'd3);
                    end else if (current_offset_6) begin
                        data_reg[7:0]   <= get_byte(s_axis_tdata, 3'd2);
                        data_reg[15:8]  <= get_byte(s_axis_tdata, 3'd3);
                        data_reg[23:16] <= get_byte(s_axis_tdata, 3'd4);
                        data_reg[31:24] <= get_byte(s_axis_tdata, 3'd5);
                    end else begin
                        data_reg[7:0]   <= get_byte(s_axis_tdata, 3'd6);
                        data_reg[15:8]  <= get_byte(s_axis_tdata, 3'd7);
                    end
                end
            end
        endcase
    end
end



// Отдельный блок для addr_reg для уменьшения комбинаторных цепей
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        addr_reg <= 32'h0;
    end else begin
        case (state)
            IDLE: begin
                addr_reg <= 32'h0;
            end
            WRITE, READ: begin
                    if (s_axis_tvalid && s_axis_tready && readed_words) begin
                        if (current_offset_2) begin
                            addr_reg[7:0] <= get_byte(current_word, 3'd2);
                            addr_reg[15:8] <= get_byte(current_word, 3'd3);
                            addr_reg[23:16] <= get_byte(current_word, 3'd4);
                            addr_reg[31:24] <= get_byte(current_word, 3'd5);
                        end else if (current_offset_4) begin
                            addr_reg[7:0] <= get_byte(current_word, 3'd4);
                            addr_reg[15:8] <= get_byte(current_word, 3'd5);
                            addr_reg[23:16] <= get_byte(current_word, 3'd6);
                            addr_reg[31:24] <= get_byte(current_word, 3'd7);
                        end else if (current_offset_6) begin
                            addr_reg[7:0] <= get_byte(current_word, 3'd6);
                            addr_reg[15:8] <= get_byte(current_word, 3'd7);
                            addr_reg[23:16] <= get_byte(s_axis_tdata, 3'd0);
                            addr_reg[31:24] <= get_byte(s_axis_tdata, 3'd1);
                        end else if (current_offset_0 && !end_of_batch) begin
                            addr_reg[7:0] <= get_byte(current_word, 3'd0);
                            addr_reg[15:8] <= get_byte(current_word, 3'd1);
                            addr_reg[23:16] <= get_byte(current_word, 3'd2);
                            addr_reg[31:24] <= get_byte(current_word, 3'd3);
                        end else if (s_axis_tvalid && s_axis_tready && end_of_batch) begin
                            addr_reg[7:0] <= get_byte(s_axis_tdata, 3'd0);
                            addr_reg[15:8] <= get_byte(s_axis_tdata, 3'd1);
                            addr_reg[23:16] <= get_byte(s_axis_tdata, 3'd2);
                            addr_reg[31:24] <= get_byte(s_axis_tdata, 3'd3);
                        end
                end 
            end
        endcase
    end
end

assign last_transaction = last_received;


// ============================================================================
//  4) Шина AXI-Lite (формирование валидов/адресов/данных)
// ============================================================================


always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        axil_arvalid <= 1'b0;
        axil_awvalid <= 1'b0;
        axil_wvalid <= 1'b0;
        axil_araddr <= 32'h0;
        axil_awaddr <= 32'h0;
        axil_wdata <= 32'h0;
        axil_wstrb <= 4'hF;
        axil_arprot <= 3'h0;
        axil_awprot <= 3'h0;

    end else begin

        case (state)
           
            AWAIT, END_OF_BATCH: begin
                if (!axil_awvalid && !transaction_complete && write_initiated) begin
                    axil_awvalid <= 1'b1;
                    axil_wvalid <= 1'b1;
                    axil_awaddr <= addr_reg;
                    axil_wdata <= data_reg;
                    axil_wstrb <= strb_reg;      // Используем strb из пакета
                    axil_awprot <= wprot_reg;    // Используем prot из пакета
                end else if (!axil_arvalid && !transaction_complete && read_initiated) begin
                    axil_arvalid <= 1'b1;
                    axil_araddr <= addr_reg;
                    axil_arprot <= wprot_reg;    // Используем prot из пакета
                end else if (axil_wready && axil_awvalid) begin
                    axil_awvalid <= 1'b0;
                    axil_wvalid <= 1'b0;
                    axil_araddr <= '0;
                    axil_arprot <= '0;
                end else if (axil_arready && axil_arvalid) begin
                    axil_arvalid <= 1'b0;
                    axil_araddr <= '0;
                    axil_arprot <= '0;
                end
            end
            
            default: begin
                axil_arvalid <= 1'b0;
                axil_awvalid <= 1'b0;
                axil_wvalid <= 1'b0;
            end
        endcase
    end
end

// ============================================================================
//  5) Ошибки / диагностика
// ============================================================================
/*
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        error_flag <= 1'b0;
        error_code <= 8'h0;
    end else begin
        case (state)
            IDLE: begin
                if (s_axis_tvalid && s_axis_tready) begin
                    cmd_error = get_byte(s_axis_tdata, 3'd0);
                        if (cmd_error != CMD_READ && cmd_error != CMD_WRITE) begin
                            error_flag <= 1'b1;
                            error_code <= ERR_UNKNOWN_CMD;
                        end else begin
                            error_flag <= 1'b0;
                            error_code <= 8'h0;
                        end
                end
            end
            
            READ, WRITE: begin
                // Проверка таймаута: если не вычитано достаточно слов (меньше 2)
                if (readed_words < 2'd2 && timeout_counter >= TIMEOUT_VALUE && !s_axis_tvalid) begin
                    error_flag <= 1'b1;
                    error_code <= ERR_TIMEOUT;
                end else if (s_axis_tvalid && s_axis_tready) begin
                    error_flag <= 1'b0;
                    error_code <= 8'h0;
                end else if (last_received && readed_words < 2'd2 && !s_axis_tvalid) begin
                    error_flag <= 1'b1;
                    error_code <= ERR_INSUFFICIENT_DATA;
                end else if (readed_words >= 2'd2) begin
                    // Если вычитано достаточно слов (>= 2), сбрасываем ошибки недостаточности данных/таймаута
                    if (error_code == ERR_INSUFFICIENT_DATA || error_code == ERR_TIMEOUT) begin
                        error_flag <= 1'b0;
                        error_code <= 8'h0;
                    end
                end
            end
            
            ERROR: begin
                if (next_state == IDLE) begin
                    error_flag <= 1'b0;
                    error_code <= 8'h0;
                end
            end
            
            default: begin
                if (state == IDLE) begin
                    error_flag <= 1'b0;
                    error_code <= 8'h0;
                end
            end
        endcase
    end
end
*/
// ============================================================================
//  5-bis) АКТИВНАЯ диагностика целостности + восстановление автомата
//         (радиационная устойчивость)
//
//  РАУНД 2 (доводка после первой версии):
//   - error_flag/error_code теперь подключены к биндеру по-настоящему (см.
//     pkt2axil_top.sv) и реально попадают в исходящий AXI Stream пакет
//     (см. ERR_INJECT в pkt2axil_binder.sv) — раньше вход биндера был
//     жёстко привязан к 0, и фактически вообще ничего не уходило наружу.
//   - Переходы next_state=ERROR по таймауту/короткому пакету (см. блок
//     WRITE/READ выше) теперь реально двигают автомат, а не только взводят
//     флаг — раньше FSM могла зависнуть в WRITE/READ навсегда, если поток
//     останавливался без tlast (флаг был, а "шина" не освобождалась).
//
//  ВНИМАНИЕ: пороги (TIMEOUT_VALUE = 10 тактов простоя) подобраны "на глаз"
//  по смыслу протокола, а не вымерены в симуляции — это нужно подтвердить
//  прогоном тестов (см. tests/pkt2axil_error_test.py) и при необходимости
//  скорректировать localparam.
// ============================================================================

// --- 5.1 Счётчик таймаута ожидания продолжения команды ---
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn)
        timeout_counter <= 4'h0;
    else if (s_axis_tvalid && s_axis_tready)
        timeout_counter <= 4'h0;                        // приняли слово — сброс
    else if (state == READ || state == WRITE) begin
        if (timeout_counter < TIMEOUT_VALUE)
            timeout_counter <= timeout_counter + 4'h1;  // ждём остаток 10-байтной команды
    end else
        timeout_counter <= 4'h0;
end

// --- 5.2 Контроль one-hot указателя смещения команды (детектор SEU) ---
//     В исправном режиме активен ровно один current_offset_*. Значение 0 или >1
//     активных битов — признак переворота бита в регистре-указателе.
logic [2:0] offset_popcount;
logic       offset_onehot_ok;
assign offset_popcount  = {2'b0, current_offset_0} + {2'b0, current_offset_2} +
                          {2'b0, current_offset_4} + {2'b0, current_offset_6};
assign offset_onehot_ok = (offset_popcount == 3'd1);

// --- 5.3 Контроль легальности состояния FSM (safe-FSM детектор) ---
assign illegal_state = !((state == IDLE)         || (state == READ)  ||
                         (state == WRITE)        || (state == AWAIT) ||
                         (state == END_OF_BATCH) || (state == ERROR));

// --- 5.4 Формирование флага и кода ошибки ---
// ФИКС (раунд 2): раньше единственное условие "next_state==ERROR && state!=ERROR"
// безусловно ставило ERR_UNKNOWN_CMD для ЛЮБОГО перехода в ERROR — в т.ч. для
// нового перехода по таймауту/короткому пакету из WRITE/READ (см. правку next_state
// выше). Теперь код ошибки зависит от того, ИЗ какого состояния пришли в ERROR.
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        error_flag <= 1'b0;
        error_code <= 8'h00;
    end else begin
        // (1) Неизвестная команда: уход в ERROR из IDLE/END_OF_BATCH/AWAIT
        //     (cmd != F1/F3, либо потерян one-hot указатель и cmd = 0x00)
        if (next_state == ERROR && state != ERROR &&
            (state == IDLE || state == END_OF_BATCH || state == AWAIT)) begin
            error_flag <= 1'b1;
            error_code <= ERR_UNKNOWN_CMD;
        end
        // (2) Короткий пакет: уход в ERROR из READ/WRITE, tlast уже был получен
        //     (10 байт команды так и не набралось)
        else if (next_state == ERROR && state != ERROR &&
                 (state == READ || state == WRITE) && last_received) begin
            error_flag <= 1'b1;
            error_code <= ERR_INSUFFICIENT_DATA;
        end
        // (3) Таймаут: уход в ERROR из READ/WRITE, tlast вообще не пришёл —
        //     поток просто встал. Именно этот случай освобождает шину
        //     ("чтобы сделать шину доступной").
        else if (next_state == ERROR && state != ERROR &&
                 (state == READ || state == WRITE) && !last_received) begin
            error_flag <= 1'b1;
            error_code <= ERR_TIMEOUT;
        end
        // (4) Радиационный сбой указателя/состояния (SEU/SET)
        else if (!offset_onehot_ok || illegal_state) begin
            error_flag <= 1'b1;
            error_code <= ERR_SEU_FAULT;
        end
        // Снятие флага после возврата в IDLE (ошибочный пакет выброшен)
        else if ((state == ERROR && next_state == IDLE) || (state == IDLE)) begin
            error_flag <= 1'b0;
            error_code <= 8'h00;
        end
    end
end

endmodule
