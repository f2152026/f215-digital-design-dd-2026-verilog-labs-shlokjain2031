// tb.v
// Self-checking testbench for the 1-bit-opcode ALU (Task 5).
// Exercises: same operand pair with op toggled (exposes the sensitivity-list
// bug), and several subtraction pairs (exposes the blocking/non-blocking bug).

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer errors;
  reg [3:0] exp;

  task check(input [3:0] a_i, input [3:0] b_i, input op_i);
    begin
      t_a = a_i; t_b = b_i; t_op = op_i;
      #5;
      exp = op_i ? ((a_i - b_i) & 4'hF) : ((a_i + b_i) & 4'hF);
      if (t_result !== exp) begin
        $display("FAIL: a=%0d b=%0d op=%b  got %0d  expected %0d",
                 a_i, b_i, op_i, t_result, exp);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;

    // Same operand pair, toggle op only (sensitivity-list check).
    check(4'd5, 4'd3, 1'b0);   // 5 + 3 = 8
    check(4'd5, 4'd3, 1'b1);   // 5 - 3 = 2

    // Subtraction with changing operands (dependency-chain check).
    check(4'd8, 4'd2, 1'b1);   // 8 - 2 = 6
    check(4'd3, 4'd7, 1'b1);   // 3 - 7 = -4 -> 12 (mod 16)
    check(4'd9, 4'd9, 1'b1);   // 9 - 9 = 0
    check(4'd15, 4'd1, 1'b0);  // 15 + 1 = 16 -> 0 (mod 16)

    $write("Result: errors = %0d", errors);
    $display("");
    if (errors == 0) $display("ALL_ALU_TESTS_PASSED");
    $finish;
  end

endmodule
