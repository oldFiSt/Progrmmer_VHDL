module pkt2axil_binder #(
    parameter  int TDATA_WIDTH = 64,
    parameter  int TUSER_WIDTH = 8,
    localparam int TKEEP_WIDTH = TDATA_WIDTH / 8
) 
(
    input    logic                   clk           ,
    input    logic                   rstn          ,

    output   logic [TDATA_WIDTH-1:0] m_axis_tdata  ,
    output   logic [TKEEP_WIDTH-1:0] m_axis_tkeep  ,
    output   logic [TUSER_WIDTH-1:0] m_axis_tuser  , 
    output   logic                   m_axis_tvalid ,
    input    logic                   m_axis_tready ,
    output   logic                   m_axis_tlast  ,

    input    logic             [1:0] axil_bresp    ,
    input    logic                   axil_bvalid  ,
    output   logic                   axil_bready  ,

    input    logic            [31:0] axil_rdata   ,
    input    logic             [1:0] axil_rresp   ,
    input    logic                   axil_rvalid  ,
    output   logic                   axil_rready  ,
    
    input    logic                   error_flag    ,
    input    logic             [7:0] error_code    ,   // расширено до 8 бит (полный код ошибки)
    input    logic                   last_transaction,
    input    logic            [31:0] axil_awaddr   ,
    input    logic                   axil_awvalid  ,
    input    logic                   axil_awready  ,
    input    logic            [31:0] axil_araddr   ,
    input    logic                   axil_arvalid  ,
    input    logic                   axil_arready

);

typedef enum logic [2:0] {
    IDLE,
    WRITE,
    READ,
    AWAIT,
    SEND_END_OF_BATCH,
    ERR_INJECT      // РАУНД 2: синтетический "ответ-ошибка", не привязан к реальному AXI-Lite handshake
} state_t;

state_t state, next_state;

logic [31:0] stored_addr;
logic [1:0]  stored_trans_type;
logic [1:0]  stored_resp;
logic [2:0]  current_resp_offset;
logic [2:0]  next_resp_offset;
logic [6:0] [15:0] ring_buffer;
logic end_of_batch;
logic [4:0] await_timeout;
logic first_trans_flag;
logic is_last_transaction;
logic [7:0] stored_error_code;   // зафиксированный код ошибки от cutter

// ============================================================================
//  РАУНД 2: захват error_flag от cutter и инжекция ответа-ошибки
//
//  Раньше error_flag/error_code на входе биндера были жёстко привязаны к 0
//  (см. историю в CHANGES_error_handling.md) — детектор в cutter работал,
//  но ни один обнаруженный сбой не попадал в исходящий AXI Stream пакет.
//
//  Кроме того, даже при простом "пробросе" сигналов выяснилось, что штатный
//  путь формирования ответа в этом модуле (state==WRITE/READ ожидает
//  axil_bvalid/axil_rvalid) принципиально не годится для ошибок типа
//  "неизвестная команда"/"таймаут": в этих случаях cutter вообще не успевает
//  запустить транзакцию на AXI-Lite (axil_awvalid/arvalid не поднимаются),
//  значит ни WRITE, ни READ в этом автомате никогда не наступят, и условие
//  "bvalid && error_flag" не сработает НИКОГДА.
//
//  Решение: отдельное состояние ERR_INJECT. error_flag — потенциально
//  многотактовый уровень (держится, пока cutter в ERROR), поэтому ловим
//  именно ПЕРЕДНИЙ ФРОНТ и защёлкиваем "запрос на ошибку" в error_pending,
//  который не теряется, даже если binder в этот момент занят (досылает
//  предыдущий ответ). Когда binder освобождается (IDLE), запрос обслуживается.
// ============================================================================
logic error_flag_d;
logic error_pulse;
logic error_pending;

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) error_flag_d <= 1'b0;
    else       error_flag_d <= error_flag;
