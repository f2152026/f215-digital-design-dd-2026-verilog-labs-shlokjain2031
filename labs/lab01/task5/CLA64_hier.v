// cla64_hier.v
// BONUS -- hierarchical (two-level) 64-bit carry-lookahead adder.
//
// Structure:
//   Level 1: sixteen cla4 blocks, exactly as in cla64_blocked.v -- except
//            each block now also exports gblk/pblk, the block-level
//            generate/propagate summaries:
//              gblk = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0
//              pblk = p3.p2.p1.p0
//            (see the added outputs in cla4.v)
//
//   Level 2: a lookahead unit with the SAME shape as cla4's carry block,
//            one level up: it computes every block's carry-in C[1]..C[15]
//            directly from gblk/pblk and cin, instead of rippling block to
//            block:
//              C[k] = gblk[k-1] + pblk[k-1].gblk[k-2] + ...
//                                       + pblk[k-1]...pblk[0].cin
//
// The block carries therefore all appear after a constant two gate levels
// instead of after fifteen sequential block delays. (cout is taken from
// block15's own cout; C[16] is the identical signal computed by the
// lookahead unit, kept here to complete the pattern.)

module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [15:0] gblk, pblk;   // block-level generate / propagate
  wire [16:1] C;            // carry INTO block k is C[k] (C[0] is cin)

  // ---------------------------------------------------------------------
  // Level 1: the sixteen 4-bit CLA blocks
  // ---------------------------------------------------------------------
  cla4 block0  (.a(a[3:0]), .b(b[3:0]), .cin(cin),
               .sum(sum[3:0]), .cout(),
               .gblk(gblk[0]), .pblk(pblk[0]));
  cla4 block1  (.a(a[7:4]), .b(b[7:4]), .cin(C[1]),
               .sum(sum[7:4]), .cout(),
               .gblk(gblk[1]), .pblk(pblk[1]));
  cla4 block2  (.a(a[11:8]), .b(b[11:8]), .cin(C[2]),
               .sum(sum[11:8]), .cout(),
               .gblk(gblk[2]), .pblk(pblk[2]));
  cla4 block3  (.a(a[15:12]), .b(b[15:12]), .cin(C[3]),
               .sum(sum[15:12]), .cout(),
               .gblk(gblk[3]), .pblk(pblk[3]));
  cla4 block4  (.a(a[19:16]), .b(b[19:16]), .cin(C[4]),
               .sum(sum[19:16]), .cout(),
               .gblk(gblk[4]), .pblk(pblk[4]));
  cla4 block5  (.a(a[23:20]), .b(b[23:20]), .cin(C[5]),
               .sum(sum[23:20]), .cout(),
               .gblk(gblk[5]), .pblk(pblk[5]));
  cla4 block6  (.a(a[27:24]), .b(b[27:24]), .cin(C[6]),
               .sum(sum[27:24]), .cout(),
               .gblk(gblk[6]), .pblk(pblk[6]));
  cla4 block7  (.a(a[31:28]), .b(b[31:28]), .cin(C[7]),
               .sum(sum[31:28]), .cout(),
               .gblk(gblk[7]), .pblk(pblk[7]));
  cla4 block8  (.a(a[35:32]), .b(b[35:32]), .cin(C[8]),
               .sum(sum[35:32]), .cout(),
               .gblk(gblk[8]), .pblk(pblk[8]));
  cla4 block9  (.a(a[39:36]), .b(b[39:36]), .cin(C[9]),
               .sum(sum[39:36]), .cout(),
               .gblk(gblk[9]), .pblk(pblk[9]));
  cla4 block10 (.a(a[43:40]), .b(b[43:40]), .cin(C[10]),
               .sum(sum[43:40]), .cout(),
               .gblk(gblk[10]), .pblk(pblk[10]));
  cla4 block11 (.a(a[47:44]), .b(b[47:44]), .cin(C[11]),
               .sum(sum[47:44]), .cout(),
               .gblk(gblk[11]), .pblk(pblk[11]));
  cla4 block12 (.a(a[51:48]), .b(b[51:48]), .cin(C[12]),
               .sum(sum[51:48]), .cout(),
               .gblk(gblk[12]), .pblk(pblk[12]));
  cla4 block13 (.a(a[55:52]), .b(b[55:52]), .cin(C[13]),
               .sum(sum[55:52]), .cout(),
               .gblk(gblk[13]), .pblk(pblk[13]));
  cla4 block14 (.a(a[59:56]), .b(b[59:56]), .cin(C[14]),
               .sum(sum[59:56]), .cout(),
               .gblk(gblk[14]), .pblk(pblk[14]));
  cla4 block15 (.a(a[63:60]), .b(b[63:60]), .cin(C[15]),
               .sum(sum[63:60]), .cout(cout),
               .gblk(gblk[15]), .pblk(pblk[15]));

  // ---------------------------------------------------------------------
  // Level 2: the block-level lookahead unit
  // ---------------------------------------------------------------------
  assign #(2) C[1] =
      gblk[0]
    | (pblk[0] & cin);

  assign #(2) C[2] =
      gblk[1]
    | (pblk[1] & gblk[0])
    | (pblk[1] & pblk[0] & cin);

  assign #(2) C[3] =
      gblk[2]
    | (pblk[2] & gblk[1])
    | (pblk[2] & pblk[1] & gblk[0])
    | (pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[4] =
      gblk[3]
    | (pblk[3] & gblk[2])
    | (pblk[3] & pblk[2] & gblk[1])
    | (pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[5] =
      gblk[4]
    | (pblk[4] & gblk[3])
    | (pblk[4] & pblk[3] & gblk[2])
    | (pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[6] =
      gblk[5]
    | (pblk[5] & gblk[4])
    | (pblk[5] & pblk[4] & gblk[3])
    | (pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[7] =
      gblk[6]
    | (pblk[6] & gblk[5])
    | (pblk[6] & pblk[5] & gblk[4])
    | (pblk[6] & pblk[5] & pblk[4] & gblk[3])
    | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[8] =
      gblk[7]
    | (pblk[7] & gblk[6])
    | (pblk[7] & pblk[6] & gblk[5])
    | (pblk[7] & pblk[6] & pblk[5] & gblk[4])
    | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])
    | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[9] =
      gblk[8]
    | (pblk[8] & gblk[7])
    | (pblk[8] & pblk[7] & gblk[6])
    | (pblk[8] & pblk[7] & pblk[6] & gblk[5])
    | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])
    | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])
    | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[10] =
      gblk[9]
    | (pblk[9] & gblk[8])
    | (pblk[9] & pblk[8] & gblk[7])
    | (pblk[9] & pblk[8] & pblk[7] & gblk[6])
    | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])
    | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])
    | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])
    | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[11] =
      gblk[10]
    | (pblk[10] & gblk[9])
    | (pblk[10] & pblk[9] & gblk[8])
    | (pblk[10] & pblk[9] & pblk[8] & gblk[7])
    | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])
    | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])
    | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])
    | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])
    | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[12] =
      gblk[11]
    | (pblk[11] & gblk[10])
    | (pblk[11] & pblk[10] & gblk[9])
    | (pblk[11] & pblk[10] & pblk[9] & gblk[8])
    | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7])
    | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])
    | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])
    | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])
    | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])
    | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[13] =
      gblk[12]
    | (pblk[12] & gblk[11])
    | (pblk[12] & pblk[11] & gblk[10])
    | (pblk[12] & pblk[11] & pblk[10] & gblk[9])
    | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8])
    | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7])
    | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])
    | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])
    | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])
    | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])
    | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[14] =
      gblk[13]
    | (pblk[13] & gblk[12])
    | (pblk[13] & pblk[12] & gblk[11])
    | (pblk[13] & pblk[12] & pblk[11] & gblk[10])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & gblk[9])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[15] =
      gblk[14]
    | (pblk[14] & gblk[13])
    | (pblk[14] & pblk[13] & gblk[12])
    | (pblk[14] & pblk[13] & pblk[12] & gblk[11])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & gblk[10])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & gblk[9])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

  assign #(2) C[16] =
      gblk[15]
    | (pblk[15] & gblk[14])
    | (pblk[15] & pblk[14] & gblk[13])
    | (pblk[15] & pblk[14] & pblk[13] & gblk[12])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & gblk[11])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & gblk[10])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & gblk[9])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & gblk[8])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & gblk[7])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & gblk[6])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & gblk[5])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & gblk[4])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & gblk[3])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & gblk[2])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & gblk[1])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & gblk[0])
    | (pblk[15] & pblk[14] & pblk[13] & pblk[12] & pblk[11] & pblk[10] & pblk[9] & pblk[8] & pblk[7] & pblk[6] & pblk[5] & pblk[4] & pblk[3] & pblk[2] & pblk[1] & pblk[0] & cin);

endmodule
