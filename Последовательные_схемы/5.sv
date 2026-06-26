//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_comparator_least_significant_first
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);

  logic prev_a_eq_b, prev_a_less_b;

  assign a_eq_b      = prev_a_eq_b & (a == b);
  assign a_less_b    = (~ a & b) | (a == b & prev_a_less_b);
  assign a_greater_b = (~ a_eq_b) & (~ a_less_b);

  always_ff @ (posedge clk)
    if (rst)
    begin
      prev_a_eq_b   <= '1;
      prev_a_less_b <= '0;
    end
    else
    begin
      prev_a_eq_b   <= a_eq_b;
      prev_a_less_b <= a_less_b;
    end

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_comparator_most_significant_first
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);

  logic result_less, result_eq, result_greater;
  logic prev_less, prev_eq, prev_greater;

  // Комбинационная логика сравнения
  assign result_less    = prev_eq & (~a & b);
  assign result_greater = prev_eq & (a & ~b);
  assign result_eq      = prev_eq & (a == b);

  // Выходные сигналы
  assign a_less_b    = prev_less | result_less;
  assign a_greater_b = prev_greater | result_greater;
  assign a_eq_b      = result_eq;

  always_ff @ (posedge clk)
    if (rst) begin
      prev_less    <= 1'b0;
      prev_eq      <= 1'b1;  // Начинаем с предположения, что числа равны
      prev_greater <= 1'b0;
    end else begin
      prev_less    <= a_less_b;
      prev_eq      <= a_eq_b;
      prev_greater <= a_greater_b;
    end

endmodule