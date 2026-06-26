module sort_floats_using_fsm #(
    parameter FLEN = 64
) (
    input                          clk,
    input                          rst,

    input                          valid_in,
    input        [0:2][FLEN - 1:0] unsorted,

    output logic                   valid_out,
    output logic [0:2][FLEN - 1:0] sorted,
    output logic                   err,
    output logic                   busy,

    // f_less_or_equal interface
    output logic      [FLEN - 1:0] f_le_a,
    output logic      [FLEN - 1:0] f_le_b,
    input                          f_le_res,
    input                          f_le_err
);

    // 3-cycle sorting network using ONE comparator:
    // cycle1: compare/swap (0,1)
    // cycle2: compare/swap (1,2)
    // cycle3: compare/swap (0,1)
    //
    // valid_out asserted exactly 3 clocks after valid_in.

    logic [1:0] step;              // 0,1,2 -> active; 3 -> idle
    logic [FLEN-1:0] x0, x1, x2;

    assign busy = (step != 2'd3);

    // drive comparator inputs
    always_comb begin
        f_le_a = '0;
        f_le_b = '0;

        if (busy) begin
            case (step)
                2'd0: begin f_le_a = x0; f_le_b = x1; end
                2'd1: begin f_le_a = x1; f_le_b = x2; end
                2'd2: begin f_le_a = x0; f_le_b = x1; end
                default: begin f_le_a = x0; f_le_b = x1; end
            endcase
        end
    end

    // output mapping
    always_comb begin
        sorted[0] = x0;
        sorted[1] = x1;
        sorted[2] = x2;
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            step      <= 2'd3; // idle
            x0        <= '0;
            x1        <= '0;
            x2        <= '0;
            err       <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;

            // idle -> accept new triple
            if (step == 2'd3) begin
                if (valid_in) begin
                    x0   <= unsorted[0];
                    x1   <= unsorted[1];
                    x2   <= unsorted[2];
                    err  <= 1'b0;
                    step <= 2'd0;
                end
            end else begin
                // latch any NaN/Inf indication from comparator
                if (f_le_err)
                    err <= 1'b1;

                case (step)
                    2'd0: begin
                        if (!f_le_res) begin
                            {x0, x1} <= {x1, x0};
                        end
                        step <= 2'd1;
                    end

                    2'd1: begin
                        if (!f_le_res) begin
                            {x1, x2} <= {x2, x1};
                        end
                        step <= 2'd2;
                    end

                    2'd2: begin
                        if (!f_le_res) begin
                            {x0, x1} <= {x1, x0};
                        end
                        valid_out <= 1'b1;  // exactly 3 cycles after valid_in
                        step      <= 2'd3;  // back to idle
                    end

                    default: begin
                        step <= 2'd3;
                    end
                endcase
            end
        end
    end

endmodule