end
assign error_pulse = error_flag && !error_flag_d;   // передний фронт error_flag

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        error_pending <= 1'b0;
    end else if (error_pulse) begin
        error_pending <= 1'b1;             // новый сбой — запоминаем, ничего не теряем
    end else if (state == IDLE && next_state == ERR_INJECT) begin
        error_pending <= 1'b0;             // запрос принят в обработку
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        await_timeout <= '0;
    end
    else if (state == AWAIT) begin
        await_timeout <= await_timeout + 1;
    end
    else if (state == SEND_END_OF_BATCH) begin
        await_timeout <= await_timeout + 1;
    end
    else begin
        await_timeout <= '0;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        end_of_batch <= 1'b0;
    end
    else if (state == IDLE ) begin
        end_of_batch <= 1'b0;
    end
    else if((state == READ || state == WRITE || state == ERR_INJECT) &&  current_resp_offset == 3'h6) begin
        end_of_batch <= 1'b1;
    end

    else if (state == SEND_END_OF_BATCH) begin
        // В SEND_END_OF_BATCH всегда происходит переход в READ, WRITE или IDLE
        // Убираем зависимость от next_state для уменьшения комбинаторных цепей
        end_of_batch <= 1'b0;
    end
end


logic [1:0] end_of_batch_read_write_flag;

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        end_of_batch_read_write_flag <= '0;
    end else if (state == AWAIT && end_of_batch && axil_awvalid) begin
        // Переход в SEND_END_OF_BATCH происходит когда end_of_batch и есть новая транзакция
        end_of_batch_read_write_flag <= 2'b10;
    end else if (state == AWAIT && end_of_batch && axil_arvalid) begin
        end_of_batch_read_write_flag <= 2'b01;
    end else begin
        end_of_batch_read_write_flag <= '0;
    end
end


always_comb begin
    next_state = state;
    
    case (state)
        IDLE: begin
            // РАУНД 2: ошибка от cutter имеет приоритет над стартом обычной
            // транзакции — нужно сначала "выпустить" ответ-ошибку, чтобы не
            // потерять её и не перепутать порядок ответов.
            if (error_pending) begin
                next_state = ERR_INJECT;
            end else if (axil_awvalid && axil_awready) begin
                next_state = WRITE;
            end else if (axil_arvalid && axil_arready) begin
                next_state = READ;
            end
        end
        
        WRITE: begin
            if (axil_bvalid && axil_bready) begin
                next_state = AWAIT;
            end
        end
        
        READ: begin
            if (axil_rvalid && axil_rready) begin
                next_state = AWAIT;
            end
        end

        // РАУНД 2: синтетическое состояние для ошибки. Все данные для ответа
        // (stored_error_code/stored_addr) уже зафиксированы при входе в это
        // состояние (см. блок stored_addr/stored_trans_type ниже), ждать
        // больше нечего — за один такт уходим дальше в AWAIT, как будто
        // обычная запись/чтение только что получили bvalid/rvalid.
        ERR_INJECT: begin
            next_state = AWAIT;
        end
        
        AWAIT: begin
            if (!m_axis_tvalid) begin
                if (((axil_awvalid && axil_awready) || (axil_arvalid && axil_arready)) && end_of_batch) begin
                    next_state = SEND_END_OF_BATCH;
                end else if (axil_arready && axil_arvalid) begin
                    next_state = READ;
                end else if (axil_awvalid && axil_awready) begin
                    next_state = WRITE;
                end else if (is_last_transaction || end_of_batch) begin
                    next_state = SEND_END_OF_BATCH;
                end
            end else if (((axil_arvalid && axil_arready) || (axil_awvalid && axil_awready)) && end_of_batch) begin
                next_state = SEND_END_OF_BATCH;
            end else if (axil_awready && axil_awvalid) begin
                next_state = WRITE;
            end else if (axil_arvalid && axil_arready) begin
                next_state = READ;
            end else if (await_timeout == 5'h1F) begin
                next_state = IDLE;
            end else begin
                next_state = AWAIT;
            end
        end
        SEND_END_OF_BATCH: begin
            if (end_of_batch_read_write_flag == 2'b10) begin
                next_state = WRITE;
            end else if (end_of_batch_read_write_flag == 2'b01) begin
                next_state = READ;
            end else begin
                next_state = IDLE;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        current_resp_offset <= 3'h0;
        next_resp_offset <= 3'h2;
    end else begin
        if ((state == AWAIT && (next_state == WRITE || next_state == READ || next_state == SEND_END_OF_BATCH) && !first_trans_flag)) begin
            current_resp_offset <= next_resp_offset;
            next_resp_offset <= (next_resp_offset + 3'd10) & 3'h7;
        end

        if (state == IDLE) begin
            current_resp_offset <= 3'h0;
            next_resp_offset <= 3'h2;
        end
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        stored_resp <= 2'b0;
    end else begin
        if (state == WRITE && axil_bvalid && axil_bready) begin
            stored_resp <= axil_bresp;
        end
        if (state == READ && axil_rvalid && axil_rready) begin
            stored_resp <= axil_rresp;
        end
    end
end

// Фиксация кода ошибки от cutter для формирования error-ответа (type=0x00)
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn)
        stored_error_code <= 8'h00;
    else if (error_flag)
        stored_error_code <= error_code;
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        stored_addr <= 32'h0;
        stored_trans_type <= 2'b00;
    end else begin
        if (axil_awready && axil_awvalid) begin
            stored_addr <= axil_awaddr;
            stored_trans_type <= 2'b11;
        end else if (axil_arready && axil_arvalid) begin
            stored_addr <= axil_araddr;
            stored_trans_type <= 2'b01;
        end else if (state == IDLE && next_state == ERR_INJECT) begin
            // РАУНД 2: вход в синтетический ответ-ошибку. stored_addr намеренно
            // НЕ трогаем — он сохраняет адрес последней реально запущенной
            // транзакции AXI-Lite. Для ERR_TIMEOUT/ERR_INSUFFICIENT_DATA это
            // обычно адрес той самой команды, которая не успела завершиться
            // (он попадает в addr_reg на cutter'е раньше, чем приходит остаток
            // данных). Для ERR_UNKNOWN_CMD/ERR_SEU_FAULT адрес может быть не
            // про эту конкретную команду (она могла не дойти до парсинга
            // адреса вообще) — считайте его в этом случае диагностическим,
            // а не достоверным целевым адресом.
            stored_trans_type <= 2'b00;
        end
    end
end

logic [79:0] resp_comb;

always_comb begin
    if (stored_trans_type == 2'b11) begin
        resp_comb = {
            8'hEE,
            8'hEE,
            8'hEE,
            8'hEE,
            stored_addr[31:24],
            stored_addr[23:16],
            stored_addr[15:8],
            stored_addr[7:0],
            {6'b0, axil_bresp},
            {6'b0, 2'b11}
        };
    end else if (stored_trans_type == 2'b01) begin
        resp_comb = {
            axil_rdata[31:24],
            axil_rdata[23:16],
            axil_rdata[15:8],
            axil_rdata[7:0],
            stored_addr[31:24],
            stored_addr[23:16],
            stored_addr[15:8],
            stored_addr[7:0],
            {6'b0, axil_rresp},
            {6'b0, 2'b01}
        };
    end else begin
        resp_comb = {
            8'hEE,
            8'hEE,
            8'hEE,
            8'hEE,
            stored_addr[31:24],
            stored_addr[23:16],
            stored_addr[15:8],
            stored_addr[7:0],
            stored_error_code,        // байт resp = полный код ошибки (ERR_*)
            {6'b0, 2'b00}             // байт type = 0x00 (ошибка)
        };
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        ring_buffer <= '0;
    end else if ((state == WRITE && axil_bvalid && axil_bready) || (state == READ && axil_rvalid && axil_rready) || (state == ERR_INJECT)) begin
            case (current_resp_offset)
                3'h0: begin  
                    ring_buffer[0] <= resp_comb[79:64];
                    ring_buffer[1] <= 16'h0;
                    ring_buffer[2] <= 16'h0;
                end
                3'h2: begin
                    ring_buffer[1] <= 16'h0;
                    ring_buffer[2] <= 16'h0;
                    ring_buffer[3] <= 16'h0;
                    ring_buffer[4] <= 16'h0;
                    ring_buffer[5] <= resp_comb[63:48];
                    ring_buffer[6] <= resp_comb[79:64];
                end
                3'h4: begin
                    ring_buffer[0] <= resp_comb[47:32];
                    ring_buffer[1] <= resp_comb[63:48];
                    ring_buffer[2] <= resp_comb[79:64];
                    ring_buffer[3] <= 16'h0;
                    ring_buffer[4] <= 16'h0;
                end
                3'h6: begin
                    ring_buffer[3] <= resp_comb[31:16];
                    ring_buffer[4] <= resp_comb[47:32];
                    ring_buffer[5] <= resp_comb[63:48];
                    ring_buffer[6] <= resp_comb[79:64];
                end
                default: begin
                    ring_buffer <= '0;
                end
            endcase
        end else if (state == IDLE && m_axis_tvalid && m_axis_tready) begin
            case (current_resp_offset)
                3'h0: begin
                    ring_buffer[0] <= 16'h0;
                end
                3'h2: begin
                    ring_buffer[5] <= 16'h0;
                    ring_buffer[6] <= 16'h0;
                end
                3'h4: begin
                    ring_buffer[0] <= 16'h0;
                    ring_buffer[1] <= 16'h0;
                    ring_buffer[2] <= 16'h0;
                end
                3'h6: begin
                    ring_buffer[3] <= 16'h0;
                    ring_buffer[4] <= 16'h0;
                    ring_buffer[5] <= 16'h0;
                    ring_buffer[6] <= 16'h0;
                end
                default: begin
                    ring_buffer[0] <= 16'h0;
                end
            endcase
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        first_trans_flag <= 1'b1;
    end else if (state == AWAIT && m_axis_tvalid && m_axis_tready && !m_axis_tlast) begin
        first_trans_flag <= 1'b0;
    end else if (state == AWAIT && m_axis_tvalid && m_axis_tready && m_axis_tlast) begin
        first_trans_flag <= 1'b1;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        m_axis_tdata <= '0;
        m_axis_tkeep <= '0;
    end
    else if (state == AWAIT && end_of_batch && !is_last_transaction) begin
        // Переход в SEND_END_OF_BATCH происходит когда end_of_batch установлен
        // Убираем зависимость от next_state для уменьшения комбинаторных цепей
        m_axis_tdata <= {ring_buffer[6], ring_buffer[5], ring_buffer[4], ring_buffer[3]};
        m_axis_tkeep <= 8'hFF;
    end else if (state == AWAIT && (end_of_batch || is_last_transaction)) begin
        case (current_resp_offset)
            3'h0: begin
                m_axis_tdata <= {48'h0, ring_buffer[0]};
                m_axis_tkeep <= 8'h03;
            end
            3'h2: begin
                m_axis_tdata <= {32'h0, ring_buffer[6], ring_buffer[5]};
                m_axis_tkeep <= 8'h0F;
            end
            3'h4: begin
                m_axis_tdata <= {16'h0, ring_buffer[3], ring_buffer[2], ring_buffer[1], ring_buffer[0]};
                m_axis_tkeep <= 8'h3F;
            end
            3'h6: begin
                m_axis_tdata <= {ring_buffer[6], ring_buffer[5], ring_buffer[4], ring_buffer[3]};
                m_axis_tkeep <= 8'hFF;
            end
            default: begin
                m_axis_tdata <= 64'h0;
                m_axis_tkeep <= 8'h00;
            end
        endcase
    end else if ((state == WRITE && axil_bvalid && axil_bready) || (state == READ && axil_rvalid && axil_rready) || (state == ERR_INJECT)) begin
        case (current_resp_offset)
            3'h0: begin
                m_axis_tdata <= resp_comb[63:0];
                m_axis_tkeep <= 8'hFF;
            end
            3'h2: begin
                m_axis_tdata <= {resp_comb[47:0], ring_buffer[0]};
                m_axis_tkeep <= 8'hFF;
            end
            3'h4: begin
                m_axis_tdata <= {resp_comb[31:0], ring_buffer[6], ring_buffer[5]};
                m_axis_tkeep <= 8'hFF;
            end
            3'h6: begin
                m_axis_tdata <= {resp_comb[15:0], ring_buffer[2], ring_buffer[1], ring_buffer[0]};
                m_axis_tkeep <= 8'hFF;
            end
            default: begin
                m_axis_tdata <= resp_comb[63:0];
                m_axis_tkeep <= 8'hFF;
            end
        endcase
    end
end


always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        is_last_transaction <= 1'b0;
    end else if ((axil_awvalid && axil_awready) || (axil_arvalid && axil_arready)) begin
        is_last_transaction <= last_transaction;
    end else if (state == IDLE && next_state == ERR_INJECT) begin
        // РАУНД 2: ответ-ошибка всегда закрывает исходящий пакет (tlast=1).
        // Это осознанное упрощение: вместо того чтобы пытаться точно
        // воспроизвести, было ли это "последней командой в батче" на момент
        // сбоя (а это плохо определено для прерванной команды), мы просто
        // гарантированно завершаем кадр сразу после ошибки. Следующая
        // команда host'а начнёт новый, чистый пакет-ответ.
        is_last_transaction <= 1'b1;
    end else if (m_axis_tvalid && m_axis_tready && m_axis_tlast) begin
        is_last_transaction <= 1'b0;
    end
end

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        m_axis_tlast <= '0;
    end else begin
        if (state == AWAIT && is_last_transaction) begin
            m_axis_tlast <= 1'b1;
        end else if (m_axis_tvalid && m_axis_tready && m_axis_tlast) begin
            m_axis_tlast <= '0;
        end else if (next_state == SEND_END_OF_BATCH && is_last_transaction) begin
            m_axis_tlast <= 1'b1;
        end else begin
            m_axis_tlast <= '0;
        end
    end
end

assign axil_bready = (state == WRITE);
assign axil_rready = (state == READ);

always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        m_axis_tvalid <= '0;
    end else begin
        if (next_state == SEND_END_OF_BATCH) begin
            m_axis_tvalid <= 1'b1;
        end else if (m_axis_tvalid && m_axis_tready) begin
            m_axis_tvalid <= 1'b0;
        end else if ((state == WRITE && axil_bvalid && axil_bready) || (state == READ && axil_rvalid && axil_rready) || (state == ERR_INJECT)) begin
            m_axis_tvalid <= 1'b1;
        end else if ((state == AWAIT || state == SEND_END_OF_BATCH) && !m_axis_tvalid && await_timeout == 5'h1F) begin
            m_axis_tvalid <= 1'b1;
        end
    end
end

endmodule