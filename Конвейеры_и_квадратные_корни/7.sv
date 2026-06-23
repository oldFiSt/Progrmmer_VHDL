module float_discriminant #(
    parameter FLEN = 64
) (
    input                     clk,
    input                     rst,

    input                     arg_vld,
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,
    input        [FLEN - 1:0] c,

    output logic              res_vld,
    output logic [FLEN - 1:0] res,
    output logic              res_negative,
    output logic              err,

    output logic              busy
);

    // -------- NaN / Inf detection for FP64 (exp all ones) ----------
    function automatic logic is_nan_or_inf(input logic [FLEN-1:0] x);
        logic [10:0] exp;
        exp = x[62:52];
        is_nan_or_inf = &exp; // exp==all1 => NaN or Inf
    endfunction

    localparam logic [FLEN-1:0] FP64_4P0 = 64'h4010_0000_0000_0000; // 4.0

    // -------- f_mult / f_sub instances ----------
    logic [FLEN-1:0] mult_bb_a, mult_bb_b, mult_bb_res;
    logic            mult_bb_up_valid, mult_bb_down_valid, mult_bb_busy, mult_bb_error;

    logic [FLEN-1:0] mult_ac_a, mult_ac_b, mult_ac_res;
    logic            mult_ac_up_valid, mult_ac_down_valid, mult_ac_busy, mult_ac_error;

    logic [FLEN-1:0] mult_4ac_a, mult_4ac_b, mult_4ac_res;
    logic            mult_4ac_up_valid, mult_4ac_down_valid, mult_4ac_busy, mult_4ac_error;

    logic [FLEN-1:0] sub_a, sub_b, sub_res;
    logic            sub_up_valid, sub_down_valid, sub_busy_i, sub_error;

    f_mult #(.FLEN(FLEN)) u_mult_bb (
        .clk(clk), .rst(rst),
        .a(mult_bb_a), .b(mult_bb_b),
        .up_valid(mult_bb_up_valid),
        .res(mult_bb_res),
        .down_valid(mult_bb_down_valid),
        .busy(mult_bb_busy),
        .error(mult_bb_error)
    );

    f_mult #(.FLEN(FLEN)) u_mult_ac (
        .clk(clk), .rst(rst),
        .a(mult_ac_a), .b(mult_ac_b),
        .up_valid(mult_ac_up_valid),
        .res(mult_ac_res),
        .down_valid(mult_ac_down_valid),
        .busy(mult_ac_busy),
        .error(mult_ac_error)
    );

    f_mult #(.FLEN(FLEN)) u_mult_4ac (
        .clk(clk), .rst(rst),
        .a(mult_4ac_a), .b(mult_4ac_b),
        .up_valid(mult_4ac_up_valid),
        .res(mult_4ac_res),
        .down_valid(mult_4ac_down_valid),
        .busy(mult_4ac_busy),
        .error(mult_4ac_error)
    );

    f_sub #(.FLEN(FLEN)) u_sub (
        .clk(clk), .rst(rst),
        .a(sub_a), .b(sub_b),
        .up_valid(sub_up_valid),
        .res(sub_res),
        .down_valid(sub_down_valid),
        .busy(sub_busy_i),
        .error(sub_error)
    );

    // -------- FSM ----------
    typedef enum logic [2:0] {
        ST_IDLE,
        ST_LAUNCH_BB_AC,
        ST_WAIT_BB_AC,
        ST_LAUNCH_4AC,
        ST_WAIT_4AC,
        ST_LAUNCH_SUB,
        ST_WAIT_SUB,
        ST_OUT
    } st_t;

    st_t st;

    logic [FLEN-1:0] a_r, b_r, c_r;
    logic [FLEN-1:0] bb_r, ac_r, fourac_r;
    logic            got_bb, got_ac;
    logic            err_r;

    assign busy = (st != ST_IDLE);

    always_ff @(posedge clk) begin
        if (rst) begin
            st <= ST_IDLE;

            a_r <= '0; b_r <= '0; c_r <= '0;
            bb_r <= '0; ac_r <= '0; fourac_r <= '0;
            got_bb <= 1'b0; got_ac <= 1'b0;
            err_r <= 1'b0;

            res_vld <= 1'b0;
            res <= '0;
            res_negative <= 1'b0;
            err <= 1'b0;

            mult_bb_up_valid <= 1'b0;
            mult_ac_up_valid <= 1'b0;
            mult_4ac_up_valid <= 1'b0;
            sub_up_valid <= 1'b0;

            mult_bb_a <= '0; mult_bb_b <= '0;
            mult_ac_a <= '0; mult_ac_b <= '0;
            mult_4ac_a <= '0; mult_4ac_b <= '0;
            sub_a <= '0; sub_b <= '0;

        end else begin
            // default pulses
            res_vld <= 1'b0;
            mult_bb_up_valid <= 1'b0;
            mult_ac_up_valid <= 1'b0;
            mult_4ac_up_valid <= 1'b0;
            sub_up_valid <= 1'b0;

            // accumulate errors from blocks when results arrive
            if (mult_bb_down_valid && mult_bb_error) err_r <= 1'b1;
            if (mult_ac_down_valid && mult_ac_error) err_r <= 1'b1;
            if (mult_4ac_down_valid && mult_4ac_error) err_r <= 1'b1;
            if (sub_down_valid && sub_error) err_r <= 1'b1;

            case (st)
                ST_IDLE: begin
                    err_r <= 1'b0;
                    err   <= 1'b0;
                    got_bb <= 1'b0;
                    got_ac <= 1'b0;

                    if (arg_vld) begin
                        a_r <= a;
                        b_r <= b;
                        c_r <= c;

                        if (is_nan_or_inf(a) || is_nan_or_inf(b) || is_nan_or_inf(c)) begin
                            err_r <= 1'b1;
                        end

                        st <= ST_LAUNCH_BB_AC;
                    end
                end

                ST_LAUNCH_BB_AC: begin
                    // start b*b and a*c in parallel
                    mult_bb_a <= b_r;
                    mult_bb_b <= b_r;
                    mult_bb_up_valid <= 1'b1;

                    mult_ac_a <= a_r;
                    mult_ac_b <= c_r;
                    mult_ac_up_valid <= 1'b1;

                    got_bb <= 1'b0;
                    got_ac <= 1'b0;

                    st <= ST_WAIT_BB_AC;
                end

                ST_WAIT_BB_AC: begin
                    if (mult_bb_down_valid) begin
                        bb_r <= mult_bb_res;
                        got_bb <= 1'b1;
                    end
                    if (mult_ac_down_valid) begin
                        ac_r <= mult_ac_res;
                        got_ac <= 1'b1;
                    end

                    if (got_bb && got_ac) begin
                        st <= ST_LAUNCH_4AC;
                    end
                end

                ST_LAUNCH_4AC: begin
                    mult_4ac_a <= FP64_4P0;
                    mult_4ac_b <= ac_r;
                    mult_4ac_up_valid <= 1'b1;
                    st <= ST_WAIT_4AC;
                end

                ST_WAIT_4AC: begin
                    if (mult_4ac_down_valid) begin
                        fourac_r <= mult_4ac_res;
                        st <= ST_LAUNCH_SUB;
                    end
                end

                ST_LAUNCH_SUB: begin
                    sub_a <= bb_r;
                    sub_b <= fourac_r;
                    sub_up_valid <= 1'b1;
                    st <= ST_WAIT_SUB;
                end

                ST_WAIT_SUB: begin
                    if (sub_down_valid) begin
                        res <= sub_res;
                        st  <= ST_OUT;
                    end
                end

                ST_OUT: begin
                    err <= err_r;
                    res_vld <= 1'b1;
                    res_negative <= (err_r) ? 1'b0 : res[63];
                    st <= ST_IDLE;
                end

                default: st <= ST_IDLE;
            endcase
        end
    end

endmodule