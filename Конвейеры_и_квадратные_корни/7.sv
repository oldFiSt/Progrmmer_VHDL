module put_in_order
# (
    parameter width    = 16,
              n_inputs = 4
)
(
    input  logic                       clk,
    input  logic                       rst,

    input  logic [ n_inputs - 1 : 0 ]                 up_vlds,
    input  logic [ n_inputs - 1 : 0 ]
                 [ width    - 1 : 0 ]                 up_data,

    output logic                down_vld,
    output logic [ width - 1:0] down_data
);

    logic [n_inputs-1:0]            buf_vld;
    logic [n_inputs-1:0][width-1:0] buf_data;

    logic [$clog2(n_inputs)-1:0] expected_idx;

    integer i;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            buf_vld      <= '0;
            expected_idx <= '0;
            down_vld     <= 1'b0;
            down_data    <= '0;
        end
        else begin
            down_vld <= 1'b0;

            // =========================
            // 1. Выдача (с bypass)
            // =========================
            if (buf_vld[expected_idx]) begin
                down_vld  <= 1'b1;
                down_data <= buf_data[expected_idx];
                buf_vld[expected_idx] <= 1'b0;

                expected_idx <= (expected_idx == n_inputs-1)
                                ? 0
                                : expected_idx + 1;
            end
            else if (up_vlds[expected_idx]) begin
                // bypass — данные пришли ровно сейчас
                down_vld  <= 1'b1;
                down_data <= up_data[expected_idx];

                expected_idx <= (expected_idx == n_inputs-1)
                                ? 0
                                : expected_idx + 1;
            end

            // =========================
            // 2. Запись входов в буфер
            // =========================
            for (i = 0; i < n_inputs; i++) begin
                if (up_vlds[i] && !(i == expected_idx && !buf_vld[expected_idx])) begin
                    buf_vld[i]  <= 1'b1;
                    buf_data[i] <= up_data[i];
                end
            end
        end
    end

endmodule