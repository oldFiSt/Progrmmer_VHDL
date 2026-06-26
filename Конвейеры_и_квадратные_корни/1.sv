module formula_1_pipe
(
    input  logic        clk,
    input  logic        rst,

    input  logic        arg_vld,
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [31:0] c,

    output logic        res_vld,
    output logic [31:0] res
);

    logic        a_vld, b_vld, c_vld;
    logic [31:0] a_sqrt, b_sqrt, c_sqrt;

    // Три экземпляра isqrt
    isqrt isqrt_a (
        .clk   (clk),
        .rst   (rst),
        .x_vld (arg_vld),
        .x     (a),
        .y_vld (a_vld),
        .y     (a_sqrt)
    );

    isqrt isqrt_b (
        .clk   (clk),
        .rst   (rst),
        .x_vld (arg_vld),
        .x     (b),
        .y_vld (b_vld),
        .y     (b_sqrt)
    );

    isqrt isqrt_c (
        .clk   (clk),
        .rst   (rst),
        .x_vld (arg_vld),
        .x     (c),
        .y_vld (c_vld),
        .y     (c_sqrt)
    );

    // Финальная стадия конвейера — суммирование
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            res     <= 0;
            res_vld <= 0;
        end
        else begin
            res_vld <= a_vld & b_vld & c_vld;
            if (a_vld & b_vld & c_vld)
                res <= a_sqrt + b_sqrt + c_sqrt;
        end
    end

endmodule