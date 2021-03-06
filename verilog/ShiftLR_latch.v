/*

File: Bi-directional shifter used in the 
			functional unit of the Mosaic project.
			This unit is purely comibinational.

Author: Corey Olson

Date: 5/13/2010

*/
module ShiftLR( Z, X, S, LEFT, LOG, EN);
input [31:0] X;
input [4:0] S;
input LEFT;
input LOG;
output [31:0] Z;
input EN;

// intermediate wires needed
wire [4:0] shift;
reg [62:0] mux_in;
wire [46:0] shift4;
wire [38:0] shift3;
wire [34:0] shift2;
wire [32:0] shift1;
wire [31:0] shift0;
reg [31:0] X_latch;
reg [4:0] S_latch;

// Naming conventions:
// _cg = clock gated
// _n = inverted signal

// insert these so we can use clock gating on the inputs
wire [4:0] shift_n;

// used to assign intermediate input
integer i;

///////////////////////////////
// set up inputs  to shifter //
///////////////////////////////

// Latch input
always @*
  if (EN) begin
     X_latch <= X;
     S_latch <= S;
  end

always @ (*) begin
	// shift left
	// log & arith - input is {data,31'0}
	if(LEFT) begin
		mux_in = {X_latch[30:0],32'b0};
	end
	// shift right
	// logical - input is {31'0,data}
	else if(LOG) begin
		mux_in = {31'b0,X_latch};
	end
	// arithmetic - {31' sign extend,data}
	else begin
		mux_in[31:0] = X_latch;
		for (i=32;i<63;i=i+1) begin
			mux_in[i]=X_latch[31];
		end
	end
end

////////////////////////////////////////////
// set up select bits                     //
// use 2's complement if LEFT is asserted //
// else assume right shift                //
////////////////////////////////////////////
assign shift_n = ~S_latch;
assign shift = LEFT ?	{shift_n[4]^(&shift_n[3:0]),
											shift_n[3]^(&shift_n[2:0]),
											shift_n[2]^(&shift_n[1:0]),
											shift_n[1]^shift_n[0],
											S_latch[0]} : S_latch;

/////////////////
// LOG SHIFTER //
/////////////////
// 0th stage, shift by 16
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
// NOTE: Shifting the way that we do makes it impossible to shift left by 0 bits, 
//				so this is a hack to fix that.  we could simply not support a shift left
//				of 0 bits, and that should be considered
assign Z = |shift ? shift0[31:0] : X_latch;

initial $monitor("Input:%h, output:%h, shift:%h, left:%b, logical:%b",X,Z,S,LEFT,LOG);

endmodule
