module gearbox_1_to_2 #(
  parameter int width = 1
) (
  input                    clk,
  input                    rst,

  input                    up_vld,
  input  logic [width-1:0] up_data,

  output logic             down_vld,
  output logic [2*width-1:0] down_data
);

  logic [width-1:0] first_word;
  logic             have_first;

  always_ff @(posedge clk) begin
    if (rst) begin
      first_word <= '0;
      have_first <= 1'b0;
      down_vld   <= 1'b0;
      down_data  <= '0;
    end else begin
      down_vld <= 1'b0; // по умолчанию импульс на 1 такт

      if (up_vld) begin
        if (!have_first) begin
          // приняли первое слово
          first_word <= up_data;
          have_first <= 1'b1;
        end else begin
          // приняли второе слово -> выдаём объединение
          down_data  <= {first_word, up_data}; // AB
          down_vld   <= 1'b1;
          have_first <= 1'b0;
        end
      end
    end
  end

endmodule