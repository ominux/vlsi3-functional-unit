//`timescale 1ns / 10 ps
`include "adder_struct.v"

module Alu( Z, A, B, INST, FLAGS, FirstCyc, CLOCK);
	input [31:0] A;
	input [31:0] B;
	input [3:0] INST;
	input FirstCyc;
	input CLOCK;

	output reg [31:0] Z;
	output [3:0] FLAGS;

	//data
	wire [31:0] adder_out;
	wire adder_co;
	wire [31:0] ain, bin;
	wire cin;
	wire not_A_adder, not_B_adder; 
	wire not_A_logic, not_B_logic;

	wire [31:0] and_AB, or_AB, xor_AB;
	
	//controls
	reg control_add_c;
	reg [1:0] control_add_a;
	reg [1:0] control_add_b;
	wire skip_adder;

	//input gating
	wire gated_clock_adder, gated_clock_logic;
	reg [31:0] adder_reg_A, adder_reg_B, adder_reg_C;
	reg [31:0] logic_reg_A, logic_reg_B;

	wire Cout, OVF;

	// Instructions supported by this ALU
	localparam [3:0]	add_1 = 4'b0000, sub_1 = 4'b0001, add_ab=4'b0010, sub_ab = 4'b0011,
										abs_a = 4'b0100, neg_a = 4'b0101, neg_b =4'b0111, and_ab = 4'b1000,
										or_ab = 4'b1001, xor_ab = 4'b1010, not_b =4'b1011, i_a = 4'b1100,
										not_a = 4'b1101, i_0 = 4'b1110, i_1 = 4'b1111;
	
	assign skip_adder = ~(INST==add_1 | INST==sub_1 | INST==add_ab | INST==sub_ab | INST==abs_a | INST==neg_a);

	assign gated_clock_adder = (CLOCK & ~skip_adder);
	assign gated_clock_logic = (CLOCK & skip_adder);
	
	//input gating registers
	always @(posedge gated_clock_adder)
	begin
		adder_reg_A = A;
		adder_reg_B = B;
		adder_reg_C = cin;	
	end

	always @(posedge gated_clock_logic)
	begin
		logic_reg_A = A;
		logic_reg_B = B;	
	end
	
	always @(INST)
	begin
		control_add_c = 1'b0;
		control_add_a = 2'b00;
		control_add_b = 2'b00;

		Z = adder_out;

		case(INST)
			//input gating block 1 (adder)
			add_1:begin control_add_c = 1'b1; end
			sub_1:begin control_add_b = 2'b10; end
			add_ab:begin control_add_b = 2'b11; end
			sub_ab:begin control_add_b = 2'b01; control_add_c = 1'b1; end
			abs_a:begin control_add_a = 2'b10; control_add_c = adder_reg_A[31]; end
			neg_a:begin control_add_a = 2'b01; control_add_c = 1'b1; end
			
			//input gating block 2 (logic)
			and_ab:begin Z = and_AB; end
			or_ab:begin Z = or_AB; end
			xor_ab:begin Z = xor_AB; end
			not_b:begin Z = not_B_logic; end
			i_a:begin Z = logic_reg_A; end
			not_a:begin Z = not_A_logic; end
			i_0:begin Z = 32'b0; end
			i_1:begin Z = 32'hFFFF; end
		endcase
	end

	assign not_B_adder = ~adder_reg_B;
	assign not_A_adder = ~adder_reg_A;
	
	assign not_A_logic = ~logic_reg_A;
	assign not_B_logic = ~logic_reg_B;

	assign cin = (control_add_c | adder_reg_C); 

	assign bin = (control_add_b == 2'b00) ? 32'h0 :	//A+0
			(control_add_b == 2'b10)? 32'hFFFF : //A-1
			(control_add_b == 2'b11)? adder_reg_B :	   //A+B
			not_B_adder;	   //A-B
	
	assign ain = (control_add_a == 2'b00)? adder_reg_A :  //A
			(control_add_a == 2'b01)? not_A_adder : //-A
			( (adder_reg_A[31])? not_A_adder : adder_reg_A); //abs(A)
		
	// get XOR and AND for free if Cin=0
	adder a1(.A(ain),.B(bin),.Cin(cin), .S(adder_out),.P(xor_AB),.G(and_AB), .Cout(Cout), .OVF(OVF));
	
	assign FLAGS[1] = Cout;
	assign FLAGS[2] = OVF;
	//logic functions
	//assign and_AB = logic_reg_A & logic_reg_B;
	assign or_AB = logic_reg_A | logic_reg_B;
	//assign xor_AB = logic_reg_A ^ logic_reg_B;

endmodule
