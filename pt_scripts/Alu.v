`timescale 1ns / 10 ps
module Alu( Z, A, B, DI, DO, CI, INST, FLAGS, FirstCyc );
input [31:0] A;
input [31:0] B;
input [31:0] DI;
input [3:0] INST;
input CI;
input FirstCyc;
output [31:0] Z;
output [31:0] DO;
output [3:0] FLAGS;
wire  dpa_zero, dpa_one;
wire [3:0] Z_Inst_Z1_, Z_Inst_, Z_BInst_X1_, Z_BInst_;
wire [31:0] Z_AS_, Z_BS_;
wire  Z_passA_, Z_BINVERT__4_, Z_BINVERT_, Z_BCARRY__5_, Z_BCARRY__6_,
     Z_BCARRY_, Z_AS0_, const_1_1_, Z_AS1_, const_2_1_, Z_AS2_, Z_AS3_;
reg [1:0] Z_ASIGN__8_;
wire  const_3_0_;
reg  Z_ASIGN_;
wire  const_4_0_;
reg [31:0] Z_BIN_;
wire [31:0] Z_BI1_, Z_AIN_, Z_AI_;
wire  Z_CarryIn__9_, Z_CarryIn__10_, Z_CarryIn__11_;
reg  Z_CarryIn_;
wire [2:0] const_5_6_;
wire  const_6_1_, Z_DIVIDE_, Z_BI__14_;
wire [31:0] Z_BI_Z1_, Z_BI__13_;
wire  Z_BI__15_;
reg [31:0] Z_BI_;
wire [32:0] Z_SUM_, Z_Z0_, Z_Z1_, Z_Z2_, Z_Z3_, Z_Z4_, Z_Z5_, Z_Z6_, Z_Z7_,
     Z_AdderOutN_;
wire [31:0] Z_BA_X1_, Z_BA_, Z_BB_X1_, Z_BB_;
wire [32:0] Z_Z8_, Z_Z9_, Z_Z10_, Z_Z11_, Z_Z12_, Z_Z13_;
wire  const_7_0_;
wire [32:0] Z_Z14_;
wire  const_8_1_;
wire [32:0] Z_Z15_;
reg [31:0] Z_ZB_;
wire [31:0] Z_ZC__16_;
reg [31:0] Z_ZC_;
wire [31:0] Z_1_;
wire  Z_C_, Z_OVF_, Z_CarryF_, Z_ZeroF__17_, Z_ZeroF_, const_9_0_;
wire [3:0] FLAGS_Z1_, FLAGS_3_;
wire [31:0] DO_Z1_, DO_2_;
assign dpa_zero= 1024'h0;
assign dpa_one= 1024'h1;
assign const_1_1_= 1024'h1;
assign const_2_1_= 1024'h1;
assign const_3_0_= 1024'h0;
assign const_4_0_= 1024'h0;
assign const_5_6_= 1024'h6;
assign const_6_1_= 1024'h1;
assign const_7_0_= 1024'h0;
assign const_8_1_= 1024'h1;
assign const_9_0_= 1024'h0;

assign Z_Inst_Z1_={ INST[3],INST[2],INST[1],INST[0]};

assign Z_Inst_= (Z_Inst_Z1_[3:0]);

assign Z_BInst_X1_ = Z_Inst_[3:0];

assign Z_BInst_ = Z_BInst_X1_[3:0];

assign Z_AS_= (A[31:0]);

assign Z_BS_= (B[31:0]);

assign Z_passA_= (Z_Inst_[2]&Z_Inst_[1]&Z_Inst_[0]);

assign Z_BINVERT__4_= (Z_Inst_[2]&~Z_Inst_[1]);

assign Z_BINVERT_= (Z_Inst_[0]&~Z_BINVERT__4_);

assign Z_BCARRY__5_= (Z_Inst_[0]&Z_Inst_[1]);

assign Z_BCARRY__6_= (~Z_Inst_[0]&~Z_Inst_[1]&~Z_Inst_[2]);

assign Z_BCARRY_= (Z_BCARRY__5_|Z_BCARRY__6_);

assign Z_AS0_= (Z_AS_[31]);

assign Z_AS1_= (const_1_1_);

assign Z_AS2_= (A[31]-B[31]-const_2_1_+1 == (2'b0<<0));

assign Z_AS3_= (Z_AS2_);
always @ (Z_Inst_[1:0]  or Z_AS2_ or Z_AS1_ or Z_AS0_) begin
	case (Z_Inst_[1:0])
		2'd2: Z_ASIGN__8_ = (Z_AS2_);
		2'd1: Z_ASIGN__8_ = (Z_AS1_);
		2'd0: Z_ASIGN__8_ = (Z_AS0_);
		default: Z_ASIGN__8_ = 2'bx;
	endcase
end
always @ (Z_BInst_[2]  or Z_ASIGN__8_ or const_3_0_) begin
	case (Z_BInst_[2])
		1'd1: Z_ASIGN_ = ~(Z_ASIGN__8_[1:0]);
		1'd0: Z_ASIGN_ = ~(const_3_0_);
		default: Z_ASIGN_ = 1'bx;
	endcase
end
always @ (Z_BInst_[1]  or Z_BS_ or const_4_0_) begin
	case (Z_BInst_[1])
		1'd1: Z_BIN_ = ~(Z_BS_[31:0]);
		1'd0: Z_BIN_ = ~(const_4_0_);
		default: Z_BIN_ = 32'bx;
	endcase
end

assign Z_BI1_= (Z_BIN_[31:0]^(-Z_BINVERT_));

assign Z_AIN_= (Z_AS_[31:0]^(-Z_ASIGN_));

assign Z_AI_= (~Z_AIN_[31:0]&~(-Z_passA_));

assign Z_CarryIn__9_= ((-Z_BCARRY_)|~(-Z_ASIGN_));

assign Z_CarryIn__10_= (~(-Z_CarryIn__9_));

assign Z_CarryIn__11_= (~CI);
always @ (FirstCyc  or Z_CarryIn__10_ or Z_CarryIn__11_) begin
	case (FirstCyc)
		1'd1: Z_CarryIn_ = ~((-Z_CarryIn__10_));
		1'd0: Z_CarryIn_ = ~(Z_CarryIn__11_);
		default: Z_CarryIn_ = 1'bx;
	endcase
end

assign Z_DIVIDE_= (Z_Inst_[3:0]-const_5_6_[2:0]-const_6_1_+1 == (5'b0<<0));

assign Z_BI__14_= (~DI[31]);

assign Z_BI_Z1_={ Z_BI1_[30:0],Z_BI__14_};

assign Z_BI__13_= (Z_BI_Z1_[31:0]);

assign Z_BI__15_= (~Z_DIVIDE_);
always @ (Z_BI__15_  or Z_BI1_ or Z_BI__13_) begin
	case (Z_BI__15_)
		1'd1: Z_BI_ = ~(Z_BI1_[31:0]);
		1'd0: Z_BI_ = ~(Z_BI__13_[31:0]);
		default: Z_BI_ = 32'bx;
	endcase
end

assign Z_SUM_= (Z_BI_[31:0]+Z_AI_[31:0]+Z_CarryIn_);

assign Z_Z0_= (Z_SUM_[32:0]);

assign Z_Z1_= (Z_Z0_[32:0]);

assign Z_Z2_= (Z_Z0_[32:0]);

assign Z_Z3_= (Z_Z0_[32:0]);

assign Z_Z4_= (Z_Z0_[32:0]);

assign Z_Z5_= (Z_Z0_[32:0]);

assign Z_Z6_= (Z_Z0_[32:0]);

assign Z_Z7_= (Z_Z0_[32:0]);

assign Z_AdderOutN_= (~Z_Z0_[32:0]);

assign Z_BA_X1_ = Z_AS_[31:0];

assign Z_BA_ = Z_BA_X1_[31:0];

assign Z_BB_X1_ = Z_BS_[31:0];

assign Z_BB_ = Z_BB_X1_[31:0];

assign Z_Z8_= (Z_BA_[31:0]&Z_BB_[31:0]);

assign Z_Z9_= (Z_BA_[31:0]|Z_BB_[31:0]);

assign Z_Z10_= (Z_BA_[31:0]^Z_BB_[31:0]);

assign Z_Z11_= (~Z_BB_[31:0]);

assign Z_Z12_= (Z_BA_[31:0]);

assign Z_Z13_= (~Z_BA_[31:0]);

assign Z_Z14_= (const_7_0_);

assign Z_Z15_= (const_8_1_);
always @ (Z_BInst_[2:0]  or Z_Z15_ or Z_Z14_ or Z_Z13_ or Z_Z12_ or Z_Z11_
     or Z_Z10_ or Z_Z9_ or Z_Z8_) begin
	case (Z_BInst_[2:0])
		3'd7: Z_ZB_ = (Z_Z15_[32:0]);
		3'd6: Z_ZB_ = (Z_Z14_[32:0]);
		3'd5: Z_ZB_ = (Z_Z13_[32:0]);
		3'd4: Z_ZB_ = (Z_Z12_[32:0]);
		3'd3: Z_ZB_ = (Z_Z11_[32:0]);
		3'd2: Z_ZB_ = (Z_Z10_[32:0]);
		3'd1: Z_ZB_ = (Z_Z9_[32:0]);
		3'd0: Z_ZB_ = (Z_Z8_[32:0]);
		default: Z_ZB_ = 32'bx;
	endcase
end

assign Z_ZC__16_= (~Z_ZB_[31:0]);
always @ (Z_BInst_[3]  or Z_ZC__16_ or Z_AdderOutN_) begin
	case (Z_BInst_[3])
		1'd1: Z_ZC_ = ~(Z_ZC__16_[31:0]);
		1'd0: Z_ZC_ = ~(Z_AdderOutN_[32:0]);
		default: Z_ZC_ = 32'bx;
	endcase
end

assign Z_1_= (Z_ZC_[31:0]);

assign Z_C_= (~Z_AdderOutN_[32]);

assign Z_OVF_= (Z_AI_[31]^Z_BI_[31]^Z_AdderOutN_[32]^Z_AdderOutN_[31]);

assign Z_CarryF_= (Z_C_);

assign Z_ZeroF__17_= (Z_1_[0]|Z_1_[1]|Z_1_[2]|Z_1_[3]|Z_1_[4]|Z_1_[5]|Z_1_[6]
    |Z_1_[7]|Z_1_[8]|Z_1_[9]|Z_1_[10]|Z_1_[11]|Z_1_[12]|Z_1_[13]|Z_1_[14]
    |Z_1_[15]|Z_1_[16]|Z_1_[17]|Z_1_[18]|Z_1_[19]|Z_1_[20]|Z_1_[21]|Z_1_[22]
    |Z_1_[23]|Z_1_[24]|Z_1_[25]|Z_1_[26]|Z_1_[27]|Z_1_[28]|Z_1_[29]|Z_1_[30]
    |Z_1_[31]);

assign Z_ZeroF_= (~Z_ZeroF__17_);

assign FLAGS_Z1_={ const_9_0_,Z_ZeroF_,Z_CarryF_,Z_OVF_};

assign FLAGS_3_= (FLAGS_Z1_[3:0]);

assign DO_Z1_={ DI[30:0],Z_C_};

assign DO_2_= (DO_Z1_[31:0]);

assign Z = Z_1_[31:0];

assign DO = DO_2_[31:0];

assign FLAGS = FLAGS_3_[3:0];

/*User Defined Aliases */
endmodule
