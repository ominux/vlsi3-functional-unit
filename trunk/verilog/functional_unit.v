/*
 Top level module for the functional unit of Mosaic

 Author: Corey Olson
 Date: 4/29/2010
*/

`timescale 1ns / 10 ps

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
	
	wire [31:0] Z1;
        wire [31:0] Alu_Z, MADD_Z, BS_Z;
	wire Gated_clock_ALU, Gated_clock_BS, Gated_clock_MADD;
	reg [31:0] Alu_Z1, MADD_Z1, BS_Z1;

	and alu_gate(Gated_clock_ALU, CLOCK, INST[4]);
	and bs_gate(Gated_clock_BS, CLOCK, INST[3]);
	and madd_gate(Gated_clock_MADD, CLOCK, INST[2]);

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
	ShiftLR shifter( .Z(BS_Z), .X(A), .S(B[4:0]), .LOG(B[6]) );

	// MADD unit
        MADD madd (.CLK(Gated_clock_MADD), .A(A), .B(B), .C(C), .Z(MADD_Z));

	// CLOCK GATING
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

        // Output mux
	assign Z = INST[3] ? (INST[4] ? MADD_Z : Alu_Z1) : BS_Z1;

endmodule
