
module halve_tokens (
  input  logic clk,
  input  logic rst,
  input  logic a,
  output logic b
);

  logic one_seen; // флаг: была ли уже одна единица

  always_ff @(posedge clk) begin
    if (rst) begin
      one_seen <= 1'b0;
      b        <= 1'b0;
    end else begin
      if (a) begin
        one_seen <= ~one_seen;   // переключаемся на каждой единице
        b        <= one_seen;    // 1 только на каждой второй единице
      end else begin
        b <= 1'b0;
      end
    end
  end

endmodule