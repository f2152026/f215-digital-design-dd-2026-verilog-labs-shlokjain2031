// tb.v
// Completed testbench for the 2-to-1 MUX (Task 1).
//
// Applies all 8 combinations of I0, I1, S (5 time units apart) to DUT
// and observes the output.

module tb;

  // Three DUT inputs are stimulus -> reg (driven from procedural code).
  reg   t_i0, t_i1, t_s;
  // DUT output is a net driven by the DUT -> wire.
  wire  t_y;

  // Instantiate the DUT wrapper (dut.v selects mux_df or mux_beh internally).
  DUT DUT (
    .I0 (t_i0),
    .I1 (t_i1),
    .S  (t_s),
    .Y  (t_y)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer i;
  initial begin
    // Apply all 8 combinations of {I0, I1, S}, 5 time units apart.
    for (i = 0; i < 8; i = i + 1) begin
      {t_i0, t_i1, t_s} = i[2:0];
      #5;
    end
    $finish;
  end

  initial
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b", t_i0, t_i1, t_s, t_y);

endmodule
