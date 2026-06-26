module formula_2_pipe
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

    // Сигналы после 1-го модуля (sqrt(c))
    logic [15:0] sqrt_c;
    logic        vld_c;
    logic [31:0] b_delayed;

    logic [15:0] sqrt_bc;
    logic        vld_bc;
    logic [31:0] a_delayed;


    isqrt i_sqrt_c (
        .clk(clk), .rst(rst),
        .x_vld(arg_vld), .x(c),
        .y_vld(vld_c),   .y(sqrt_c)
    );


    sr_vld #(.W(32)) delay_b (
        .clk(clk), .rst(rst),
        .in_vld(arg_vld), .in_data(b),
        .out_vld(vld_c),  .out_data(b_delayed)
    );


    isqrt i_sqrt_b (
        .clk(clk), .rst(rst),
        .x_vld(vld_c), .x(b_delayed + sqrt_c),
        .y_vld(vld_bc), .y(sqrt_bc)
    );


    logic [31:0] a_mid;
    sr_vld #(.W(32)) delay_a1 (
        .clk(clk), .rst(rst),
        .in_vld(arg_vld), .in_data(a),
        .out_vld(vld_c),  .out_data(a_mid)
    );
    sr_vld #(.W(32)) delay_a2 (
        .clk(clk), .rst(rst),
        .in_vld(vld_c),   .in_data(a_mid),
        .out_vld(vld_bc), .out_data(a_delayed)
    );

    // --- СТАДИЯ 3: Вычисляем sqrt(a + sqrt_bc) ---
    isqrt i_sqrt_a (
        .clk(clk), .rst(rst),
        .x_vld(vld_bc), .x(a_delayed + sqrt_bc),
        .y_vld(res_vld), .y(res[15:0])
    );

    assign res[31:16] = 16'b0;

endmodule


module sr_vld #(parameter W = 32) (
    input  logic clk, rst,
    input  logic in_vld,
    input  logic [W-1:0] in_data,
    input  logic out_vld,
    output logic [W-1:0] out_data
);

    logic [W-1:0] storage [0:63]; // Запас глубины
    logic [5:0] head, tail;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= '0;
            tail <= '0;
        end else begin
            if (in_vld) begin
                storage[head] <= in_data;
                head <= head + 1;
            end
            if (out_vld) begin
                tail <= tail + 1;
            end
        end
    end
    assign out_data = storage[tail];
endmodule