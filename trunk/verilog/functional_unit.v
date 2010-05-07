/*
 Top level module for the functional unit of Mosaic

 Author: Corey Olson
 Date: 4/29/2010
*/

`timescale 1ns / 10 ps

module functional_unit(Z, FLAGS, A, B, C, INST, CI);
	
	////////
	// IO //
	////////
	output [31:0] Z;
	output [3:0] FLAGS;
	input [31:0] A, B, C;
	input [4:0] INST;
	input CI;
	
        wire [31:0] Alu_Z, MADD_Z;

	// alu
	Alu alu_inst (.A(A),
                      .B(B),
                      .DI(),
                      .INST(INST[3:0]),
                      .CI(CI),
                      .FirstCyc(),
                      .Z(Alu_Z),
                      .DO(),
                      .FLAGS());
		
	// barrel shifter
	

	// MADD unit
        MADD madd (.A(A), .B(B), .C(C), .Z(MADD_Z));

        // Output mux
        assign Z = INST[4] ? MADD_Z : Alu_Z;

endmodule
