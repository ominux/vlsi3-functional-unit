/*

File:		ALU for the Functional Unit of the Mosaic project.  The
				main block of this ALU is the adder (adder_struct.v).  This ALU cotains
				latches to hold the inputs to the adder constant for instructions that 
				do not require use of the adder.

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
module Alu( Z, A, B, INST, SEL, EN );
	
	////////
	// IO //
	////////
	output	[31:0]	Z;			// output data
	input		[31:0]	A;			// First Input Data, subtract is A-B
	input		[31:0]	B;			// Second Input Data, this is added to or subtracted from A
	input		[3:0]		INST;		// Instructions are defined in the localparam sectionnnnn
	input						SEL;		// Select bit for select operations
        input                                           EN; // Enable to latches
   
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
	reg		[31:0] adder_a, adder_b;
	wire	[31:0] adder_out;
	reg adder_cin;
        reg [31:0] A_latch, B_latch;
        reg        SEL_latch;
   
	
        // Latch inputs (A, B, SEL)
        always @ (*)
          if (EN == 1'b1) begin
             A_latch = A;
             B_latch = B;
             SEL_latch = SEL;
          end

	/////////////////////////
	// Set up Adder inputs //
	/////////////////////////
	always @ (*) begin
		
		case (INST)
			add_ab: begin
				adder_a = A_latch;
				adder_b = B_latch;
				adder_cin = 1'b0;
			end
			neg_a: begin
				adder_a = ~A_latch;
				adder_b = 0;
				adder_cin = 1'b1;
			end
			//and_ab:// don't use adder
			//or_ab: begin // don't use adder
			//xor_ab:// don't use adder 
			//inv_a: // don't use adder
			//sel_ab: begin // don't use adder
			//sel_ba: begin // don't use adder
			sub_ab: begin
				adder_a = A_latch;
				adder_b = ~B_latch;
				adder_cin = 1'b1;
			end
			a_lt_b: begin
				adder_a = A_latch;
				adder_b = ~B_latch;
				adder_cin = 1'b1;
			end
			a_lte_b: begin
				adder_a = A_latch;
				adder_b = ~B_latch;
				adder_cin = 1'b1;
			end
			a_gt_b: begin
				adder_a = A_latch;
				adder_b = ~B_latch;
				adder_cin = 1'b1;
			end
			a_gte_b: begin
				adder_a = A_latch;
				adder_b = ~B_latch;
				adder_cin = 1'b1;
			end
			a_eq_b: begin
				adder_a = A_latch;
				adder_b = ~B_latch;
				adder_cin = 1'b1;
			end
			a_ne_b: begin
				adder_a = A_latch;
				adder_b = ~B_latch;
				adder_cin = 1'b1;
			end
			//sel_xor_b: // don't use adder
			default: begin
				// default latch inputs to adder
				adder_a = adder_a;
				adder_b = adder_b;
				adder_cin = adder_cin;
			end
		endcase
	end
		
	///////////
	// Adder //
	///////////
	adder struct_adder (.A(adder_a),.B(adder_b),.Cin(adder_cin),.S(adder_out),
											.OVF(overflow));
	assign zero = ~(|adder_out);

	////////////////
	// Output MUX //
	////////////////
	always @ (*) begin
		case (INST)
			// add_ab: 
			// neg_a: 
			and_ab: Z = A_latch & B_latch;
			or_ab: Z = A_latch | B_latch; 
			xor_ab: Z = A_latch ^ B_latch;
			inv_a: Z = ~A_latch;
			sel_ab:	
				if (~SEL_latch) Z = A_latch;
				else Z = B_latch;
			sel_ba: 
				if (SEL_latch) Z = A_latch;
				else Z = B_latch;
			// sub_ab: 
			a_lt_b: Z = {31'b0,adder_out[31]^overflow};
			a_lte_b: Z = {31'b0,(adder_out[31]^overflow)|zero};
			a_gt_b: Z = {31'b0,~adder_out[31]^overflow};
			a_gte_b: Z = {31'b0,(~adder_out[31]^overflow)|zero};
			a_eq_b: Z = {31'b0,zero};
			a_ne_b: Z = {31'b0,~zero};
			sel_xor_b: Z = {31'b0,SEL_latch^B_latch};			
			default:	Z = adder_out;
		endcase
	end
endmodule
