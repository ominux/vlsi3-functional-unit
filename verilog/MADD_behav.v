/*
 Top level Behavioral Multiple Add unit for Mosiac 2 functional unit

 Author: Nathaniel McVicar
 Date: 6/17/2010
*/

module MADD (CLK, A, B, C, Z);

   input         CLK;
   input [31:0]  A;
   input [31:0]  B;
   input [31:0]  C;
   output [31:0] Z;

   reg [31:0]    AtimesB;

   // Totally behavioral way of doing things, about 2ns too slow
   always @(posedge CLK)
     AtimesB <= (A * B);

   assign Z = AtimesB + C;

endmodule // MADD
