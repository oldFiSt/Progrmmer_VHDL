module formula_2_pipe_using_fifos
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

    //--------------------------------------------------------------------------
    // FIFO for b
    //--------------------------------------------------------------------------

    logic [31:0] b_fifo_rd_data;
    logic        b_fifo_empty, b_fifo_full;
    logic        b_fifo_pop;

    flip_flop_fifo_with_counter
    #(
        .width (32),
        .depth (isqrt_latency)
    )
    b_fifo
    (
        .clk        (clk),
        .rst        (rst),
        .push       (arg_vld),
        .pop        (b_fifo_pop),
        .write_data (b),
        .read_data  (b_fifo_rd_data),
        .empty      (b_fifo_empty),
        .full       (b_fifo_full)
    );

    //--------------------------------------------------------------------------
    // FIFO for a
    //--------------------------------------------------------------------------

    logic [31:0] a_fifo_rd_data;
    logic        a_fifo_empty, a_fifo_full;
    logic        a_fifo_pop;

    flip_flop_fifo_with_counter
    #(
        .width (32),
        .depth (2 * isqrt_latency)
    )
    a_fifo
    (
        .clk        (clk),
        .rst        (rst),
        .push       (arg_vld),
        .pop        (a_fifo_pop),
        .write_data (a),
        .read_data  (a_fifo_rd_data),
        .empty      (a_fifo_empty),
        .full       (a_fifo_full)
    );

    //--------------------------------------------------------------------------
    // isqrt(c)
    //--------------------------------------------------------------------------

    logic        c_sqrt_vld;
    logic [31:0] c_sqrt;

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
    // isqrt(b + isqrt(c))
    //--------------------------------------------------------------------------

    logic        bc_arg_vld;
    logic [31:0] bc_arg;
    logic        bc_sqrt_vld;
    logic [31:0] bc_sqrt;

    assign b_fifo_pop = c_sqrt_vld & ~b_fifo_empty;
    assign bc_arg_vld = c_sqrt_vld & ~b_fifo_empty;
    assign bc_arg     = b_fifo_rd_data + c_sqrt;

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
    // isqrt(a + isqrt(b + isqrt(c)))
    //--------------------------------------------------------------------------

    logic        res_arg_vld;
    logic [31:0] res_arg;

    assign a_fifo_pop = bc_sqrt_vld & ~a_fifo_empty;
    assign res_arg_vld = bc_sqrt_vld & ~a_fifo_empty;
    assign res_arg     = a_fifo_rd_data + bc_sqrt;

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