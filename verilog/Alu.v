/*

File:		ALU for the Functional Unit of the Mosaic project.  The
				main block of this ALU is the adder (adder_struct.v).  This block
				is purely combinational.

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
module Alu( Z, A, B, INST, SEL);
	
	////////
	// IO //
	////////
	output	[31:0]	Z;			// output data
	input		[31:0]	A;			// First Input Data, subtract is A-B
	input		[31:0]	B;			// Second Input Data, this is added to or subtracted from A
	input		[3:0]		INST;		// Instructions are defined in the localparam sectionnnnn
	input						SEL;		// Select bit for select operations

	////////////////////////////////////////
	// Instructions supported by this ALU //
	////////////////////////////////////////
	localparam [3:0]	add_ab		= 4'b0000,	
										neg_a			= 4'b0001,	
										and_ab		= 4'b0010, 
										or_ab			= 4'b0011,
										xor_ab		= 4'b0100,	
										inv_a			= 4'b0101, 
										sel_ab		= 4'b0110, 
										sel_ba		= 4'b0111, 
										sub_ab		= 4'b1000,	
										a_lt_b		= 4'b1001, 
										a_lte_b		= 4'b1010,	
										a_gt_b		= 4'b1011, 
										a_gte_b		= 4'b1100,
										a_eq_b		= 4'b1101,	
										a_ne_b		= 4'b1110, 
										sel_xor_b	= 4'b1111;
	
	////////////
	// Output //
	////////////
	reg [31:0] Z;
	
	////////////////////////
	// Intermediate Nodes //
	////////////////////////
	wire [31:0] adder_out, P, G, A_or_B;
	wire adder_co, overflow, zero;

	///////////////////////////
	// Modified Adder Inputs //
	///////////////////////////
	reg [31:0] ain, bin;
	reg cin;
	always @ (*) begin
		// defaults
		ain = A;
		bin = B;
		cin = 1'b0;
		
		case (INST)
			// Z = A + B
			add_ab:	begin
			end
			// Z = -1 * A
			neg_a: begin
				ain = ~A;
				bin = 32'b0;
				cin = 1'b1;
			end
			// Z = A & B
			and_ab: begin
			end
			// Z = A | B
			or_ab: begin
			end
			// Z = A ^ B
			xor_ab:	begin
			end
			// Z = ~A
			inv_a: begin
				ain = ~A;
				bin = 32'b0;
			end
			// Z = (~SEL & A) | (SEL & B)
			sel_ab: begin
				if (SEL) ain = 32'b0;
				else bin = 32'b0;
			end
			// Z = (SEL & A) | (~SEL & B)
			sel_ba: begin
				if (SEL) bin = 32'b0;
				else ain = 32'b0;
			end
			// Z = A - B
			sub_ab:	begin
				bin = ~B;
				cin = 1'b1;
			end
			// Z = {31'b0,A<B}
			a_lt_b: begin
				bin = ~B;
				cin = 1'b1;
			end
			// Z = {31'b0,A<=B}
			a_lte_b: begin
				bin = ~B;
				cin = 1'b1;
			end
			// Z = {31'b0,A>B}
			a_gt_b: begin
				bin = ~B;
				cin = 1'b1;
			end
			// Z = {31'b0,A>=B}
			a_gte_b: begin
				bin = ~B;
				cin = 1'b1;
			end
			// Z = {31'b0,A==B}
			a_eq_b: begin
				bin = ~B;
				cin = 1'b1;
			end
			// Z = {31'b0,A!=B}
			a_ne_b: begin
				bin = ~B;
				cin = 1'b1;
			end
			// Z = {31'b0,SEL^B}
			sel_xor_b: begin
				ain = {31'b0,SEL};
			end
			// let the synthesis tool optimize the other cases
			default: begin
			end
		endcase
	end
	
	///////////////////////////
	// Adder and Other Logic //
	///////////////////////////
	assign A_or_B = A | B;
	adder struct_adder (.A(ain),.B(bin),.Cin(cin),.S(adder_out),
											.P(P),.G(G),.Cout(adder_co),.OVF(overflow));
	
	////////////////
	// Output Mux //
	////////////////
	always @ (*) begin
		case (INST)
			and_ab: Z = G;
			or_ab: Z = A_or_B;
			xor_ab: Z = P;
			a_lt_b: Z = {31'b0,adder_out[31]^overflow};
			a_lte_b: Z = {31'b0,(adder_out[31]^overflow)|zero};
			a_gt_b: Z = {31'b0,~adder_out[31]^overflow};
			a_gte_b: Z = {31'b0,(~adder_out[31]^overflow)|zero};
			a_eq_b: Z = {31'b0,zero};
			a_ne_b: Z = {31'b0,~zero};
			sel_xor_b: Z = P;
			default: Z = adder_out;
		endcase
	end

	///////////
	// Flags //
	///////////
	assign zero = ~(|adder_out);

endmodule
