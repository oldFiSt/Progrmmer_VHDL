module formula_1_impl_2_fsm (
  input  logic        clk,
  input  logic        rst,

  input  logic        arg_vld,
  input  logic [31:0] a,
  input  logic [31:0] b,
  input  logic [31:0] c,

  output logic        res_vld,
  output logic [17:0] res,

  output logic        isqrt_1_x_vld,
  output logic [31:0] isqrt_1_x,
  input  logic        isqrt_1_y_vld,
  input  logic [15:0] isqrt_1_y,

  output logic        isqrt_2_x_vld,
  output logic [31:0] isqrt_2_x,
  input  logic        isqrt_2_y_vld,
  input  logic [15:0] isqrt_2_y
);

  typedef enum logic [2:0] {
    ST_IDLE,
    ST_WAIT_AB,
    ST_SEND_C,
    ST_WAIT_C,
    ST_OUT
  } st_t;

  st_t st;

  logic [31:0] a_r, b_r, c_r;
  logic [15:0] ya_r, yb_r, yc_r;
  logic        got_1, got_2;

  always_ff @(posedge clk) begin
    if (rst) begin
      st            <= ST_IDLE;

      a_r           <= '0;
      b_r           <= '0;
      c_r           <= '0;

      ya_r          <= '0;
      yb_r          <= '0;
      yc_r          <= '0;

      got_1         <= 1'b0;
      got_2         <= 1'b0;

      res_vld       <= 1'b0;
      res           <= '0;

      isqrt_1_x_vld <= 1'b0;
      isqrt_1_x     <= '0;
      isqrt_2_x_vld <= 1'b0;
      isqrt_2_x     <= '0;

    end else begin
      // defaults
      res_vld       <= 1'b0;
      isqrt_1_x_vld <= 1'b0;
      isqrt_2_x_vld <= 1'b0;

      // capture results for a and b
      if (st == ST_WAIT_AB) begin
        if (isqrt_1_y_vld) begin
          ya_r  <= isqrt_1_y;
          got_1 <= 1'b1;
        end
        if (isqrt_2_y_vld) begin
          yb_r  <= isqrt_2_y;
          got_2 <= 1'b1;
        end
      end

      // capture result for c (from isqrt_1)
      if (st == ST_WAIT_C) begin
        if (isqrt_1_y_vld) begin
          yc_r <= isqrt_1_y;
        end
      end

      case (st)
        ST_IDLE: begin
          got_1 <= 1'b0;
          got_2 <= 1'b0;

          if (arg_vld) begin
            a_r <= a;
            b_r <= b;
            c_r <= c;

            // start isqrt(a) and isqrt(b) in parallel
            isqrt_1_x_vld <= 1'b1;
            isqrt_1_x     <= a;

            isqrt_2_x_vld <= 1'b1;
            isqrt_2_x     <= b;

            st <= ST_WAIT_AB;
          end
        end

        ST_WAIT_AB: begin
          if (got_1 && got_2)
            st <= ST_SEND_C;
        end

        ST_SEND_C: begin
          // start isqrt(c) on isqrt_1
          isqrt_1_x_vld <= 1'b1;
          isqrt_1_x     <= c_r;
          st            <= ST_WAIT_C;
        end

        ST_WAIT_C: begin
          if (isqrt_1_y_vld)
            st <= ST_OUT;
        end

        ST_OUT: begin
          res     <= {2'b00, ya_r} + {2'b00, yb_r} + {2'b00, yc_r};
          res_vld <= 1'b1;
          st      <= ST_IDLE;
        end

        default: st <= ST_IDLE;
      endcase
    end
  end

endmodule
