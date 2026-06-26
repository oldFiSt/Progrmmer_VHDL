module serial_comparator_most_significant_first_using_fsm (
  input  logic clk,
  input  logic rst,
  input  logic a,
  input  logic b,
  output logic a_less_b,
  output logic a_eq_b,
  output logic a_greater_b
);

  logic [1:0] state, next_state;

  localparam logic [1:0]
    ST_EQ      = 2'd0,
    ST_LESS    = 2'd1,
    ST_GREATER = 2'd2;

  // State register
  always_ff @(posedge clk) begin
    if (rst !== 1'b0)
      state <= ST_EQ;
    else
      state <= next_state;
  end

  // Mealy next-state + outputs (seen immediately after posedge in the test)
  always_comb begin
    // defaults
    next_state   = state;
    a_less_b     = 1'b0;
    a_eq_b       = 1'b0;
    a_greater_b  = 1'b0;

    // during reset force "equal"
    if (rst !== 1'b0) begin
      next_state  = ST_EQ;
      a_eq_b      = 1'b1;
    end else begin
      case (state)
        ST_EQ: begin
          // While equal so far, decision is based on CURRENT incoming bits.
          // Use === to avoid X/Z causing wrong decisions.
          if      (a === 1'b0 && b === 1'b1) begin
            a_less_b   = 1'b1;
            next_state = ST_LESS;
          end
          else if (a === 1'b1 && b === 1'b0) begin
            a_greater_b = 1'b1;
            next_state  = ST_GREATER;
          end
          else begin
            // a===b (including X==X) OR any X/Z -> still "equal so far"
            a_eq_b     = 1'b1;
            next_state = ST_EQ;
          end
        end

        ST_LESS: begin
          a_less_b   = 1'b1;
          next_state = ST_LESS;
        end

        ST_GREATER: begin
          a_greater_b = 1'b1;
          next_state  = ST_GREATER;
        end

        default: begin
          a_eq_b     = 1'b1;
          next_state = ST_EQ;
        end
      endcase
    end
  end

endmodule