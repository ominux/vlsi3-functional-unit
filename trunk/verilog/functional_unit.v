/*
 Top level module for the functional unit of Mosaic

 Author: Jimmy Xu and Corey Olson
 
 Date: 5/16/2010
*/

// would like to remove CI from this level and have it
// exist only in the ALU
module functional_unit(Z, FLAGS, A, B, C, INST, CI, CLOCK);
	
	////////
	// IO //
	////////
	output [31:0] Z;
	output [3:0] FLAGS;
	input [31:0] A, B, C;
	input [4:0] INST;
	input CI;
	input CLOCK;
	
	//////////////////////
	// Internal Signals //
	//////////////////////
	//wire [31:0] Z1;
	wire [31:0] Alu_Z, MADD_Z, BS_Z;
	wire Gated_clock_ALU, Gated_clock_BS, Gated_clock_MADD;
	//reg [31:0] Alu_Z1, MADD_Z1, BS_Z1;
	
	//////////////////////////////
	// Enables for Clock Gating //
	//////////////////////////////
	reg en_clock_alu, en_clock_bs, en_clock_madd;
	
	// gate the clocks to the blocks if they are not needed
	always @ (negedge CLOCK) begin
		en_clock_alu <= INST[4];
		en_clock_bs <= INST[3];
		en_clock_madd <= INST[2];
	end
	/*
	and alu_gate(Gated_clock_ALU, CLOCK, INST[4]);
	and bs_gate(Gated_clock_BS, CLOCK, INST[3]);
	and madd_gate(Gated_clock_MADD, CLOCK, INST[2]);
	*/
	and alu_gate(Gated_clock_ALU, CLOCK, en_clock_alu);
	and bs_gate(Gated_clock_BS, CLOCK, en_clock_bs);
	and madd_gate(Gated_clock_MADD, CLOCK, en_clock_madd);

	/////////
	// ALU //
	/////////
	Alu alu_inst (.A(A),
                      .B(B),
                      .DI(),
                      .INST(INST[3:0]),
                      .CI(CI),
                      .FirstCyc(),
                      .Z(Alu_Z),
                      .DO(),
                      .FLAGS(FLAGS));
		
	////////////////////
	// Barrel Shifter //
	////////////////////
	ShiftLR shifter( .Z(BS_Z), .X(A), .S(B[4:0]), .LOG(B[6]) );

	//////////
	// MADD //
	//////////
  MADD madd (.CLK(Gated_clock_MADD), .A(A), .B(B), .C(C), .Z(MADD_Z));

	// CLOCK GATING
	/*	
	
	//Inputs should be gated by the clock, 
	//but this should happen inside each module
	
	always @(posedge Gated_clock_ALU)
	begin
		Alu_Z1 = Alu_Z;
	end


	always @(posedge Gated_clock_BS)
	begin
		BS_Z1 = BS_Z;
	end

	always @(posedge Gated_clock_MADD)
	begin
		MADD_Z1 = MADD_Z;
	end


	*/
	
	////////////////
	// Output Mux //
	////////////////
	// this needs to match the clock gating section, and
	// these may need to be one clock cycle old
	assign Z = INST[3] ? (INST[4] ? MADD_Z : Alu_Z) : BS_Z;

endmodule
