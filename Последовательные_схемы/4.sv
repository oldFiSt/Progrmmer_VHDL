//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_adder_with_vld
(
  input  clk,
  input  rst,
  input  vld,
  input  a,
  input  b,
  input  last,
  output sum
);

  logic carry;
  logic carry_d;
  logic sum_d;

  assign sum_d = a ^ b ^ carry;
  assign carry_d = (a & b) | (a & carry) | (b & carry);

  always_ff @ (posedge clk)
    if (rst)
      carry <= 1'b0;
    else if (vld) begin
      if (last)
        carry <= 1'b0;  // Сброс переноса после последнего бита
      else
        carry <= carry_d;  // Сохраняем перенос для следующего бита
    end

  assign sum = vld ? sum_d : 1'b0;

endmodule
