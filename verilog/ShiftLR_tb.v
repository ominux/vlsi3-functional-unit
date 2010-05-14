/*

File: Testbench for the bi-directional shifter used in the Mosaic project

Author: Corey Olson

Date: 5/13/2010

*/

`include "ShiftLR.v"
//`include "ShiftLR.vh"

module ShiftLR_tb();
	
	// inputs to the shifter
	reg [31:0] input_data;
	reg [4:0] shift_amount;
	reg shift_left,logical;

	// outputs from the shifter
	wire [31:0] output_data;

	// create a clock to control shifting
	reg clk;

	// instantiate the barrel shifter here
	ShiftLR inst_shift (.X(input_data),.S(shift_amount),
											.LEFT(shift_left),.LOG(logical),
											.Z(output_data));

	// vary the inputs and control the outputs
	initial begin
		shift_left = 0;
		logical = 0;
		
		#500 logical = 1;
		#500 shift_left = 1;
		#500 logical = 0;
		#500 $display("Shifter Test completed Successfully");
		$stop;
	end

	// create the clock
	always #50 clk <= ~clk;

	// change the input data and shift amount to random values
	always @ (posedge clk) begin
		input_data = $random;
		shift_amount = $random;
		$display("Testing with input data=%h, shift_amount=%h\n",input_data,shift_amount);
	end

	// check that we are always doing the correct shifting
	always @ (*) begin
		// check all left shifts
		if (shift_left) begin
			if (output_data !== input_data<<shift_amount) begin
				$display("ERROR: Shift Left Incorrect\n");
				$display("Output data:%h, input_data:%h, amount:%h",
									output_data,input_data,shift_amount);
				$stop;
			end
		end
		// logical shift right
		else if(logical) begin
			if (output_data !== input_data>>shift_amount) begin
				$display("ERROR: Logical Shift Right Incorrect\n");
				$display("Output data:%h, input_data:%h, amount:%h",
									output_data,input_data,shift_amount);
				$stop;
			end
		end
		// arithmetic shift right
		else begin
			if (output_data !== input_data>>>shift_amount) begin
				$display("ERROR: Arithmetic Shift Right Incorrect\n");
				$display("Output data:%h, input_data:%h, amount:%h",
									output_data,input_data,shift_amount);
				$stop;
			end
		end
	end

endmodule
