`timescale 100ps/10ps

/*
 File:		Testbench for the MADD module
	
 Author:	Corey Olson

 Date:		5/20/2010
 
*/

// Files to include for simulation

`include "MADD.v"
//`include "../synthesis/MADD.vh"
//`include "../synthesis/cp65npksdst.mv"

module MADD_tb();

	// Inputs to the MADD
	reg signed [31:0]	a_in,b_in, c_in;
	reg clk;
	
	// Outputs from the MADD to check
	wire [31:0]	madd_out;

	// signals for the testbench
	reg signed [31:0] a_qual, b_qual, c_qual, exp_output;
	
	// Instantiate the MADD which is the device under test
	MADD MADD_inst (.A(a_in),.B(b_in),.C(c_in),
								.Z(madd_out),.CLK(clk));

	// apply test vectors here
	initial begin
		$monitor("Multiplying A=%h, B=%h, and Adding C=%h, Output=%h",a_qual,b_qual,c_qual,madd_out);
		
		// initialize important signals
		clk = 0;
		a_in = 32'b0;
		b_in = 32'b0;
		c_in = 32'b0;
		a_qual = 32'b0;
		b_qual = 32'b0;
		c_qual = 32'b0;
		
		// wait 32 clock cycles
		repeat (32) @ (posedge clk);
		$stop;
	end

	// generate the clock
	always #7 clk <= ~clk;

	// inputs to the MADD are latched inside the MADD
	always @ (posedge clk) begin
		a_qual <= a_in;
		b_qual <= b_in;
		c_qual <= c_in;
	end

	// test all input instructions with random data
	always @ (posedge clk) begin
		a_in <= $random;
		b_in <= $random;
		c_in <= $random;
	end

	// Specify what the correct outputs should be
	always @ (*) begin
		exp_output = (a_qual * b_qual) + c_qual;
	end

	// check for correct output of the MADD
	always @ (posedge clk) begin
		if (madd_out !== exp_output) begin
			$display("Output of MADD doesn't match the expected value");
			$display("Output:%h, Expected:%h, A:%h, B:%h, C:%h",
							madd_out,exp_output,a_qual,b_qual,c_qual);
			$stop;
		end
	end
endmodule
