
module serial_divisibility_by_5_using_fsm (
  input  logic clk,
  input  logic rst,
  input  logic new_bit,
  output logic div_by_5
);

  // FSM states = remainder modulo 5
  logic [2:0] rem, rem_next;

  // state register
  always_ff @(posedge clk) begin
    if (rst)
      rem <= 3'd0;
    else
      rem <= rem_next;
  end

  // next-state logic: (old * 2 + new_bit) % 5
  always_comb begin
    case (rem)
      3'd0: rem_next = new_bit ? 3'd1 : 3'd0;
      3'd1: rem_next = new_bit ? 3'd3 : 3'd2;
      3'd2: rem_next = new_bit ? 3'd0 : 3'd4;
      3'd3: rem_next = new_bit ? 3'd2 : 3'd1;
      3'd4: rem_next = new_bit ? 3'd4 : 3'd3;
      default: rem_next = 3'd0;
    endcase
  end

  // output: divisible by 5 iff remainder == 0
  always_comb begin
    div_by_5 = (rem == 3'd0);
  end

endmodule