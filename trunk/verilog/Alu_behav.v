/*

File: Behavioral module of ALU for the Functional Unit of Mosaic 2.0.
Author: Nathaniel McVicar
Date: 6/17/2010

*/

module Alu( Z, A, B, INST, FLAGS);
	
   ////////
   // IO //
   ////////
   input [31:0]	 A; // First Input Data, subtract is A-B
   input [31:0]  B; // Second Input Data, this is added to or subtracted from A
   input [3:0]   INST; // Instructions are defined in the localparam section
   output reg [31:0] Z; // output data
   output [3:0]  FLAGS;	// Flags = {reserved,Zero,CarryOut,Overflow}

   localparam [3:0] INCA=4'h0, DECA=4'h1, ADD=4'h2, SUB=4'h3;
   localparam [3:0] ABS=4'h4, NEGA=4'h5, NEGB=4'h7, AND=4'h8;
   localparam [3:0] OR=4'h9, XOR=4'hA, INVB=4'hB, PASSA=4'hC;
   localparam [3:0] INVA=4'hD, ZEROES=4'hE, ONES=4'hF;
   // Check for correct outputs and flags from the ALU here
   always @ (*) begin
      case (INST)
	INCA:	 Z = A + 1'b1;
	DECA:	 Z = A - 1'b1;
	ADD:	 Z = A + B;
	SUB:	 Z = A - B;
	ABS:	 if (A[31]) Z = ~A + 1'b1;
	         else Z = A;
	NEGA:	 Z = ~A + 1'b1;
	NEGB:	 Z = ~B + 1'b1;
	AND:	 Z = A & B;
	OR:	 Z = A | B;
	XOR:	 Z = A ^ B;
	INVB:    Z = ~B;
	PASSA:	 Z = A;
	INVA:	 Z = ~A;
	ZEROES:	 Z = 32'b0;
	ONES:	 Z = 32'hFFFFFFFF;
	default: Z = 32'bx;
      endcase
   end

   assign FLAGS = Z == 32'b0 ? 4'b0100 : 4'b0000;

endmodule // Alu
