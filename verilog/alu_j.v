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
	reg [31:0] ain, bin;
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

	reg [3:0] adder_inst;

	wire Cout, OVF;

	reg abs_sig;

	// Instructions supported by this ALU
	localparam [3:0]	add_1 = 4'b0000, sub_1 = 4'b0001, add_ab=4'b0010, sub_ab = 4'b0011,
										abs_a = 4'b0100, neg_a = 4'b0101, neg_b =4'b0111, and_ab = 4'b1000,
										or_ab = 4'b1001, xor_ab = 4'b1010, not_b =4'b1011, i_a = 4'b1100,
										not_a = 4'b1101, i_0 = 4'b1110, i_1 = 4'b1111;
	
	assign skip_adder = (adder_inst[3]);

	assign gated_clock_adder = (CLOCK & ~skip_adder);
	assign gated_clock_logic = (CLOCK & skip_adder);

	//input gating registers
	always @(posedge CLOCK)
		adder_inst = INST;		

	always @(posedge gated_clock_adder)
	begin
		adder_reg_A = A;
		adder_reg_B = B;	
	end

	always @(posedge gated_clock_logic)
	begin
		logic_reg_A = A;
		logic_reg_B = B;	
	end
	
	initial begin
		adder_reg_A = 32'h0;
		adder_reg_B = 32'h0;
		adder_inst = 4'b0010;
		adder_reg_C = 1'b0;
		
	end


	always @(*)
	begin
		ain = adder_reg_A;
		bin = 32'b0;
		control_add_c = 1'b0;
		abs_sig = 1'b0;

		Z = adder_out;

		case(adder_inst)
			//input gating block 1 (adder)
			add_1:begin  control_add_c = 1'b1; end
			sub_1:begin  bin = 32'hFFFF_FFFF; end
			add_ab:begin  bin = adder_reg_B; end
			sub_ab:begin  bin = ~adder_reg_B; control_add_c = 1'b1; end
			abs_a:begin  if(adder_reg_A[31]) begin ain = ~adder_reg_A; control_add_c = 1'b1; end end
			neg_a:begin  ain = ~adder_reg_A; control_add_c = 1'b1; end
			neg_b:begin ain = 32'b0; bin = ~adder_reg_B; control_add_c = 1'b1; end
			//input gating block 2 (logic)
			and_ab:begin Z = and_AB; end
			or_ab:begin Z = or_AB; end
			xor_ab:begin Z = xor_AB; end
			not_b:begin Z = ~logic_reg_B; end
			i_a:begin Z = logic_reg_A; end
			not_a:begin Z = ~logic_reg_A; end
			i_0:begin Z = 32'b0; end
			i_1:begin Z = 32'hFFFFFFFF; end
		endcase

	end
	
	assign cin = (control_add_c); 

	adder a1(.A(ain),.B(bin),.Cin(cin), .S(adder_out), .Cout(Cout), .OVF(OVF));
	
	assign FLAGS[1] = Cout;
	assign FLAGS[0] = OVF;
	assign FLAGS[2] =~(|Z);
	
	//logic functions
	assign and_AB = logic_reg_A & logic_reg_B;
	assign or_AB = logic_reg_A | logic_reg_B;
	assign xor_AB = logic_reg_A ^ logic_reg_B;

endmodule
