// cla64_flat.v
// A flat, unblocked 64-bit carry-lookahead adder: every carry is computed
// directly (two-level, no rippling), exactly like cla4.v, just scaled to
// 64 bits. Add delays throughout (same convention as cla4.v) so it can be
// fairly compared against rca64.v and cla64_blocked.v.

module cla64_flat(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [63:0] p, g;
  wire [64:1] c;

  // ---------------------------------------------------------------------
  // Step 1: generate/propagate signals -- WORKED EXAMPLE
  //
  // This part is genuinely uniform across all 64 bits (same operation at
  // every position), so a generate-for loop is the right tool here.
  // `genvar` is a compile-time-only loop variable -- it does not exist as
  // a real signal in the final circuit, it just controls how many times
  // the loop body is elaborated.
  // ---------------------------------------------------------------------
  genvar i;
  generate
    for (i = 0; i < 64; i = i + 1) begin : gen_pg
      xor #(2) (p[i], a[i], b[i]);
      and #(2) (g[i], a[i], b[i]);
    end
  endgenerate

  // ---------------------------------------------------------------------
  // Step 2: direct carry equations
  // ---------------------------------------------------------------------

  wire [63:0] t1;
  wire [62:0] t2;
  wire [61:0] t3;
  wire [60:0] t4;
  wire [59:0] t5;
  wire [58:0] t6;
  wire [57:0] t7;
  wire [56:0] t8;
  wire [55:0] t9;
  wire [54:0] t10;
  wire [53:0] t11;
  wire [52:0] t12;
  wire [51:0] t13;
  wire [50:0] t14;
  wire [49:0] t15;
  wire [48:0] t16;
  wire [47:0] t17;
  wire [46:0] t18;
  wire [45:0] t19;
  wire [44:0] t20;
  wire [43:0] t21;
  wire [42:0] t22;
  wire [41:0] t23;
  wire [40:0] t24;
  wire [39:0] t25;
  wire [38:0] t26;
  wire [37:0] t27;
  wire [36:0] t28;
  wire [35:0] t29;
  wire [34:0] t30;
  wire [33:0] t31;
  wire [32:0] t32;
  wire [31:0] t33;
  wire [30:0] t34;
  wire [29:0] t35;
  wire [28:0] t36;
  wire [27:0] t37;
  wire [26:0] t38;
  wire [25:0] t39;
  wire [24:0] t40;
  wire [23:0] t41;
  wire [22:0] t42;
  wire [21:0] t43;
  wire [20:0] t44;
  wire [19:0] t45;
  wire [18:0] t46;
  wire [17:0] t47;
  wire [16:0] t48;
  wire [15:0] t49;
  wire [14:0] t50;
  wire [13:0] t51;
  wire [12:0] t52;
  wire [11:0] t53;
  wire [10:0] t54;
  wire [9:0]  t55;
  wire [8:0]  t56;
  wire [7:0]  t57;
  wire [6:0]  t58;
  wire [5:0]  t59;
  wire [4:0]  t60;
  wire [3:0]  t61;
  wire [2:0]  t62;
  wire [1:0]  t63;
  wire t64;

  // c1
  and #(2) (t1[0], p[0], cin);
  or  #(2) (c[1], g[0], t1[0]);

  // c2
  and #(2) (t1[1], p[1], g[0]);
  and #(2) (t2[0], p[1], p[0], cin);
  or  #(2) (c[2], g[1], t1[1], t2[0]);

  // c3
  and #(2) (t1[2], p[2], g[1]);
  and #(2) (t2[1], p[2], p[1], g[0]);
  and #(2) (t3[0], p[2], p[1], p[0], cin);
  or  #(2) (c[3], g[2], t1[2], t2[1], t3[0]);

  // c4
  and #(2) (t1[3], p[3], g[2]);
  and #(2) (t2[2], p[3], p[2], g[1]);
  and #(2) (t3[1], p[3], p[2], p[1], g[0]);
  and #(2) (t4[0], p[3], p[2], p[1], p[0], cin);
  or  #(2) (c[4], g[3], t1[3], t2[2], t3[1], t4[0]);

  // c5
  and #(2) (t1[4], p[4], g[3]);
  and #(2) (t2[3], p[4], p[3], g[2]);
  and #(2) (t3[2], p[4], p[3], p[2], g[1]);
  and #(2) (t4[1], p[4], p[3], p[2], p[1], g[0]);
  and #(2) (t5[0], p[4], p[3], p[2], p[1], p[0], cin);
  or  #(2) (c[5], g[4], t1[4], t2[3], t3[2], t4[1], t5[0]);

  // ---------------------------------------------------------------------
  // The remaining carries follow exactly the same direct pattern:
  //
  // c[k] = g[k-1]
  //      | p[k-1]g[k-2]
  //      | p[k-1]p[k-2]g[k-3]
  //      | ...
  //      | p[k-1]...p[0]cin
  //
  // ---------------------------------------------------------------------

  assign #(2) c[6] =
      g[5]
    | (p[5] & g[4])
    | (p[5] & p[4] & g[3])
    | (p[5] & p[4] & p[3] & g[2])
    | (p[5] & p[4] & p[3] & p[2] & g[1])
    | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
    | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);

  assign #(2) c[7] =
      g[6]
    | (p[6] & g[5])
    | (p[6] & p[5] & g[4])
    | (p[6] & p[5] & p[4] & g[3])
    | (p[6] & p[5] & p[4] & p[3] & g[2])
    | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
    | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
    | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);

  assign #(2) c[8] =
      g[7]
    | (p[7] & g[6])
    | (p[7] & p[6] & g[5])
    | (p[7] & p[6] & p[5] & g[4])
    | (p[7] & p[6] & p[5] & p[4] & g[3])
    | (p[7] & p[6] & p[5] & p[4] & p[3] & g[2])
    | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
    | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
    | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & cin);

  // ---------------------------------------------------------------------
  // Step 3: sum bits
  // ---------------------------------------------------------------------
  assign #(2) sum = p ^ {c[63:1], cin};

  assign #(2) cout = c[64];

endmodule
