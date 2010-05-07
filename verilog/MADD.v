/*
 Top level Multiple Add unit for Mosiac 2 functional unit

 Author: Nathaniel McVicar
 Date: 5/06/2010
*/

module MADD (A, B, C, Z);

   input [31:0] A;
   input [31:0] B;
   input [31:0] C;
   output [31:0] Z;

   assign Z = (A * B) + C;

endmodule // MADD
