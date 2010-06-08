/*
 Top level Multiple Add unit for Mosiac 2 functional unit

 Author: Nathaniel McVicar
 Date: 5/06/2010
*/

module MADD (CLK, A, B, C, Z);

   input         CLK;
   input [31:0]  A;
   input [31:0]  B;
   input [31:0]  C;
   output [31:0] Z;

   wire [35:0]   pprow0, pprow14;
   wire [34:0]   pprow1, pprow2, pprow3, pprow4, pprow5, pprow6, pprow7,
                 pprow8, pprow9, pprow10, pprow11, pprow12, pprow13;
   wire [33:0]   pprow15;

   reg [35:0]    pprow0r, pprow14r;
   reg [34:0]    pprow1r, pprow2r, pprow3r, pprow4r, pprow5r, pprow6r, pprow7r,
                 pprow8r, pprow9r, pprow10r, pprow11r, pprow12r, pprow13r;
   reg [33:0]    pprow15r;
   reg [31:0]    rA, rC;

   // Totally behavioral way of doing things, about 2ns too slow
   //assign Z = (A * B) + C;

   // Get partial product rows
   BoothMult bmul (A, B, pprow0, pprow1, pprow2, pprow3, pprow4, pprow5,pprow6,
                   pprow7, pprow8, pprow9, pprow10, pprow11, pprow12, pprow13,
                   pprow14, pprow15);

   // Register A, C and all the row computations, to compute output
   always @* begin
      rA <= A;
      rC <= C;
   end

   always @* begin
      pprow0r <= pprow0;
      pprow1r <= pprow1;
      pprow2r <= pprow2;
      pprow3r <= pprow3;
      pprow4r <= pprow4;
      pprow5r <= pprow5;
      pprow6r <= pprow6;
      pprow7r <= pprow7;
      pprow8r <= pprow8;
      pprow9r <= pprow9;
      pprow10r <= pprow10;
      pprow11r <= pprow11;
      pprow12r <= pprow12;
      pprow13r <= pprow13;
      pprow14r <= pprow14;
      pprow15r <= pprow15;
   end


   // Add everything up, to produce 32 bit output
   // TODO Replace with compressors and stuff, could be a for loop too
/*   assign Z = rC + pprow0r[31:0] + {pprow1r[29:0], 1'b0, rA[1]} +
              {pprow2r[27:0], 1'b0, rA[3], 2'b0} +
              {pprow3r[25:0], 1'b0, rA[5], 4'b0} +
              {pprow4r[23:0], 1'b0, rA[7], 6'b0} +
              {pprow5r[21:0], 1'b0, rA[9], 8'b0} +
              {pprow6r[19:0], 1'b0, rA[11], 10'b0} +
              {pprow7r[17:0], 1'b0, rA[13], 12'b0} +
              {pprow8r[15:0], 1'b0, rA[15], 14'b0} +
              {pprow9r[13:0], 1'b0, rA[17], 16'b0} +
              {pprow10r[11:0], 1'b0, rA[19], 18'b0} +
              {pprow11r[9:0], 1'b0, rA[21], 20'b0} +
              {pprow12r[7:0], 1'b0, rA[23], 22'b0} +
              {pprow13r[5:0], 1'b0, rA[25], 24'b0} +
              {pprow14r[3:0], 1'b0, rA[27], 26'b0} +
              {pprow15r[1:0], 1'b0, rA[29], 28'b0} +
              {1'b0, rA[31], 30'b0};
 */

   // Carry save tree version
   wire [31:0] sum0, sum1, sum2, sum3, sum4, sum5;
   wire [31:0] cout0, cout1, cout2, cout3, cout4, cout5;

