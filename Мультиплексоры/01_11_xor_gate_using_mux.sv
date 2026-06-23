//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux
(
  input  d0, d1,
  input  sel,
  output y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module xor_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Task:
  // Implement xor gate using instance(s) of mux,
  // constants 0 and 1, and wire connections
  wire not_a;

  mux not_mux (
    .d0(1'b1),  // когда a=0, выход = 1
    .d1(1'b0),  // когда a=1, выход = 0
    .sel(a),
    .y(not_a)
  );

  mux xor_mux (
    .d0(a),     // когда b=0, выход = a
    .d1(not_a), // когда b=1, выход = not_a
    .sel(b),
    .y(o)
  );

endmodule