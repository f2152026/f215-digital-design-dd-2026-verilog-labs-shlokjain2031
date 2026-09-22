// and_beh_before.v
// 2-input AND gate, BEHAVIORAL style, with the delay placed BEFORE the
// assignment: the block waits, THEN samples a & b at that later moment.

module and_beh_before (
  input      a,
  input      b,
  output reg y
);

  always @(*)
    #1 y = a & b;

endmodule