//   csa32 add0 (.A(32'b0/*rC*/), .B({pprow8r[15:0], 1'b0, rA[15], 14'b0}), .C({1'b0, rA[31], 30'b0}), .S(sum0), .Cout(cout0)); // Total bits 50
   assign sum0 = {pprow8r[15:0], 1'b0, rA[15], 14'b0};
   assign cout0 = 32'b0;
   csa32 add1 (.A(pprow0r[31:0]), .B({pprow9r[13:0], 1'b0, rA[17], 16'b0}), .C({pprow15r[1:0], 1'b0, rA[29], 28'b0}), .S(sum1), .Cout(cout1)); // Total bits 51
   csa32 add2 (.A({pprow1r[29:0], 1'b0, rA[1]}), .B({pprow10r[11:0], 1'b0, rA[19], 18'b0}), .C({pprow14r[3:0], 1'b0, rA[27], 26'b0}), .S(sum2), .Cout(cout2)); // Total bits 53
   csa32 add3 (.A({pprow2r[27:0], 1'b0, rA[3], 2'b0}), .B({pprow7r[17:0], 1'b0, rA[13], 12'b0}), .C({pprow13r[5:0], 1'b0, rA[25], 24'b0}), .S(sum3), .Cout(cout3)); // Total bits 55
   csa32 add4 (.A({pprow3r[25:0], 1'b0, rA[5], 4'b0}), .B({pprow6r[19:0], 1'b0, rA[11], 10'b0}), .C({pprow12r[7:0], 1'b0, rA[23], 22'b0}), .S(sum4), .Cout(cout4)); // Total bits 57 
   csa32 add5 (.A({pprow4r[23:0], 1'b0, rA[7], 6'b0}), .B({pprow5r[21:0], 1'b0, rA[9], 8'b0}), .C({pprow11r[9:0], 1'b0, rA[21], 20'b0}), .S(sum5), .Cout(cout5)); // Total bits 59

   // Later stages, sums the 12 outputs from first stage
   wire [31:0] sum6, sum7, sum8, sum9, sum10, sum11, sum12, sum13, sum14, sum15, sum16;
   wire [31:0] cout6, cout7, cout8, cout9, cout10, cout11, cout12, cout13, cout14, cout15, cout16;

   // Stage 2
   csa32 add6 (.A(sum0), .B(sum5), .C({cout2[30:0], 1'b0}), .S(sum6), .Cout(cout6));
   csa32 add7 (.A(sum1), .B(sum4), .C({cout3[30:0], 1'b0}), .S(sum7), .Cout(cout7));
   csa32 add8 (.A(sum2), .B({cout0[30:0], 1'b0}), .C({cout5[30:0], 1'b0}), .S(sum8), .Cout(cout8));
   csa32 add9 (.A(sum3), .B({cout1[30:0], 1'b0}), .C({cout4[30:0], 1'b0}), .S(sum9), .Cout(cout9));

   reg [31:0]  rsum6, rsum7, rsum8, rsum9;
   reg [31:0]  rcout6, rcout7, rcout8, rcout9;
   // Register between stage 2 and stage 3
   always @(posedge CLK) begin
      rsum6 <= sum6;
      rsum7 <= sum7;
      rsum8 <= sum8;
      rsum9 <= sum9;
      rcout6 <= cout6;
      rcout7 <= cout7;
      rcout8 <= cout8;
      rcout9 <= cout9;
   end

   // Stage 3
   csa32 add10 (.A(rsum6), .B(rsum9), .C({rcout7[30:0], 1'b0}), .S(sum10), .Cout(cout10));
   csa32 add11 (.A(rsum7), .B({rcout6[30:0], 1'b0}), .C({rcout9[30:0], 1'b0}), .S(sum11), .Cout(cout11));
   csa32 add12 (.A(rsum8), .B({rcout8[30:0], 1'b0}), .C(rC/*32'b0*/), .S(sum12), .Cout(cout12));

   // Stage 4
   csa32 add13 (.A(sum10), .B(sum12), .C({cout11[30:0], 1'b0}), .S(sum13), .Cout(cout13));
   csa32 add14 (.A(sum11), .B({cout10[30:0], 1'b0}), .C({cout12[30:0], 1'b0}), .S(sum14), .Cout(cout14));

   // Stage 5
   csa32 add15 (.A(sum13), .B(sum14), .C({cout13[30:0], 1'b0}), .S(sum15), .Cout(cout15));

   // Stage 6
   csa32 add16 (.A({cout14[30:0], 1'b0}), .B(sum15), .C({cout15[30:0], 1'b0}), .S(sum16), .Cout(cout16));

   // Final adder
   adder_fast finadd(.A(sum16), .B({cout16[30:0], 1'b0}), .Cin(1'b0), .S(Z));
   
endmodule // MADD

// Generates 2's comp of A, using or -> xor tree
// TODO replace with NOR, INV, NAND version?
module Fast2sComp (A, Z);

   input [31:0]  A;
   output [31:0] Z;

   /*
   wire [31:0]   wOrRes;

   assign wOrRes[0] = 0; // Low bit has nothing to or with
   // Rest of bits just build an or tree, so every bit is ored with all lower
   // TODO If synth tool is dumb, I might have to make a tree here by hand
   assign wOrRes[1] = |A[1:0];
   assign wOrRes[2] = |A[2:0];
   assign wOrRes[3] = |A[3:0];
   assign wOrRes[4] = |A[4:0];
   assign wOrRes[5] = |A[5:0];
   assign wOrRes[6] = |A[6:0];
   assign wOrRes[7] = |A[7:0];
   assign wOrRes[8] = |A[8:0];
   assign wOrRes[9] = |A[9:0];
   assign wOrRes[10] = |A[10:0];
   assign wOrRes[11] = |A[11:0];
   assign wOrRes[12] = |A[12:0];
   assign wOrRes[13] = |A[13:0];
   assign wOrRes[14] = |A[14:0];
   assign wOrRes[15] = |A[15:0];
   assign wOrRes[16] = |A[16:0];
   assign wOrRes[17] = |A[17:0];
   assign wOrRes[18] = |A[18:0];
   assign wOrRes[19] = |A[19:0];
   assign wOrRes[20] = |A[20:0];
   assign wOrRes[21] = |A[21:0];
   assign wOrRes[22] = |A[22:0];
   assign wOrRes[23] = |A[23:0];
   assign wOrRes[24] = |A[24:0];
   assign wOrRes[25] = |A[25:0];
   assign wOrRes[26] = |A[26:0];
   assign wOrRes[27] = |A[27:0];
   assign wOrRes[28] = |A[28:0];
   assign wOrRes[29] = |A[29:0];
   assign wOrRes[30] = |A[30:0];
   assign wOrRes[31] = |A[31:0];
   
   // Final stage, just xor to get result
   assign Z = A ^ wOrRes;
    */
   assign Z = ~A + 1'b1;

endmodule // Fast2sComp

// Modified booth encoder, this isn't really required
module ModBoothEnc (X, one, two, neg);

   input [2:0] X;
   output      one, two, neg;

   assign one = X[0] ^ X[1];
   assign two = ~(one | ~(X[1] ^ X[2]));
   assign neg = X[2];
   
endmodule // ModBoothEnc

// Modified booth encoder, this isn't really required
module ModBoothEncLast (X, posone, negone, postwo, negtwo);

   input [2:0] X;
   output      posone, negone, postwo, negtwo;

   assign posone = ~(~(X[0] ^ X[1]) | X[2]);
   assign negone = ~(~(X[0] ^ X[1]) | ~X[2]);
   assign postwo = ~(~(X[0] & X[1]) | X[2]);
   assign negtwo = ~((X[0] | X[1]) | ~X[2]);

endmodule // ModBoothEncLast

// Partial product generation for norma (not first or last) lines
module PPGenNorm (Y, one, two, neg, pp);

   input [31:0]  Y;
   input         one, two, neg;
   output [34:0] pp;

   wire [32:0]   Yzero;

   genvar        i;

   assign Yzero = {1'b0, Y};

   assign pp[34] = 1'b1;
   assign pp[33] = ~(Y[31] ^ neg) | (~one & ~two & ~neg);
   generate for (i = 1; i <= 32; i = i + 1)
     begin : genpp
        assign pp[i] = ((Yzero[i] & one) | (Yzero[i - 1] & two)) ^ neg;
     end
   endgenerate

   assign pp[0] = (Y[0] & one) ^ neg;

endmodule // PPGenNorm

// First and last are the same as norm, except for the first and last positions
module PPGenFirst (Y, one, two, neg, pp);

   input [31:0]  Y;
   input         one, two, neg;
   output [35:0] pp;

   wire [32:0]   Yzero;

   genvar        i;

   assign Yzero = {1'b0, Y};

   assign pp[35] = ~(Y[31] ^ neg) | (~one & ~two & ~neg);
   assign pp[34] = ~(pp[35]);
   assign pp[33] = ~(pp[35]);
   generate for (i = 1; i <= 32; i = i + 1)
     begin : genpp
        assign pp[i] = ((Yzero[i] & one) | (Yzero[i - 1] & two)) ^ neg;
     end
   endgenerate

   assign pp[0] = (Y[0] & one) ^ neg;

endmodule // PPGenFirst

module PPGenPenult (Y, one, two, neg, pp);
   
   input [31:0]  Y;
   input         one, two, neg;
   output [35:0] pp;

   wire [32:0]   Yzero;

   genvar        i;

   assign Yzero = {1'b0, Y};

   assign pp[35] = 1'b1;
   assign pp[34] = 1'b1;
   assign pp[33] = ~(Y[31] ^ neg) | (~one & ~two & ~neg);
   generate for (i = 1; i <= 32; i = i + 1)
     begin : genpp
        assign pp[i] = ((Yzero[i] & one) | (Yzero[i - 1] & two)) ^ neg;
     end
   endgenerate

   assign pp[0] = (Y[0] & one) ^ neg;

endmodule // PPGenPenult

// Final is the crazy 2's comp one
module PPGenLast (Y, posone, negone, postwo, negtwo, pp);
   
   input [31:0]  Y;
   input         posone, negone, postwo, negtwo;
   output [33:0] pp;

   wire [32:0]   plustwo, plusone, minustwo, minusone;
   wire [31:0]   twoscomp;

   Fast2sComp twoscomper (Y, twoscomp);

   // Mux the possible combinations
   assign plustwo = postwo ? {Y, 1'b0} : 32'b0;
   assign plusone = posone ? {Y[31], Y} : 32'b0;
   assign minustwo = negtwo ? {twoscomp, 1'b0} : 32'b0;
   assign minusone = negone ? {twoscomp[31], twoscomp} : 32'b0;

   assign pp[32:0] = plustwo | plusone | minustwo | minusone;
   assign pp[33] = ~pp[32];

endmodule // PPGenLast

// Combine all partial products into rows (16 total)
module BoothMult (X, Y, pprow0, pprow1, pprow2, pprow3, pprow4, pprow5, pprow6,
                  pprow7, pprow8, pprow9, pprow10, pprow11, pprow12, pprow13,
                  pprow14, pprow15);

   input [31:0]  X, Y;
   output [35:0] pprow0, pprow14;
   output [34:0] pprow1, pprow2, pprow3, pprow4, pprow5, pprow6, pprow7,
                 pprow8, pprow9, pprow10, pprow11, pprow12, pprow13;
   output [33:0] pprow15;

   wire          one0, two0, neg0, one1, two1, neg1, one2, two2, neg2;
   wire          one3, two3, neg3, one4, two4, neg4, one5, two5, neg5;
   wire          one6, two6, neg6, one7, two7, neg7, one8, two8, neg8;
   wire          one9, two9, neg9, one10, two10, neg10, one11, two11, neg11;
   wire          one12, two12, neg12, one13, two13, neg13, one14, two14, neg14;
   wire          posone15, negone15, postwo15, negtwo15;

   // Could replace with generate, but what parts are v-2001???
   ModBoothEnc enc0 ({X[1:0], 1'b0}, one0, two0, neg0);
   ModBoothEnc enc1 (X[3:1], one1, two1, neg1);
   ModBoothEnc enc2 (X[5:3], one2, two2, neg2);
   ModBoothEnc enc3 (X[7:5], one3, two3, neg3);
   ModBoothEnc enc4 (X[9:7], one4, two4, neg4);
   ModBoothEnc enc5 (X[11:9], one5, two5, neg5);
   ModBoothEnc enc6 (X[13:11], one6, two6, neg6);
   ModBoothEnc enc7 (X[15:13], one7, two7, neg7);
   ModBoothEnc enc8 (X[17:15], one8, two8, neg8);
   ModBoothEnc enc9 (X[19:17], one9, two9, neg9);
   ModBoothEnc enc10 (X[21:19], one10, two10, neg10);
   ModBoothEnc enc11 (X[23:21], one11, two11, neg11);
   ModBoothEnc enc12 (X[25:23], one12, two12, neg12);
   ModBoothEnc enc13 (X[27:25], one13, two13, neg13);
   ModBoothEnc enc14 (X[29:27], one14, two14, neg14);
   ModBoothEncLast enc15 (X[31:29], posone15, negone15, postwo15, negtwo15);

   // Generate partial products, again, could use generate, but whatever
   PPGenFirst ppgen0 (Y, one0, two0, neg0, pprow0);
   PPGenNorm ppgen1 (Y, one1, two1, neg1, pprow1);
   PPGenNorm ppgen2 (Y, one2, two2, neg2, pprow2);
   PPGenNorm ppgen3 (Y, one3, two3, neg3, pprow3);
   PPGenNorm ppgen4 (Y, one4, two4, neg4, pprow4);
   PPGenNorm ppgen5 (Y, one5, two5, neg5, pprow5);
   PPGenNorm ppgen6 (Y, one6, two6, neg6, pprow6);
   PPGenNorm ppgen7 (Y, one7, two7, neg7, pprow7);
   PPGenNorm ppgen8 (Y, one8, two8, neg8, pprow8);
   PPGenNorm ppgen9 (Y, one9, two9, neg9, pprow9);
   PPGenNorm ppgen10 (Y, one10, two10, neg10, pprow10);
   PPGenNorm ppgen11 (Y, one11, two11, neg11, pprow11);
   PPGenNorm ppgen12 (Y, one12, two12, neg12, pprow12);
   PPGenNorm ppgen13 (Y, one13, two13, neg13, pprow13);
   PPGenPenult ppgen14 (Y, one14, two14, neg14, pprow14);
   PPGenLast ppgen15 (Y, posone15, negone15, postwo15, negtwo15, pprow15);

endmodule // BoothMult

module adder_fast (A, B, Cin, S);

   input [31:0]  A, B;
   input         Cin;
   output [31:0] S;

   assign S = A + B;
   
endmodule // adder_fast

module csa (A, B, C, S, Cout);

   input  A, B, C;
   output S, Cout;
   
   assign S = A ^ B ^ C;
   assign Cout = (A & B) | (A & C) | (B & C);

endmodule // csa

module csa32 (A, B, C, S, Cout);

   input [31:0]  A, B, C;
   output [31:0] S, Cout;
   
   assign S = A ^ B ^ C;
   assign Cout = (A & B) | (A & C) | (B & C);

endmodule // csa32
