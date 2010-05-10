`timescale 1ns / 10 ps
module ShiftLR( Z, X, S, LEFT, LOG );
input [31:0] X;
input [4:0] S;
input LEFT;
input LOG;
output [31:0] Z;
/*wire  dpa_zero, dpa_one;
wire [31:0] Z_XR_;
wire  Z_X1__2_;
reg [31:0] Z_X1_;
wire  Z_SIGN__3_, const_1_0_;
reg  Z_SIGN_;
wire [32:0] Z_X2_Z1_, Z_X2_, Z_X2A_, Z_X3_;
wire [31:0] Z_X5_, Z_X4_;
wire  Z_4_;
reg [31:0] Z_1_;*/
/*
assign dpa_zero= 1024'h0;
assign dpa_one= 1024'h1;
assign const_1_0_= 1024'h0;
assign Z_XR_={X[0],X[1],X[2],X[3],X[4],X[5],X[6],X[7],X[8],X[9],X[10],X[11],X
    [12],X[13],X[14],X[15],X[16],X[17],X[18],X[19],X[20],X[21],X[22],X[23],X
    [24],X[25],X[26],X[27],X[28],X[29],X[30],X[31]};

assign Z_X1__2_= (~LEFT);
always @ (Z_X1__2_  or X or Z_XR_) begin
	case (Z_X1__2_)
		1'd1: Z_X1_ = ~(X[31:0]);
		1'd0: Z_X1_ = ~(Z_XR_[31:0]);
		default: Z_X1_ = 32'bx;
	endcase
end

assign Z_SIGN__3_= (~LOG&~LEFT);
always @ (Z_SIGN__3_  or X or const_1_0_) begin
	case (Z_SIGN__3_)
		1'd1: Z_SIGN_ = ~(X[31]);
		1'd0: Z_SIGN_ = ~(const_1_0_);
		default: Z_SIGN_ = 1'bx;
	endcase
end

assign Z_X2_Z1_={ Z_SIGN_,Z_X1_[31:0]};

assign Z_X2_= (Z_X2_Z1_[32:0]);

assign Z_X2A_= (Z_X2_[32:0]);

wire [64:0] __Z_X3__in;
assign __Z_X3__in = (Z_X2A_[31:0]-(Z_X2A_[32]<<32));
assign Z_X3_=(__Z_X3__in >> (S[4:0]));

assign Z_X5_= (Z_X3_[31:0]);
assign Z_X4_={Z_X5_[0],Z_X5_[1],Z_X5_[2],Z_X5_[3],Z_X5_[4],Z_X5_[5],Z_X5_[6],
    Z_X5_[7],Z_X5_[8],Z_X5_[9],Z_X5_[10],Z_X5_[11],Z_X5_[12],Z_X5_[13],Z_X5_
    [14],Z_X5_[15],Z_X5_[16],Z_X5_[17],Z_X5_[18],Z_X5_[19],Z_X5_[20],Z_X5_[21],
    Z_X5_[22],Z_X5_[23],Z_X5_[24],Z_X5_[25],Z_X5_[26],Z_X5_[27],Z_X5_[28],Z_X5_
    [29],Z_X5_[30],Z_X5_[31]};

assign Z_4_= (~LEFT);
always @ (Z_4_  or Z_X5_ or Z_X4_) begin
	case (Z_4_)
		1'd1: Z_1_ = ~(Z_X5_[31:0]);
		1'd0: Z_1_ = ~(Z_X4_[31:0]);
		default: Z_1_ = 32'bx;
	endcase
end

assign Z = Z_1_[31:0];
*/

// intermediate wires needed
wire [4:0] shift;
wire [62:0] mux_in;
wire [46:0] shift4;
wire [38:0] shift3;
wire [34:0] shift2;
wire [32:0] shift1;
wire [31:0] shift0;

///////////////////////////////
// set up inputs  to shifter //
///////////////////////////////
assign mux_in = (~LOG && ~LEFT) ? {31{X[31]},X} : {31'b0,X};

////////////////////////////////////////////
// set up select bits                     //
// use 2's complement if Left is asserted //
// else assume right shift                //
////////////////////////////////////////////
assign shift = LEFT ? {S[4]^(S[3]&S[2]&S[1]&S[0]),S[3]^(S[2]&S[1]&S[0]),S[2]^(S[1]&S[0]),S[1]^S[0],~S[0]} : S;

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

/*
///////////////////////
// REGISTERED OUTPUT //
///////////////////////

// would need to add inputs for clock and clk_en
wire enabled_clock;
assign enabled_clock = clock & clk_en;

always @ (posedge enabled_clock) begin
	if (~reset) begin
		Z <= 32'b0;
	end
	else begin
		Z <= shift4;
	end
end
*/
endmodule
