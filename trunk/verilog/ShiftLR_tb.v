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
	reg left,logical;

	// outputs from the shifter
	wire signed [31:0] output_data;

	// create a clock to control shifting
	reg clk;
	// latch the data for comparison with the output data
	reg signed [31:0] input_cg;
	reg [4:0] shift_amount_cg;
	reg left_cg, log_cg;
	
	// instantiate the barrel shifter here
	ShiftLR inst_shift (.X(input_data),.S(shift_amount),
											.LEFT(left),.LOG(logical),
											.clock(clk), .Z(output_data));

	// vary the inputs and control the outputs
	initial begin
		$monitor("Input data:%h, output data:%h, shift:%h, left:%b, logical:%b",
							input_cg,output_data,shift_amount_cg,left_cg,log_cg);
		left = 0;
		clk = 0;
		logical = 0;
		shift_amount = 0;
		
		$display("Testing Arithmetic Shift Right...");
		#448 logical = 1;
		$display("Testing Logical Shift Right...");
		#448 left = 1;
		$display("Testing Logical Shift Left...");
		#448 logical = 0;
		$display("Testing Arithmetic Shift Left...");
		#448 $display("Shifter Test completed Successfully");
		$stop;
	end

	// create the clock (700MHz ~ 1.4ns)
	always #7 clk <= ~clk;
	
	// change the input data and shift amount to random values
	always @ (posedge clk) begin
		// output data will be delayed by 1 clock
		input_cg <= input_data;
		shift_amount_cg <= shift_amount;
		log_cg <= logical;
		left_cg <= left;
	
		// shift random data and a random amount
		input_data <= $random;
		shift_amount <= shift_amount + 1'b1;
	end

	// check that the shifted data is correct
	always @ (posedge clk) begin

		// check that we are always doing the correct shifting
		// check all left shifts
		if (left_cg) begin
			if (output_data !== input_cg<<shift_amount_cg) begin
				$display("ERROR: Shift Left Incorrect\n");
				$display("Output data:%h, input data:%h, amount:%h, should be:%h",
									output_data,input_cg,shift_amount_cg,input_cg<<shift_amount_cg);
				$stop;
			end
		end
		// logical shift right
		else if(log_cg) begin
			if (output_data !== input_cg>>shift_amount_cg) begin
				$display("ERROR: Logical Shift Right Incorrect\n");
				$display("Output data:%h, input data:%h, amount:%h, should be:%h",
									output_data,input_cg,shift_amount_cg,input_cg>>shift_amount_cg);
				$stop;
			end
		end
		// arithmetic shift right
		else begin
			if (output_data !== input_cg>>>shift_amount_cg) begin
				$display("ERROR: Arithmetic Shift Right Incorrect\n");
				$display("Output data:%h, input data:%h, amount:%h, should be:%h",
									output_data,input_cg,shift_amount_cg,input_cg>>>shift_amount_cg);
				$stop;
			end
		end
		
	end

endmodule
