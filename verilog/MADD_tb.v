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
	
        reg firstclk;

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
                firstclk = 1'b1;

		// wait 32 clock cycles
		repeat (32) @ (posedge clk);
		$stop;
	end

	// generate the clock
	always #7 clk <= ~clk;

	// inputs to the MADD are latched inside the MADD
	always @* begin // (posedge clk) begin
		a_qual <= a_in;
		b_qual <= b_in;
		c_qual <= c_in;
	end

	// test all input instructions with random data
	always @ (posedge clk) begin
                // Don't deal with signs right now
		a_in <= $random;
                a_in[31:4] <= 28'b0;
		b_in <= $random;
                b_in[31:4] <= 28'b0;
		c_in <= $random;
                c_in[31:8] <= 24'b0;
	end

	// Specify what the correct outputs should be
	always @ (*) begin
		exp_output = (a_qual * b_qual) + c_qual;
	end

	// check for correct output of the MADD
	always @ (posedge clk) begin
		if (madd_out !== exp_output && ~firstclk) begin
			$display("Output of MADD doesn't match the expected value");
			$display("Output:%h, Expected:%h, A:%h, B:%h, C:%h",
							madd_out,exp_output,a_qual,b_qual,c_qual);
                        $display("Parital product 0: %h", MADD_inst.pprow0);
                        $display("one0 %h, two0 %h, neg0 %h, enc0 X %h, madinst A %h", MADD_inst.bmul.one0, MADD_inst.bmul.two0, MADD_inst.bmul.neg0, MADD_inst.bmul.enc0.X, MADD_inst.A);
                        $display("Parital product 1: %h", MADD_inst.pprow1);
                        $display("Parital product 2: %h", MADD_inst.pprow2);
                        $display("Parital product 3: %h", MADD_inst.pprow3);
                        $display("Parital product 4: %h", MADD_inst.pprow4);
                        $display("Parital product 5: %h", MADD_inst.pprow5);
                        $display("Parital product 6: %h", MADD_inst.pprow6);
                        $display("Parital product 7: %h", MADD_inst.pprow7);
                        $display("Parital product 8: %h", MADD_inst.pprow8);
                        $display("Parital product 9: %h", MADD_inst.pprow9);
                        $display("Parital product 10: %h", MADD_inst.pprow10);
                        $display("Parital product 11: %h", MADD_inst.pprow11);
                        $display("Parital product 12: %h", MADD_inst.pprow12);
                        $display("Parital product 13: %h", MADD_inst.pprow13);
                        $display("Parital product 14: %h", MADD_inst.pprow14);
                        $display("Parital product 15: %h", MADD_inst.pprow15);

			$stop;
		end
	end

        always @ (posedge clk)
                firstclk <= 1'b0;

endmodule
