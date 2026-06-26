module float_discriminant_distributor #(
    parameter int FLEN = 64,
    parameter int NE   = 11
)(
    input  logic                  clk,
    input  logic                  rst,

    input  logic                  arg_vld,
    input  logic [FLEN-1:0]       a,
    input  logic [FLEN-1:0]       b,
    input  logic [FLEN-1:0]       c,

    output logic                  res_vld,
    output logic [FLEN-1:0]       res,
    output logic                  res_negative,
    output logic                  err,
    output logic                  busy
);

    localparam int IW = (NE <= 2) ? 1 : $clog2(NE);
    localparam int CW = $clog2(NE+1);

    // =====================================================
    // CORES
    // =====================================================

    logic [NE-1:0]             core_arg_vld;
    logic [NE-1:0]             core_res_vld;
    logic [NE-1:0]             core_busy;
    logic [NE-1:0]             core_res_negative;
    logic [NE-1:0]             core_err;
    logic [NE-1:0][FLEN-1:0]   core_res;

    logic [NE-1:0][FLEN-1:0]   a_reg, b_reg, c_reg;

    genvar gi;
    generate
        for (gi=0; gi<NE; gi++) begin : CORES
            float_discriminant core (
                .clk(clk),
                .rst(rst),
                .arg_vld(core_arg_vld[gi]),
                .a(a_reg[gi]),
                .b(b_reg[gi]),
                .c(c_reg[gi]),
                .res_vld(core_res_vld[gi]),
                .res(core_res[gi]),
                .res_negative(core_res_negative[gi]),
                .err(core_err[gi]),
                .busy(core_busy[gi])
            );
        end
    endgenerate

    // =====================================================
    // INPUT FIFO (depth NE)
    // =====================================================

    logic [FLEN-1:0] fifo_a [NE-1:0];
    logic [FLEN-1:0] fifo_b [NE-1:0];
    logic [FLEN-1:0] fifo_c [NE-1:0];

    logic [IW-1:0]   in_head, in_tail;
    logic [CW-1:0]   in_count;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            in_head  <= '0;
            in_tail  <= '0;
            in_count <= '0;
        end else begin
            if (arg_vld && (in_count < NE)) begin
                fifo_a[in_tail] <= a;
                fifo_b[in_tail] <= b;
                fifo_c[in_tail] <= c;

                in_tail  <= (in_tail == NE-1) ? '0 : (in_tail + 1'b1);
                in_count <= in_count + 1'b1;
            end
        end
    end

    assign busy = (in_count == NE);

    // =====================================================
    // ROUND-ROBIN: find free core
    // =====================================================

    logic [IW-1:0] alloc_ptr;
    logic          sel_valid;
    logic [IW-1:0] sel_idx;

    integer s;
    always_comb begin
        sel_valid = 1'b0;
        sel_idx   = alloc_ptr;

        for (s=0; s<NE; s=s+1) begin
            logic [IW-1:0] cand;
            cand = alloc_ptr + s[IW-1:0];
            if (cand >= NE) cand = cand - NE;

            if (!sel_valid && !core_busy[cand]) begin
                sel_valid = 1'b1;
                sel_idx   = cand;
            end
        end
    end

    // =====================================================
    // OUTPUT FIFO (completion order) + BYPASS for empty->deq same cycle
    // =====================================================

    logic [FLEN-1:0] out_res [NE-1:0];
    logic            out_neg [NE-1:0];
    logic            out_err [NE-1:0];

    logic [IW-1:0]   out_head, out_tail;
    logic [CW-1:0]   out_count;

    // temps (declared outside for iverilog)
    logic [IW-1:0]   tail_next;
    logic [IW-1:0]   head_next;
    logic [CW-1:0]   count_next;

    // bypass capture of the first enqueued item in this cycle
    logic            push_any;
    logic [FLEN-1:0] first_push_res;
    logic            first_push_neg;
    logic            first_push_err;

    integer k;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            core_arg_vld  <= '0;
            alloc_ptr     <= '0;

            out_head      <= '0;
            out_tail      <= '0;
            out_count     <= '0;

            res_vld       <= 1'b0;
            res           <= '0;
            res_negative  <= 1'b0;
            err           <= 1'b0;
        end else begin
            // defaults
            core_arg_vld <= '0;
            res_vld      <= 1'b0;

            // ---------- DISPATCH (1 per cycle) ----------
            if ((in_count > 0) && sel_valid) begin
                a_reg[sel_idx] <= fifo_a[in_head];
                b_reg[sel_idx] <= fifo_b[in_head];
                c_reg[sel_idx] <= fifo_c[in_head];
                core_arg_vld[sel_idx] <= 1'b1;

                in_head  <= (in_head == NE-1) ? '0 : (in_head + 1'b1);
                in_count <= in_count - 1'b1;

                alloc_ptr <= (sel_idx == NE-1) ? '0 : (sel_idx + 1'b1);
            end

            // ---------- ENQUEUE all completed results ----------
            tail_next  = out_tail;
            head_next  = out_head;
            count_next = out_count;

            push_any = 1'b0;
            first_push_res = '0;
            first_push_neg = 1'b0;
            first_push_err = 1'b0;

            for (k=0; k<NE; k=k+1) begin
                if (core_res_vld[k]) begin
                    if (count_next < NE) begin
                        // capture the first push of this cycle for bypass
                        if (!push_any) begin
                            push_any        = 1'b1;
                            first_push_res  = core_res[k];
                            first_push_neg  = core_res_negative[k];
                            first_push_err  = core_err[k];
                        end

                        out_res[tail_next] <= core_res[k];
                        out_neg[tail_next] <= core_res_negative[k];
                        out_err[tail_next] <= core_err[k];

                        tail_next  = (tail_next == NE-1) ? '0 : (tail_next + 1'b1);
                        count_next = count_next + 1'b1;
                    end
                end
            end

            // ---------- DEQUEUE (max 1 per cycle) ----------
            // If FIFO was empty BEFORE pushes, and we pushed something this cycle,
            // then reading out_res[out_head] would be X -> bypass with captured first_push_*
            if (count_next > 0) begin
                res_vld <= 1'b1;

                if ((out_count == 0) && push_any) begin
                    res          <= first_push_res;
                    res_negative <= first_push_neg;
                    err          <= first_push_err;
                end else begin
                    res          <= out_res[head_next];
                    res_negative <= out_neg[head_next];
                    err          <= out_err[head_next];
                end

                head_next  = (head_next == NE-1) ? '0 : (head_next + 1'b1);
                count_next = count_next - 1'b1;
            end

            // ---------- commit pointers ----------
            out_tail  <= tail_next;
            out_head  <= head_next;
            out_count <= count_next;
        end
    end

endmodule