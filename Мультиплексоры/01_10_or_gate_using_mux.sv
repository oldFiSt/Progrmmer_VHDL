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

module or_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Task:

  // Implement or gate using instance(s) of mux,
  // constants 0 and 1, and wire connections
  mux or_mux (
    .d0(a),     // когда b=0, выход = a
    .d1(1'b1),  // когда b=1, выход = 1
    .sel(b),    // один вход - селектор
    .y(o)
  );

endmodule
