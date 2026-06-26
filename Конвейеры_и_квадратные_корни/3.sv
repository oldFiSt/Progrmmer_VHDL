module shift_register_with_valid
# (
    parameter width = 8,
    parameter depth = 8
)
(
    input  logic                  clk,
    input  logic                  rst,

    input  logic                  in_vld,
    input  logic [width - 1:0]    in_data,

    output logic                  out_vld,
    output logic [width - 1:0]    out_data
);

    logic [width-1:0] data_pipe [depth-1:0];
    logic             vld_pipe  [depth-1:0];

    integer i;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < depth; i++) begin
                data_pipe[i] <= '0;
                vld_pipe[i]  <= 1'b0;
            end
        end
        else begin
            // сдвиг ВСЕГДА
            for (i = depth-1; i > 0; i--) begin
                data_pipe[i] <= data_pipe[i-1];
                vld_pipe[i]  <= vld_pipe[i-1];
            end

            // первая стадия
            data_pipe[0] <= in_data;
            vld_pipe[0]  <= in_vld;
        end
    end

    assign out_data = data_pipe[depth-1];
    assign out_vld  = vld_pipe[depth-1];

endmodule