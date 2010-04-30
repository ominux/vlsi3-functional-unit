/*
 Top level module for the functional unit of Mosaic

 Author: Corey Olson
 Date: 4/29/2010
*/
module functional_unit();
	
	////////
	// IO //
	////////
	output [31:0] Z;
	output [3:0] FLAGS;
	input [31:0] A, B;
	input [] INST;
	input CI;
	
	// alu
	Alu alu_inst (.A(),.B(),.DI(),.INST(),.CI(),.FirstCyc(),.Z(),.DO(),.FLAGS());
		
	// barrel shifter
	

		
	// MADD unit
	
		
endmodule
