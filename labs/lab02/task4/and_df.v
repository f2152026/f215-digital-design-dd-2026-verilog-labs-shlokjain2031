// and_df.v
// 2-input AND gate, DATAFLOW style, with a continuous-assignment delay.
// The delay applies to the propagation of the assign's result to y.

module and_df (
  input  a,
  input  b,
  output y
);

  assign #1 y = a & b;

endmodule
