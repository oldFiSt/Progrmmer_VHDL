module detect_6_bit_sequence_using_fsm (
  input  logic clk,
  input  logic rst,
  input  logic a,
  output logic detected
);

  // Moore FSM for pattern 110011
  // detected = 1 when state == S6 (one clock AFTER last bit, as in the given test)

  logic [2:0] state, next_state;

  localparam logic [2:0]
    S0 = 3'd0, // matched: -
    S1 = 3'd1, // matched: 1
    S2 = 3'd2, // matched: 11
    S3 = 3'd3, // matched: 110
    S4 = 3'd4, // matched: 1100
    S5 = 3'd5, // matched: 11001
    S6 = 3'd6; // matched: 110011 (FOUND)

  // state register
  always_ff @(posedge clk) begin
    if (rst) state <= S0;
    else     state <= next_state;
  end

  // Moore output (matches your test timing)
  always_comb begin
    detected = (state == S6);
  end

  // next-state logic (with overlap)
  always_comb begin
    next_state = state;

    case (state)
      S0: next_state = a ? S1 : S0;   // 1
      S1: next_state = a ? S2 : S0;   // 11
      S2: next_state = a ? S2 : S3;   // 110 (on 0), stay on 11 (on 1)
      S3: next_state = a ? S1 : S4;   // 1100 (on 0)
      S4: next_state = a ? S5 : S0;   // 11001 (on 1)
      S5: next_state = a ? S6 : S3;   // 110011 (on 1) else suffix "110"
      S6: next_state = a ? S2 : S3;   // overlap: if next bit 1 -> "11", if 0 -> "110"
      default: next_state = S0;
    endcase
  end

endmodule
