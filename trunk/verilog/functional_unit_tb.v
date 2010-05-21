
/*
 Testbench for the functional verification of the 
 functional unit top level using VCS simulator

 Author: Corey Olson
 
 Date: 5/16/2010
*/

`timescale 100ps / 10ps

/* Verilog Version */
`include "functional_unit.v"
`include "Alu.v"
`include "ShiftLR.v"
`include "MADD.v"

/* Synthesized Version
`include "functional_unit.vh"
`include "Alu.vh"
`include "ShiftLR.vh"
`include "MADD.vh"
*/
module functional_unit_tb();

	// inputs to the FU
	reg [31:0] a,b,c;
	reg [4:0] instruction;
	reg clock;
	reg carry_in;
	
	// outputs from the FU
	wire [31:0] output_data;
	wire [3:0]	flags;

	// these are signals that are "qualified" with a clock
	// which basically means they are the output of a register
	reg [31:0] a_qual, b_qual, c_qual;
	reg [4:0] instr_qual;
	reg carry_qual;

	// these are used to verify that the output data and flags are correct
	reg [31:0] expected_output;
	reg [3:0] expected_flags;

	// Device Under Test
	functional_unit	DUT	(.Z(output_data), .FLAGS(flags), 
											.A(a), .B(b), 
											.C(c), .INST(instruction), 
											.CI(carry_in), .CLOCK(clock));

	// create the clock
	always #7 clock <= ~clock;
	
	// instructions
	localparam [5:0] 
								// Arithmetic
								OP_ADD=6'b10,
								OP_SUB=6'b10,
								OP_MUL=6'b00,
								OP_MADD=6'b00,
								OP_SHR=6'b01,
								OP_SHL=6'b01,
								OP_ASHR=6'b01,
								OP_NEGA=6'b10,
								// Comparison
								OP_LT=6'b10,
								OP_LTE=6'b10,
								OP_GT=6'b10,
								OP_GTE=6'b10,
								OP_EQ=6'b10,
								OP_NEQ=6'b10,
								//OP_SELECT=6'b10,
								// Bitwise
								OP_NOTA=6'b10,
								OP_AND=6'b10,
								OP_OR=6'b10,
								OP_XOR=6'b10,
								// Compare with 0
								OP_A_EQ_0=6'b10,
								OP_A_NEQ_0=6'b10,
								OP_A_GT_0=6'b10,
								OP_A_GTE_0=6'b10,
								OP_A_LTE_0=6'b10,
								OP_A_LT_0=6'b10,
								// Compare with 1
								OP_A_EQ_1=6'b10,
								OP_A_NEQ_1=6'b10,
								OP_A_GT_1=6'b10,
								OP_A_GTE_1=6'b10,
								OP_A_LTE_1=6'b10,
								OP_A_LT_1=6'b10,
								// ALU with Immediate B
								OP_INC_A=6'b10,
								OP_DEC_A=6'b10,
								OP_ASHR_1=6'b01,
								OP_ASHR_2=6'b01,
								OP_ASHR_4=6'b01,
								OP_ASHR_16=6'b01,
								// Select with Immediate
								OP_SELECT_A_OR_0=6'b,
								OP_SELECT_A_OR_1=6'b,
								OP_SELECT_0_OR_B=6'b,
								OP_SELECT_1_OR_B=6'b,
								OP_SELECT_0_OR_1=6'b,
								OP_SELECT_1_OR_0=6'b,
								// LUT operations
								OP_LAND_LOR=6'b,
								OP_LOR_LAND=6'b,
								OP_3LOR=6'b,
								OP_3LAND=6'b,
								OP_LNOTA=6'b,
								OP_LOR=6'b,
								OP_LAND=6'b;
	
	// test all instructions with random data
	always @ (posedge clock) begin
		instruction <= instruction + 1'b1;
		a <= $random;
		b <= $random;
		c <= $random;
		carry_in <= $random;
	end
	
	// need to latch the inputs, because output is 1 clock cycle
	// delayed from the inputs
	always @ (posedge clock) begin
		a_qual <= a;
		b_qual <= b;
		c_qual <= c;
		instr_qual <= instruction;
		carry_qual <= carry_in;
	end
	
	// calculate the expected data and expected flags,
	// based on the input data and instruction
	always @ (posedge clock) begin
		$display("Verifying Instruction = %h",instr_qual);

	end

	// Verify the output data and flags
	always @ (posedge clock) begin
		if (output_data !== expected_output) begin
			$display("Output data does not match the expected value");
			$display("Data:%h, Exp:%h, Instruction:%h, A:%h, B:%h, C:%h",
								output_data,expected_output,instr_qual,a_qual,b_qual,c_qual);
			$stop;
		end
		else if (expected_flags !== flags) begin
			$display("Flags do not match the expected value");
			$display("Flags:%h, Exp:%h, Instruction:%h, A:%h, B:%h, C:%h",
								flags,expected_flags,instr_qual,a_qual,b_qual,c_qual);
			$stop;
		end
	end
	
	// input initialization
	initial begin
		clock = 0;
		a = 0;
		b = 0;
		c = 0;
		instruction = 0;
		expected_flags = 0;
		expected_output = 0;
		
		// run for 64 instructions
		#896 $stop;
	end

endmodule
