module formula_2_fsm (
  input  logic        clk,
  input  logic        rst,

  input  logic        arg_vld,
  input  logic [31:0] a,
  input  logic [31:0] b,
  input  logic [31:0] c,

  output logic        res_vld,
  output logic [15:0] res,

  // single isqrt interface
  output logic        isqrt_x_vld,
  output logic [31:0] isqrt_x,
  input  logic        isqrt_y_vld,
  input  logic [15:0] isqrt_y
);

  // FSM for: res = isqrt(a + isqrt(b + isqrt(c)))

  typedef enum logic [2:0] {
    ST_IDLE,
    ST_SEND_C,
    ST_WAIT_C,
    ST_SEND_B,
    ST_WAIT_B,
    ST_SEND_A,
    ST_WAIT_A,
    ST_OUT
  } state_t;

  state_t state;

  logic [31:0] a_r, b_r, c_r;
  logic [15:0] yc_r;    // isqrt(c)
  logic [15:0] ybc_r;   // isqrt(b + isqrt(c))

  always_ff @(posedge clk) begin
    if (rst) begin
      state        <= ST_IDLE;

      a_r          <= '0;
      b_r          <= '0;
      c_r          <= '0;

      yc_r         <= '0;
      ybc_r        <= '0;

      isqrt_x_vld  <= 1'b0;
      isqrt_x      <= '0;

      res_vld      <= 1'b0;
      res          <= '0;

    end else begin
      // defaults every cycle
      isqrt_x_vld <= 1'b0;
      res_vld     <= 1'b0;

      case (state)
        ST_IDLE: begin
          if (arg_vld) begin
            a_r   <= a;
            b_r   <= b;
            c_r   <= c;
            state <= ST_SEND_C;
          end
        end

        // --- isqrt(c)
        ST_SEND_C: begin
          isqrt_x_vld <= 1'b1;
          isqrt_x     <= c_r;
          state       <= ST_WAIT_C;
        end

        ST_WAIT_C: begin
          if (isqrt_y_vld) begin
            yc_r  <= isqrt_y;
            state <= ST_SEND_B;
          end
        end

        // --- isqrt(b + isqrt(c))
        ST_SEND_B: begin
          isqrt_x_vld <= 1'b1;
          isqrt_x     <= b_r + {{16{1'b0}}, yc_r};
          state       <= ST_WAIT_B;
        end

        ST_WAIT_B: begin
          if (isqrt_y_vld) begin
            ybc_r <= isqrt_y;
            state <= ST_SEND_A;
          end
        end

        // --- isqrt(a + isqrt(b + isqrt(c)))
        ST_SEND_A: begin
          isqrt_x_vld <= 1'b1;
          isqrt_x     <= a_r + {{16{1'b0}}, ybc_r};
          state       <= ST_WAIT_A;
        end

        ST_WAIT_A: begin
          if (isqrt_y_vld) begin
            res   <= isqrt_y;
            state <= ST_OUT;
          end
        end

        ST_OUT: begin
          res_vld <= 1'b1;
          state   <= ST_IDLE;
        end

        default: state <= ST_IDLE;
      endcase
    end
  end

endmodule