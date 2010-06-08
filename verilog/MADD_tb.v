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

		// wait 128 clock cycles
		repeat (128) @ (posedge clk);
                $display("\nSUCCESS!");
		$stop;
	end

	// generate the clock
	always #7 clk <= ~clk;

	// inputs to the MADD are latched inside the MADD
	always @(posedge clk) begin
		a_qual <= a_in;
		b_qual <= b_in;
	end

        // c arrives on the second cycle
        always @* begin
		c_qual <= c_in;
        end

	// test all input instructions with random data
	always @ (posedge clk) begin
                // Don't deal with signs right now
		a_in <= $random;
                //a_in[29:0] <= 30'b0;
		b_in <= $random;
                //b_in[31:2] <= 30'b0;
		c_in <= $random;
                //c_in[31:0] <= 32'b0;
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
				 madd_out, exp_output, a_qual, b_qual, c_qual);
                        $display("Parital product 0: %h", MADD_inst.pprow0);
                        //$display("one0 %h, two0 %h, neg0 %h, enc0 X %h, madinst X %h Y %h", MADD_inst.bmul.one15, MADD_inst.bmul.two15, MADD_inst.bmul.neg15, MADD_inst.bmul.enc15.X, MADD_inst.A, MADD_inst.B);
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
                        $display("Z: %h Two's comp: %h", MADD_inst.bmul.ppgen15.twoscomper.Z, MADD_inst.bmul.ppgen15.twoscomp);
                        $display("posone15 %h, postwo15 %h, negone15 %h, negtwo15 %h, enc15 X %h, madinst X %h Y %h", MADD_inst.bmul.posone15, MADD_inst.bmul.postwo15, MADD_inst.bmul.negone15, MADD_inst.bmul.negtwo15, MADD_inst.bmul.enc15.X, MADD_inst.A, MADD_inst.B);
                        $display("rsum0: %h", MADD_inst.rsum6);
                        $display("rsum1: %h", MADD_inst.rsum7);
                        $display("rsum2: %h", MADD_inst.rsum8);
                        $display("rsum3: %h", MADD_inst.rsum9);
                        $display("rsum4: %h", MADD_inst.rsum9);
                        $display("rsum5: %h", MADD_inst.rsum9);
                        $display("rcout0: %h", MADD_inst.rcout6);
                        $display("rcout1: %h", MADD_inst.rcout7);
                        $display("rcout2: %h", MADD_inst.rcout8);
                        $display("rcout3: %h", MADD_inst.rcout9);
                        $display("rcout4: %h", MADD_inst.rcout9);
                        $display("rcout5: %h", MADD_inst.rcout9);
                        $display("sum0, in B: %h C: %h", {MADD_inst.pprow8r[15:0], 1'b0, MADD_inst.rA[15], 14'b0}, {1'b0, MADD_inst.rA[31], 30'b0});
                   
			$stop;
		end
	end

        always @ (posedge clk)
                firstclk <= 1'b0;

endmodule
