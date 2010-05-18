/*

File:		ALU for the Functional Unit of the Mosaic project.  The
				main block of this ALU is the adder (adder_struct.v)

Author: Corey Olson

Date:		5/16/2010

Notes:	
				Naming Conventions
					_qual = qualified signal (a.k.a. this signal has been clocked)
					_n = inverted version of the signal

				Extended precision operation is no longer supported for this ALU

				Division operation is not supported for this ALU

				CarryIn bit is no longer an input to this module

*/
`include "adder_struct.v"
module Alu( Z, A, B, INST, FLAGS, CLOCK);
	
	////////
	// IO //
	////////
	input		[31:0]	A;			// First Input Data, subtract is A-B
	input		[31:0]	B;			// Second Input Data, this is added to or subtracted from A
	input		[3:0]		INST;		// Instructions are defined in the localparam sectionnnnn
	input						CLOCK;	// obviously a clock
	output	[31:0]	Z;			// output data
	output	[3:0]		FLAGS;	// Flags = {reserved,Zero,CarryOut,Overflow}

	////////////////////////////////////////
	// Instructions supported by this ALU //
	////////////////////////////////////////
	localparam [3:0]	add_1 = 4'b0000, sub_1 = 4'b0001, add_ab=4'b0010, sub_ab = 4'b0011,
										abs_a = 4'b0100, neg_a = 4'b0101, neg_b =4'b0111, and_ab = 4'b1000,
										or_ab = 4'b1001, xor_ab = 4'b1010, not_b =4'b1011, i_a = 4'b1100,
										not_a = 4'b1101, i_0 = 4'b1110, i_1 = 4'b1111;
	
	//////////////////
	// Clock Gating //
	//////////////////
	reg [31:0] A_qual, B_qual, Z;
	reg [3:0] INST_qual;
	always @ (posedge CLOCK) begin
		A_qual <= A;
		B_qual <= B;
		INST_qual <= INST;
	end
	
	// trick for simulation, add 0 and 0
	initial begin
		A_qual = 0;
		B_qual = 0;
		INST_qual = 4'h2;
	end
	
	////////////////////////
	// Intermediate Nodes //
	////////////////////////
	wire [31:0] adder_out, P, G;
	wire or_AB, adder_co, overflow;

	///////////////////////////
	// Modified Adder Inputs //
	///////////////////////////
	reg [31:0] ain, bin;
	reg cin;
	always @ (*) begin
		case (INST_qual)
			// Z = A + 1
			add_1: begin
				ain = A_qual;
				bin = 32'b0;
				cin = 1'b1;
			end
			// Z = A - 1
			sub_1: begin
				ain = A_qual;
				bin = 32'hFFFFFFFF;
				cin = 1'b0;
			end
			// Z = A + B
			add_ab:	begin
				ain = A_qual;
				bin = B_qual;
				cin = 1'b0;
			end
			// Z = A - B
			sub_ab: begin
				ain = A_qual;
				bin = ~B_qual;
				cin = 1'b1;
			end
			// Z = abs(A)
			abs_a: begin
				if (A_qual[31]) ain = ~A_qual;
				else ain = A_qual;
				bin = 32'b0;
				cin = A_qual[31];
			end
			// Z = -1 * A
			neg_a: begin
				ain = A_qual;
				bin = 32'b0;
				cin = 1'b1;
			end
			// Z = -1 * B
			neg_b: begin
				ain = 32'b0;
				bin = ~B_qual;
				cin = 1'b1;
			end
			// Z = A & B
			and_ab: begin
				ain = A_qual;
				bin = B_qual;
				cin = 1'b0;
			end
			// Z = A ^ B
			xor_ab: begin
				ain = A_qual;
				bin = B_qual;
				cin = 1'b0;
			end
			// Z = ~B
			not_b: begin
				ain = 32'b0;
				bin = ~B_qual;
				cin = 1'b0;
			end
			// Z = A
			i_a: begin
				ain = A_qual;
				bin = 32'b0;
				cin = 1'b0;
			end
			// Z = ~A
			not_a: begin
				ain = ~A_qual;
				bin = 32'b0;
				cin = 1'b0;
			end
			// Z = 32'h0
			i_0: begin
				ain = 32'b0;
				bin = 32'b0;
				cin = 1'b0;
			end
			// Z = 32'hFFFFFFFF
			i_1: begin
				ain = 32'hFFFFFFFF;
				bin = 32'b0;
				cin = 1'b0;
			end
			// let the synthesis tool optimize the other cases
			default begin
				ain = 32'bx;
				bin = 32'bx;
				cin = 1'bx;
			end
		endcase
	end
	
	///////////////////////////
	// Adder and Other Logic //
	///////////////////////////
	assign or_AB = A_qual | B_qual;
	adder struct_adder (.A(ain),.B(bin),.Cin(cin),.S(adder_out),
											.P(P),.G(G),.Cout(adder_co),.OVF(overflow));
	
	////////////////
	// Output Mux //
	////////////////
	always @ (*) begin
		Z = adder_out;
		case (INST_qual)
			and_ab: Z = G;
			or_ab: Z = or_AB;
			xor_ab: Z = P;
		endcase
	end

	///////////
	// Flags //
	///////////
	assign FLAGS[3] = 1'b0;
	assign FLAGS[2] = (Z == 32'b0);
	assign FLAGS[1] = adder_co;
	assign FLAGS[0] = overflow;

endmodule
