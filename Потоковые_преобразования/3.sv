module double_tokens (
  input        clk,
  input        rst,
  input        a,
  output logic b,
  output logic overflow
);

  logic [8:0] pending;
  logic [7:0] one_count;
  logic [9:0] next_pending;

  always_ff @(posedge clk) begin
    if (rst) begin
      pending   <= 9'd0;
      one_count <= 8'd0;
      b         <= 1'b0;
      overflow  <= 1'b0;
    end else begin
      next_pending = pending;
      b = 1'b0;

      // приём входных единиц
      if (a) begin
        next_pending = next_pending + 2;

        if (one_count < 8'd200)
          one_count <= one_count + 1'b1;
        else
          overflow <= 1'b1;
      end else begin
        one_count <= 8'd0;
      end

      // выдача выходных единиц
      if (next_pending != 0) begin
        b = 1'b1;
        next_pending = next_pending - 1;
      end

      pending <= next_pending;
    end
  end

endmodule