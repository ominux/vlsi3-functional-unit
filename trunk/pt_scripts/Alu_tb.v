`timescale 1ns/10ps

`include "Alu.v"

/*
 Testbench for the ALU module
*/
module Alu_tb();

	// Inputs to the ALU
	reg [31:0]	a_in,b_in,div_in;
	reg [3:0]	instr;
	reg			carry_in,first_cycle;
	
	// Outputs from the ALU to check
	wire [31:0]	alu_out,div_out;
	wire [3:0]	flags;

	Alu ALU_inst (.A(a_in),.B(b_in),.DI(div_in),.INST(instr),.CI(carry_in),
					.FirstCyc(first_cycle),.Z(alu_out),.DO(div_out),.FLAGS(flags));

	// wrap the div_out back to div_in
	always @ (div_out) div_in = div_out;

    
	/* Flag definitions
	FLAGS[0]= OVF (output has incorrect sign, two's complement overflow)
    FLAGS[1]= Carry (adder carry output, unsigned overflow)
    FLAGS[2]= Zero (Z is zero)
    FLAGS[3]= reserved
	*/

	/* Instruction definitions
    0 : Z=A+1   
    1 : Z=A-1
    2 : Z=A+B   
    3 : Z=A-B
    4 : Z=abs(A)
    5 : Z=-A
    6 : Z= (A[msb]==B[msb] ? (B-A) : B+A)<<1 (division iteration)
    7 : Z=-B
    8 : Z=A&B
    9 : Z=A|B
    10: Z=A^B
    11: Z=~B
    12: Z=A
    13: Z=~A
    14: Z=0
    15: Z=1
	*/


	// apply test vectors here
	initial begin
		$monitor("Instruction=%h,A=%h,B=%h,Output=%h,Flags=%h\n",instr,a_in,b_in,alu_out,flags);
		
		///////////
		// A + B //
		///////////
		instr = 4'h2;
		carry_in = 1'b0;
		first_cycle = 1'b0;
		
		// 0x0000_0001 + 0x0000_0001 = 0x0000_0002
		a_in = 32'h00000001;
		b_in = 32'h00000001;

		// wait for the outputs to settle
		#100;
		$display("Output of ALU is %h, flags are %h\n",alu_out,flags);
		$stop;
		
	end

endmodule
