`timescale 100ps / 10ps
/*

File: Testbench for the bi-directional shifter used 
			in the functional unit of the Mosaic project.

Author: Corey Olson

Date: 5/13/2010

*/

`include "ShiftLR.v"
//`include "ShiftLR.vh"

module ShiftLR_tb();
	
	// inputs to the shifter
	reg signed [31:0] input_data;
	reg [4:0] shift_amount;
	reg left,logical;

	// outputs from the shifter
	wire signed [31:0] output_data;

	// create a clock to control shifting
	reg clk;
	
	// instantiate the barrel shifter here
	ShiftLR inst_shift (.X(input_data),.S(shift_amount),
											.LEFT(left),.LOG(logical),
											.Z(output_data));

	// vary the inputs and control the outputs
	// $dumpvars
	initial begin
		$monitor("Input data:%h, output data:%h, shift:%h, left:%b, logical:%b",
							input_data,output_data,shift_amount,left,logical);
		left = 0;
		clk = 0;
		logical = 0;
		shift_amount = 0;
		
		$display("Testing Arithmetic Shift Right...");
		repeat (32) @ (posedge clk);
		logical <= 1;
		$display("Testing Logical Shift Right...");
		repeat (32) @ (posedge clk);
		left <= 1;
		$display("Testing Logical Shift Left...");
		repeat (32) @ (posedge clk);
		logical <= 0;
		$display("Testing Arithmetic Shift Left...");
		repeat (32) @ (posedge clk);
		$display("Shifter Test completed Successfully");
		$stop;
	end

	// create the clock (1GHz = 1ns period)
	always #5 clk <= ~clk;
	
	// change the input data and shift amount to random values
	always @ (posedge clk) begin
		input_data <= $random;
		shift_amount <= shift_amount + 1'b1;
	end

	// check that the shifted data is correct
	always @ (posedge clk) begin

		// check that we are always doing the correct shifting
		// check all left shifts
		if (left) begin
			if (output_data !== input_data<<shift_amount) begin
				$display("ERROR: Shift Left Incorrect\n");
				$display("Output data:%h, input data:%h, amount:%h, should be:%h",
									output_data,input_data,shift_amount,input_data<<shift_amount);
				$stop;
			end
		end
		// logical shift right
		else if(logical) begin
			if (output_data !== input_data>>shift_amount) begin
				$display("ERROR: Logical Shift Right Incorrect\n");
				$display("Output data:%h, input data:%h, amount:%h, should be:%h",
									output_data,input_data,shift_amount,input_data>>shift_amount);
				$stop;
			end
		end
		// arithmetic shift right
		else begin
			if (output_data !== input_data>>>shift_amount) begin
				$display("ERROR: Arithmetic Shift Right Incorrect\n");
				$display("Output data:%h, input data:%h, amount:%h, should be:%h",
									output_data,input_data,shift_amount,input_data>>>shift_amount);
				$stop;
			end
		end
		
	end

endmodule
