// lut.v
// A small parameterized ROM (lookup table): DEPTH words, each WIDTH bits
// wide. dout continuously reflects mem[sel].
//
// YOU complete the two TODOs below. Everything else is given.

module lut #(
  parameter WIDTH = 8,
  parameter DEPTH = 4
) (
  input      [$clog2(DEPTH)-1:0] sel,
  output reg [WIDTH-1:0]         dout
);

  reg [WIDTH-1:0] mem [0:DEPTH-1];

  integer i;

  // ROM contents: load once at time 0, before anything reads from it.
  initial begin
    for (i = 0; i < DEPTH; i = i + 1)
      mem[i] = i * i;
  end
  

  // Combinational read: dout reflects mem[sel] whenever sel (or mem) changes.
  always @(*)
    dout = mem[sel];


endmodule
