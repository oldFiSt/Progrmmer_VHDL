module gearbox_2_to_1_fc
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      up_valid,
    output logic               up_ready,
    input      [2*width - 1:0] up_data,

    output logic               down_valid,
    input                      down_ready,
    output logic [width - 1:0] down_data
);

    logic [2*width - 1:0] data_reg;
    logic [1:0] state;

    localparam IDLE      = 2'd0;
    localparam SEND_HIGH = 2'd1;
    localparam SEND_LOW  = 2'd2;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            data_reg <= 0;
            state    <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    if (up_valid && up_ready) begin
                        data_reg <= up_data;
                        state    <= SEND_HIGH;
                    end
                end

                SEND_HIGH: begin
                    if (down_valid && down_ready) begin
                        state <= SEND_LOW;
                    end
                end

                SEND_LOW: begin
                    if (down_valid && down_ready) begin
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    always_comb begin
        up_ready   = 0;
        down_valid = 0;
        down_data  = 0;

        case (state)
            IDLE: begin
                up_ready = 1;
            end

            SEND_HIGH: begin
                down_valid = 1;
                down_data  = data_reg[2*width-1:width];
            end

            SEND_LOW: begin
                down_valid = 1;
                down_data  = data_reg[width-1:0];
            end
        endcase
    end

endmodule