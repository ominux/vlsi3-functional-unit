`timescale 100ps/10ps

/*
 Testbench for the ALU module
*/

// Files to include for simulation

`include "Alu.v"
//`include "../benchmark/alu_behavioral.v"
//`include "../synthesis/Alu.vh"
//`include "../synthesis/cp65npksdst.mv"

module Alu_tb();

	// Inputs to the ALU
	reg signed [31:0]	a_in,b_in;
	reg [3:0]	instr;
	reg select;
	reg clk;
	
	// Outputs from the ALU to check
	wire [31:0]	alu_out;

	// signals for the testbench
	reg signed [31:0] exp_output;
	
	// Instantiate the ALU which is the device under test
	Alu ALU_inst (.A(a_in),.B(b_in),.INST(instr),
								.Z(alu_out),.SEL(select));

	// apply test vectors here
	initial begin
		$monitor("Instruction=%h,A=%h,B=%h,Output=%h",instr,a_in,b_in,alu_out);
		
		// initialize important signals
		clk = 0;
		instr = 4'h0;
		a_in = $random;
		b_in = $random;
		select = $random;
		
		// wait 32 clock cycles
		repeat (1024) @ (posedge clk);
		$display("ALU test completed successfully!");
		$stop;
	end

	// generate the clock, want 1GHz clock
	always #5 clk <= ~clk;

	// test all input instructions with random data
	always @ (posedge clk) begin
		a_in <= $random;
		b_in <= $random;
		instr <= instr + 4'h1;
		select <= $random;
	end

	/* Instruction definitions
    0 : Z=A+B   
    1 : Z=-A
    2 : Z=A&B   
    3 : Z=A|B
    4 : Z=A^B
    5 : Z=~A
    6 : Z=(~SEL&A)|(SEL&B)
    7 : Z=(SEL&A)|(~SEL&B)
    8 : Z=A-B
    9 : Z={31'b0,A<B}
    10: Z={31'b0,A<=B}
    11: Z={31'b0,A>B}
    12: Z={31'b0,A>=B}
    13: Z={31'b0,A==B}
    14: Z={31'b0,A!=B}
    15: Z={31'b0,SEL^B}
	*/
	localparam [3:0]	ADD=4'h0, NEGA=4'h1, AND=4'h2, OR=4'h3,
										XOR=4'h4, INVA=4'h5, SELAB=4'h6, SELBA=4'h7,
										SUB=4'h8, ALTB=4'h9, ALTEB=4'hA, AGTB=4'hB,
										AGTEB=4'hC, AEQB=4'hD, ANEQB=4'hE, SELXORB=4'hF;

	// Check for correct outputs from the ALU here
	always @ (*) begin
		case (instr)
			ADD:		exp_output = a_in + b_in;
			NEGA:		exp_output = ~a_in + 1'b1;
			AND:		exp_output = a_in & b_in;
			OR:			exp_output = a_in | b_in;
			XOR:		exp_output = a_in ^ b_in;
			INVA:		exp_output = ~a_in;
			SELAB:		
				if (select) 
							exp_output = b_in;
				else	
							exp_output = a_in;
			SELBA:		
				if (select) 
							exp_output = a_in;
				else	
							exp_output = b_in;
			SUB:		exp_output = a_in - b_in;
			ALTB:		exp_output = {31'b0, a_in < b_in};
			ALTEB:	exp_output = {31'b0, a_in <= b_in};
			AGTB:		exp_output = {31'b0, a_in > b_in};
			AGTEB:	exp_output = {31'b0, a_in >= b_in};
			AEQB:		exp_output = {31'b0, a_in == b_in};
			ANEQB:	exp_output = {31'b0, a_in != b_in};
			SELXORB:exp_output = {31'b0, select ^ b_in}; 
			default:exp_output = 32'bx;
		endcase
	end

	always @ (posedge clk) begin
		// check for correct output
		if (alu_out !== exp_output) begin
			$display("Output of ALU doesn't match the expected value");
			$display("Output:%h, Expected:%h, A:%h, B:%h, INSTR:%h, SEL:%b",
							alu_out,exp_output,a_in,b_in,instr,select);
			/*$display("Propagates:%h,Generates:%h,GroupP:%h,GroupG:%h,GroupC:%h,CarryIns:%h",
							ALU_inst.struct_adder.P,ALU_inst.struct_adder.G,ALU_inst.struct_adder.group_P,
							ALU_inst.struct_adder.group_G,ALU_inst.struct_adder.group_Cin,ALU_inst.struct_adder.carrychain);
			$display("GroupG for cla_2:%b, Gin:%b, Pin:%b, output:%b",ALU_inst.struct_adder.group_G[2],
							ALU_inst.struct_adder.cla_2.Gin,ALU_inst.struct_adder.cla_2.Pin,
							ALU_inst.struct_adder.cla_2.G);*/
			$stop;
		end
	end
endmodule
