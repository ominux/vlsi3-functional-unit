`timescale 100ps/10ps

`include "Alu_corey.v"

/*
 Testbench for the ALU module
*/
module Alu_tb();

	// Inputs to the ALU
	reg signed [31:0]	a_in,b_in;
	reg [3:0]	instr;
	reg clk;
	
	// Outputs from the ALU to check
	wire [31:0]	alu_out;
	wire [3:0]	flags;

	// signals for the testbench
	reg signed [31:0] a_qual, b_qual, exp_output;
	reg [3:0] instr_qual, exp_flags;
	
	// Instantiate the ALU which is the device under test
	Alu ALU_inst (.A(a_in),.B(b_in),.INST(instr),
								.Z(alu_out),.FLAGS(flags), .CLOCK(clk));

	// apply test vectors here
	initial begin
		$monitor("Instruction=%h,A=%h,B=%h,Output=%h,Flags=%b",instr_qual,a_qual,b_qual,alu_out,flags);
		
		// initialize important signals
		clk = 0;
		instr = 4'h0;
		a_in = 32'b0;
		b_in = 32'b0;
		a_qual = 32'b0;
		b_qual = 32'b0;
		instr_qual = 4'h2;
		
		// wait 32 clock cycles
		repeat (32) @ (posedge clk);
		$stop;
	end

	// generate the clock
	always #7 clk <= ~clk;

	// inputs to the ALU are latched inside the ALU
	always @ (posedge clk) begin
		a_qual <= a_in;
		b_qual <= b_in;
		instr_qual <= instr;
	end

	// test all input instructions with random data
	always @ (posedge clk) begin
		// instruction == 6 not supported right now
		if (instr == 4'h5) instr <= instr + 4'h2;
		else instr <= instr + 4'h1;
		a_in <= $random;
		b_in <= $random;
	end

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
    6 : not supported(old->Z= (A[msb]==B[msb] ? (B-A) : B+A)<<1 (division iteration))
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
	localparam [3:0]	INCA=4'h0, DECA=4'h1, ADD=4'h2, SUB=4'h3,
										ABS=4'h4, NEGA=4'h5, NEGB=4'h7, AND=4'h8,
										OR=4'h9, XOR=4'hA, INVB=4'hB, PASSA=4'hC,
										INVA=4'hD, ZEROES=4'hE, ONES=4'hF;
	// Check for correct outputs and flags from the ALU here
	always @ (*) begin
		case (instr_qual)
			INCA:		exp_output = a_qual + 1'b1;
			DECA:		exp_output = a_qual - 1'b1;
			ADD:		exp_output = a_qual + b_qual;
			SUB:		exp_output = a_qual - b_qual;
			ABS:		if (a_qual[31]) exp_output = ~a_qual + 1'b1;
							else exp_output = a_qual;
			NEGA:		exp_output = ~a_qual + 1'b1;
			NEGB:		exp_output = ~b_qual + 1'b1;
			AND:		exp_output = a_qual & b_qual;
			OR:			exp_output = a_qual | b_qual;
			XOR:		exp_output = a_qual ^ b_qual;
			INVB:		exp_output = ~b_qual;
			PASSA:	exp_output = a_qual;
			INVA:		exp_output = ~a_qual;
			ZEROES:	exp_output = 32'b0;
			ONES:		exp_output = 32'hFFFFFFFF;
		endcase
	end

	always @ (posedge clk) begin
		// check for correct output
		if (alu_out !== exp_output) begin
			if (instr_qual == 6) $display("Opcode=6 not supported!");
			else begin
				$display("Output of ALU doesn't match the expected value");
				$display("Output:%h, Expected:%h, A:%h, B:%h, INSTR:%h",
								alu_out,exp_output,a_qual,b_qual,instr_qual);
				$stop;
			end
		end
		// check for zero bit of flags
		else if (~(|alu_out) !==  flags[2]) begin
			$display("Zero detect flag bit incorrect");
			$display("Output:%h, Flags:%h",
								alu_out,flags);
			$stop;
		end
		/* assume the flag bits are correct
		// check for overflow bit of flags
		else if () begin

		end
		// check for carry bit of flags
		else if () begin

		end
		*/
	end
endmodule
