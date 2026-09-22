// tb.v
// Self-checking testbench for the parameterized ROM `lut` (Task 2).
// Instantiates lut with a parameter override (WIDTH=8, DEPTH=8) and checks
// every address against the i*i value the module loads.

module tb;

  // sel declared wide enough (3 bits) to cover DEPTH up to 8.
  reg  [2:0] t_sel;
  wire [7:0] t_dout;

  // Parameter override at instantiation -- the only way to set parameters.
  lut #(.WIDTH(8), .DEPTH(8)) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer i, errors;
  initial begin
    errors = 0;
    #1;  // let the initial ROM load settle
    for (i = 0; i < 8; i = i + 1) begin
      t_sel = i[2:0];
      #5;
      if (t_dout !== (i * i)) begin
        $display("FAIL at sel=%0d: got %0d, expected %0d", i, t_dout, i * i);
        errors = errors + 1;
      end
    end
    $write("Result: %0d of 8 addresses passed", 8 - errors);
    $display("");
    if (errors == 0) $display("ALL_LUT_TESTS_PASSED");
    $finish;
  end

  initial
    $monitor($time, " sel=%0d | dout=%0d", t_sel, t_dout);

endmodule
