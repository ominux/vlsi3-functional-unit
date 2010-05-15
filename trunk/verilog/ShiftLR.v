`timescale 100ps / 10 ps
module ShiftLR( Z, X, S, LEFT, LOG , clock);
input [31:0] X;
input [4:0] S;
input LEFT;
input LOG;
input clock;
output [31:0] Z;

// intermediate wires needed
wire [4:0] S_FLIPPED;
wire [4:0] shift;
//wire [62:0] mux_in;
reg [62:0] mux_in;
wire [46:0] shift4;
wire [38:0] shift3;
wire [34:0] shift2;
wire [32:0] shift1;
wire [31:0] shift0;

// insert these so we can use clock gating on the inputs
reg [31:0] clocked_input;
reg [4:0] clocked_shift;
reg clocked_left, clocked_log;

// used to assign intermediate input
integer i;

/////////////////////
// Latch the Input //
/////////////////////
always @ (posedge clock) begin
	clocked_input <= X;
	clocked_shift <= S;
	clocked_left <= LEFT;
	clocked_log <= LOG;
end


///////////////////////////////
// set up inputs  to shifter //
///////////////////////////////
//assign mux_in = (~LOG && ~LEFT) ? {31{X[31]},X[31:0]} : {31'b0,X[31:0]};
always @ (X) begin
	mux_in[31:0] = clocked_input;
	if (~clocked_log && ~clocked_left) begin
		for (i=32;i<63;i=i+1) begin
			mux_in[i]=clocked_input[31];
		end
	end
	else mux_in[62:32] = 0;
end

////////////////////////////////////////////
// set up select bits                     //
// use 2's complement if LEFT is asserted //
// else assume right shift                //
////////////////////////////////////////////
assign S_FLIPPED = ~clocked_shift;
assign shift = clocked_left ? {S_FLIPPED[4]^(&S_FLIPPED[3:0]),
															S_FLIPPED[3]^(&S_FLIPPED[2:0]),
															S_FLIPPED[2]^(&S_FLIPPED[1:0]),
															S_FLIPPED[1]^S_FLIPPED[0],
															S[0]} : S;

/////////////////
// LOG SHIFTER //
/////////////////
// 0th stage, shift by 
assign shift4 = shift[4] ? mux_in[62:16] : mux_in[46:0];
// 1st stage, shift by 8
assign shift3 = shift[3] ? shift4[46:8] : shift4[38:0];
// 2nd stage, shift by 4
assign shift2 = shift[2] ? shift3[38:4] : shift3[34:0];
// 3rd stage, shift by 2
assign shift1 = shift[1] ? shift2[34:2] : shift2[32:0];
// 4th stage, shift by 1
assign shift0 = shift[0] ? shift1[32:1] : shift1[31:0];

// final output
assign Z = shift0[31:0];
endmodule
