module detect_6_bit_sequence_using_shift_reg (
  input  logic clk,
  input  logic rst,
  input  logic new_bit,
  output logic detected
);

  logic [5:0] shift_reg;

  // Сдвиговый регистр (синхронный сброс)
  always_ff @(posedge clk) begin
    if (rst)
      shift_reg <= 6'b000000;
    else
      shift_reg <= {shift_reg[4:0], new_bit};
  end

  // Комбинаторное формирование сигнала обнаружения
  always_comb begin
    if (shift_reg == 6'b110011)
      detected = 1'b1;
    else
      detected = 1'b0;
  end

endmodule