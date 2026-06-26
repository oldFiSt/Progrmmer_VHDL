module formula_2_pipe_using_circular
(
    input                      clk,
    input                      rst,

    input                      arg_vld,
    input        [31:0]        a,
    input        [31:0]        b,
    input        [31:0]        c,

    output logic               res_vld,
    output logic [31:0]        res
);

    localparam int isqrt_latency = 16;

    logic        c_sqrt_vld;
    logic [31:0] c_sqrt;

    logic        b_dly_vld;
    logic [31:0] b_dly;

    logic        bc_arg_vld;
    logic [31:0] bc_arg;

    logic        bc_sqrt_vld;
    logic [31:0] bc_sqrt;

    logic        a_dly_vld;
    logic [31:0] a_dly;

    logic        res_arg_vld;
    logic [31:0] res_arg;

    //--------------------------------------------------------------------------
    // isqrt(c)
    //--------------------------------------------------------------------------

    isqrt isqrt_c
    (
        clk,
        rst,
        arg_vld,
        c,
        c_sqrt_vld,
        c_sqrt
    );

    //--------------------------------------------------------------------------
    // задержка b на latency тактов
    //--------------------------------------------------------------------------

    circular_buffer_with_valid
    #(
        .width (32),
        .depth (isqrt_latency)
    )
    b_delay
    (
        .clk      (clk),
        .rst      (rst),
        .in_valid (arg_vld),
        .in_data  (b),
        .out_valid(b_dly_vld),
        .out_data (b_dly)
    );

    assign bc_arg_vld = b_dly_vld & c_sqrt_vld;
    assign bc_arg     = b_dly + c_sqrt;

    //--------------------------------------------------------------------------
    // isqrt(b + isqrt(c))
    //--------------------------------------------------------------------------

    isqrt isqrt_bc
    (
        clk,
        rst,
        bc_arg_vld,
        bc_arg,
        bc_sqrt_vld,
        bc_sqrt
    );

    //--------------------------------------------------------------------------
    // задержка a на 2 * latency тактов
    //--------------------------------------------------------------------------

    circular_buffer_with_valid
    #(
        .width (32),
        .depth (2 * isqrt_latency)
    )
    a_delay
    (
        .clk      (clk),
        .rst      (rst),
        .in_valid (arg_vld),
        .in_data  (a),
        .out_valid(a_dly_vld),
        .out_data (a_dly)
    );

    assign res_arg_vld = a_dly_vld & bc_sqrt_vld;
    assign res_arg     = a_dly + bc_sqrt;

    //--------------------------------------------------------------------------
    // isqrt(a + isqrt(b + isqrt(c)))
    //--------------------------------------------------------------------------

    isqrt isqrt_res
    (
        clk,
        rst,
        res_arg_vld,
        res_arg,
        res_vld,
        res
    );

endmodule