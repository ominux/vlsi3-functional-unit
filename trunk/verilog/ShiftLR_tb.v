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
	wire signed [31:0] output_data;

	// create a clock to control shifting
	reg clk;
	// latch the data for comparison with the output data
	reg signed [31:0] clked_in;
	reg [4:0] clked_shift_amount;
	reg clked_left, clked_logical;
	
	// instantiate the barrel shifter here
	ShiftLR inst_shift (.X(input_data),.S(shift_amount),
											.LEFT(shift_left),.LOG(logical),
											.clock(clk), .Z(output_data));

	// vary the inputs and control the outputs
	initial begin
		$monitor("Input data:%h, output data:%h, shift:%h, left:%b, logical:%b",
							clked_in,output_data,clked_shift_amount,clked_left,clked_logical);
		shift_left = 0;
		clk = 0;
		logical = 0;
		
		$display("Testing Arithmetic Shift Right...");
		#140 logical = 1;
		$display("Testing Logical Shift Right...");
		#140 shift_left = 1;
		$display("Testing Logical Shift Left...");
		#140 logical = 0;
		$display("Testing Arithmetic Shift Left...");
		#140 $display("Shifter Test completed Successfully");
		$stop;
	end

	// create the clock (700MHz ~ 1.4ns)
	always #7 clk <= ~clk;

	// change the input data and shift amount to random values
	always @ (posedge clk) begin
		input_data <= $random;
		shift_amount <= $random;
	end

	// output data will be delayed
	always @ (posedge clk) begin
		clked_in <= input_data;
		clked_shift_amount <= shift_amount;
		clked_logical <= logical;
		clked_left <= shift_left;
	end

	// check that we are always doing the correct shifting
	always @ (output_data) begin
		// check all left shifts
		if (clked_left) begin
			if (output_data !== clked_in<<clked_shift_amount) begin
				$display("ERROR: Shift Left Incorrect\n");
				$display("Output data:%h, input_data:%h, amount:%h, should be:%h",
									output_data,clked_in,clked_shift_amount,clked_in<<clked_shift_amount);
				$stop;
			end
		end
		// logical shift right
		else if(clked_logical) begin
			if (output_data !== clked_in>>clked_shift_amount) begin
				$display("ERROR: Logical Shift Right Incorrect\n");
				$display("Output data:%h, input_data:%h, amount:%h, should be:%h",
									output_data,clked_in,clked_shift_amount,clked_in>>clked_shift_amount);
				$stop;
			end
		end
		// arithmetic shift right
		else begin
			if (output_data !== clked_in>>>clked_shift_amount) begin
				$display("ERROR: Arithmetic Shift Right Incorrect\n");
				$display("Output data:%h, input_data:%h, amount:%h, should be:%h",
									output_data,clked_in,clked_shift_amount,clked_in>>>clked_shift_amount);
				$stop;
			end
		end
	end

endmodule
