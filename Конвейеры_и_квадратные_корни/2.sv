module formula_1_pipe_aware_fsm
(
    input  logic        clk,
    input  logic        rst,

    input  logic        arg_vld,
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input  logic        isqrt_y_vld,
    input  logic [15:0] isqrt_y
);

    typedef enum logic [1:0] {
        IDLE,
        SEND,
        WAIT_RES
    } state_t;

    state_t state;

    logic [1:0] send_cnt;   // сколько отправили (0..2)
    logic [1:0] recv_cnt;   // сколько получили (0..2)
    logic [31:0] sum;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state        <= IDLE;
            send_cnt     <= 0;
            recv_cnt     <= 0;
            sum          <= 0;
            res          <= 0;
            res_vld      <= 0;
            isqrt_x_vld  <= 0;
            isqrt_x      <= 0;
        end
        else begin
            // по умолчанию
            isqrt_x_vld <= 0;
            res_vld     <= 0;

            case (state)

                IDLE: begin
                    if (arg_vld) begin
                        send_cnt <= 0;
                        recv_cnt <= 0;
                        sum      <= 0;
                        state    <= SEND;
                    end
                end

                SEND: begin
                    isqrt_x_vld <= 1;

                    case (send_cnt)
                        0: isqrt_x <= a;
                        1: isqrt_x <= b;
                        2: isqrt_x <= c;
                    endcase

                    if (send_cnt == 2)
                        state <= WAIT_RES;

                    send_cnt <= send_cnt + 1;
                end

                WAIT_RES: begin
                    if (isqrt_y_vld) begin
                        sum <= sum + isqrt_y;
                        recv_cnt <= recv_cnt + 1;

                        if (recv_cnt == 2) begin
                            res     <= sum + isqrt_y;
                            res_vld <= 1;
                            state   <= IDLE;
                        end
                    end
                end

            endcase
        end
    end

endmodule