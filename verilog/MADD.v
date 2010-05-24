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
   output reg [31:0] Z;

   wire [35:0]   pprow0, pprow14;
   wire [34:0]   pprow1, pprow2, pprow3, pprow4, pprow5, pprow6, pprow7,
                 pprow8, pprow9, pprow10, pprow11, pprow12, pprow13;
   wire [33:0]   pprow15;

   // Totally behavioral way of doing things, about 2ns too slow
   //assign Z = (A * B) + C;

   // Get partial product rows
   
	 BoothMult bmul (A, B, pprow0, pprow1, pprow2, pprow3, pprow4, pprow5,pprow6,
                   pprow7, pprow8, pprow9, pprow10, pprow11, pprow12, pprow13,
                   pprow14, pprow15);

   // Add everything up, to produce 32 bit output
   // TODO Replace with compressors and stuff, could be a for loop too
   reg [35:0] pprow0_qual, pprow14_qual;
   reg [34:0] pprow1_qual, pprow2_qual, pprow3_qual, pprow4_qual, pprow5_qual, pprow6_qual, pprow7_qual,
                 pprow8_qual, pprow9_qual, pprow10_qual, pprow11_qual, pprow12_qual, pprow13_qual;
   reg [33:0] pprow15_qual;
	 
	 always @ (posedge CLK) begin
		pprow0_qual <= pprow0;
		pprow1_qual <= pprow1;
		pprow2_qual <= pprow2;
		pprow3_qual <= pprow3;
		pprow4_qual <= pprow4;
		pprow5_qual <= pprow5;
		pprow6_qual <= pprow6;
		pprow7_qual <= pprow7;
		pprow8_qual <= pprow8;
		pprow9_qual <= pprow9;
		pprow10_qual <= pprow10;
		pprow11_qual <= pprow11;
		pprow12_qual <= pprow12;
		pprow13_qual <= pprow13;
		pprow14_qual <= pprow14;
		pprow15_qual <= pprow15;
	 end
	 
	 //always @(posedge CLK) begin
   always @ (*) begin
			Z = C + pprow0_qual[31:0] + {pprow1_qual[29:0], 1'b0, A[1]} +
          {pprow1_qual[27:0], 1'b0, A[3], 2'b0} +
          {pprow2_qual[25:0], 1'b0, A[5], 4'b0} +
          {pprow3_qual[23:0], 1'b0, A[7], 6'b0} +
          {pprow4_qual[21:0], 1'b0, A[9], 8'b0} +
          {pprow5_qual[19:0], 1'b0, A[11], 10'b0} +
          {pprow6_qual[17:0], 1'b0, A[13], 12'b0} +
          {pprow7_qual[15:0], 1'b0, A[15], 14'b0} +
          {pprow8_qual[13:0], 1'b0, A[17], 16'b0} +
          {pprow9_qual[11:0], 1'b0, A[19], 18'b0} +
          {pprow10_qual[9:0], 1'b0, A[21], 20'b0} +
          {pprow11_qual[7:0], 1'b0, A[23], 22'b0} +
          {pprow12_qual[5:0], 1'b0, A[25], 24'b0} +
          {pprow13_qual[3:0], 1'b0, A[27], 26'b0} +
          {pprow14_qual[1:0], 1'b0, A[29], 28'b0} +
          {1'b0, A[31], 30'b0};
   end
	 
endmodule // MADD

// Generates 2's comp of A, using or -> xor tree
// TODO replace with NOR, INV, NAND version?
module Fast2sComp (A, Z);

   input [31:0]  A;
   output [31:0] Z;

   wire [31:0]   wOrRes;

	 assign wOrRes[0] = 1'b0; // Low bit has nothing to or with
   // Rest of bits just build an or tree, so every bit is ored with all lower
   // TODO If synth tool is dumb, I might have to make a tree here by hand
	 assign wOrRes[1] = ~(|A[1:0]);
   assign wOrRes[2] = ~(|A[2:0]);
   assign wOrRes[3] = ~(|A[3:0]);
   assign wOrRes[4] = ~(|A[4:0]);
   assign wOrRes[5] = ~(|A[5:0]);
   assign wOrRes[6] = ~(|A[6:0]);
   assign wOrRes[7] = ~(|A[7:0]);
   assign wOrRes[8] = ~(|A[8:0]);
   assign wOrRes[9] = ~(|A[9:0]);
   assign wOrRes[10] = ~(|A[10:0]);
   assign wOrRes[11] = ~(|A[11:0]);
   assign wOrRes[12] = ~(|A[12:0]);
   assign wOrRes[13] = ~(|A[13:0]);
   assign wOrRes[14] = ~(|A[14:0]);
   assign wOrRes[15] = ~(|A[15:0]);
   assign wOrRes[16] = ~(|A[16:0]);
   assign wOrRes[17] = ~(|A[17:0]);
   assign wOrRes[18] = ~(|A[18:0]);
   assign wOrRes[19] = ~(|A[19:0]);
   assign wOrRes[20] = ~(|A[20:0]);
   assign wOrRes[21] = ~(|A[21:0]);
   assign wOrRes[22] = ~(|A[22:0]);
   assign wOrRes[23] = ~(|A[23:0]);
   assign wOrRes[24] = ~(|A[24:0]);
   assign wOrRes[25] = ~(|A[25:0]);
   assign wOrRes[26] = ~(|A[26:0]);
   assign wOrRes[27] = ~(|A[27:0]);
   assign wOrRes[28] = ~(|A[28:0]);
   assign wOrRes[29] = ~(|A[29:0]);
   assign wOrRes[30] = ~(|A[30:0]);
   assign wOrRes[31] = ~(|A[31:0]);
   
   // Final stage, just xor to get result
   assign Z = A ^ wOrRes;

endmodule // Fast2sComp

// Modified booth encoder, this isn't really required
module ModBoothEnc (X, one, two, neg);

   input [2:0] X;
   output      one, two, neg;

   assign one = X[0] ^ X[1];
   assign two = ~(one | ~(X[1] ^ X[2]));
   assign neg = X[2];
   
endmodule // ModBoothEnc

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
module PPGenLast (Y, one, two, neg, pp);
   
   input [31:0]  Y;
   input         one, two, neg;
   output [33:0] pp;

   wire [32:0]   plustwo, plusone, minustwo, minusone;
   wire [31:0]   twoscomp;

   Fast2sComp twoscomper (Y, twoscomp);

   // Mux the possible combinations
   assign plustwo = (two & ~neg) ? {Y, 1'b0} : 32'b0;
   assign plusone = (one & ~neg) ? {Y[31], Y} : 32'b0;
   assign minustwo = (two & neg) ? {twoscomp, 1'b0} : 32'b0;
   assign minusone = (one & neg) ? {twoscomp[31], twoscomp} : 32'b0;

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
   wire					 one15, two15, neg15;

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
   ModBoothEnc enc15 (X[31:29], one15, two15, neg15);

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
   PPGenLast ppgen15 (Y, one15, two15, neg15, pprow15);

endmodule // BoothMult
