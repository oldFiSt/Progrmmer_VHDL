module circular_buffer_with_valid
# (
    parameter width = 8,
    parameter depth = 8
)
(
    input                      clk,
    input                      rst,

    input                      in_valid,
    input        [width - 1:0] in_data,

    output logic               out_valid,
    output logic [width - 1:0] out_data
);

    localparam int PTR_W = (depth <= 1) ? 1 : $clog2(depth);

    logic [width-1:0] data_mem  [0:depth-1];
    logic             valid_mem [0:depth-1];
    logic [PTR_W-1:0] ptr;

    integer i;

    // Запись и сдвиг указателя
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ptr <= '0;
            for (i = 0; i < depth; i = i + 1) begin
                data_mem[i]  <= '0;
                valid_mem[i] <= 1'b0;
            end
        end else begin
            data_mem[ptr]  <= in_data;
            valid_mem[ptr] <= in_valid;

            if (ptr == depth - 1)
                ptr <= '0;
            else
                ptr <= ptr + 1'b1;
        end
    end

    // Чтение текущей ячейки под указателем
    always_comb begin
        if (rst) begin
            out_valid = 1'b0;
            out_data  = '0;
        end else begin
            out_valid = valid_mem[ptr];
            out_data  = data_mem[ptr];
        end
    end

endmodule