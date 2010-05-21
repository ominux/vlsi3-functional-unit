/*
 File:		Top level module for the functional unit of Mosaic

 Author:	Jimmy Xu and Corey Olson
 
 Date:		5/16/2010

 Notes:		
					1)INST must arrive during the low phase of the
						CLOCK.  Easy way to do this is to synchronize 
						with a negedge triggered FF.
*/

module functional_unit(Z, COMPARE, A, B, C, INST, SELECT, CLOCK);
	
	////////
	// IO //
	////////
	output reg [31:0] Z;		// data output of the FU
	output COMPARE;					// single bit comparison flag (only relevant for LT, GTE, ...)
	input [31:0] A, B, C;
	input [5:0] INST;
	input SELECT;
	input CLOCK;
	
	//////////////////////
	// Internal Signals //
	//////////////////////
	wire [31:0] ALU_Z, MADD_Z, BS_Z, MUX_Z;
	wire Gated_clock_ALU, Gated_clock_BS, Gated_clock_MADD;
	
	// decoded instruction to be sent to the ALU
	reg [4:0] alu_inst;
	reg [31:0] alu_b_in;
	
	// third input to the MADD unit can be C or 32'b0
	reg [31:0] madd_add_in;
	
	// need to latch MS 4 bits of instruction for the final output mux
	reg	[5:0] INST_qual;
	
	// for the instructions that select a value based on SELECT bit
	reg [31:0] mux_a_qual, mux_b_qual, mux_a_in, mux_b_in;
	reg [2:0] mux_inst_qual;
	reg	select_qual;
	
	// SHIFT input to the barrel shifter is not always B[4:0]
	reg [4:0] shift_amount;
	// logical and left shifting dependent upon instruction
	reg shift_log, shift_left;
	
	//////////////////////////////
	// Enables for Clock Gating //
	//////////////////////////////
	reg en_clock_alu, en_clock_bs, en_clock_madd, en_clock_mux;
	
	// gate the clocks to the blocks if they are not needed
	always @ (*) begin
		en_clock_alu <= ~INST[5];
		en_clock_bs <= INST[5] & ~INST[4];
		en_clock_madd <= &INST[5:3];
		en_clock_mux <= INST[5] & INST[4] & ~INST[3];
	end
	and alu_gate(Gated_clock_ALU, CLOCK, en_clock_alu);
	and bs_gate(Gated_clock_BS, CLOCK, en_clock_bs);
	and madd_gate(Gated_clock_MADD, CLOCK, en_clock_madd);
	and mux_gate(Gated_clock_MUX, CLOCK, en_clock_mux);





	////////////////////////
	// Decode Instruction //
	////////////////////////
	
	// ALU's encoding of instructions
	localparam [3:0]	ADD_1 = 4'b0000,	SUB_1 = 4'b0001,	ADD_AB =4'b0010, 
										SUB_AB = 4'b0011,	NEG_A = 4'b0101,	AND_AB = 4'b1000,	
										OR_AB = 4'b1001,	XOR_AB = 4'b1010,	NOT_A = 4'b1101;
	
	// instructions
	// notes:
	// ~OP[5]=enable ALU
	// OP[5],~OP[4]=enable SHIFTER
	// OP[5],OP[4],OP[3]=enable MADD
	// OP[5],OP[4],~OP[3]=enable MUX
	localparam [5:0]	OP_ADD=6'b000010, OP_SUB=6'b000011, OP_NEGA=6'b000101,
										OP_NOTA=6'b001101,OP_AND=6'b001000,	OP_OR=6'b001001,
										OP_XOR=6'b001010,	OP_INC_A=6'b000000,OP_DEC_A=6'b000001,
										OP_LT=6'b001110,	OP_LTE=6'b001111,	OP_GT=6'b010110,
										OP_GTE=6'b010111,	OP_EQ=6'b011110,	OP_NEQ=6'b011111,
										OP_A_EQ_0=6'b010000,OP_A_NEQ_0=6'b010001,	OP_A_GT_0=6'b010010,
										OP_A_GTE_0=6'b010011,	OP_A_LTE_0=6'b010100,	OP_A_LT_0=6'b010101,
										OP_A_EQ_1=6'b011000,OP_A_NEQ_1=6'b011001,	OP_A_GT_1=6'b011010,
										OP_A_GTE_1=6'b011011,	OP_A_LTE_1=6'b011100,	OP_A_LT_1=6'b011101,
										OP_SHR=6'b100000,OP_SHL=6'b100011,OP_ASHR=6'b100101,
										OP_ASHR_1=6'b100001,OP_ASHR_2=6'b100010,OP_ASHR_4=6'b100100,
										OP_ASHR_16=6'b101000,OP_MUL=6'b1110zz,OP_MADD=6'b1111zz,
										OP_SELECT=6'b110000,OP_SEL_AOR0=6'b110001,OP_SEL_AOR1=6'b110010,
										OP_SEL_0OR1=6'b110011, OP_SEL_1OR0=6'b110100;
	
	always @ (*) begin
		// defaults
		alu_inst = SUB_AB;			// subtract with ALU
		alu_b_in = B;						// B should be second ALU input
		shift_amount = B[4:0];	// shift amount is LS 5 bits of B
		shift_left = 1'b0;			// shift to the right
		shift_log = 1'b0;				// arithmetic shifting
		madd_add_in = 32'b0;		// just multiply with MADD unit
		mux_a_in = A;						// select between A and B
		mux_b_in = B;						// select between A and B
		
		casez(INST)
			OP_INC_A:			alu_inst = ADD_1;
			OP_DEC_A:			alu_inst = SUB_1;
			OP_ADD:				alu_inst = ADD_AB;
			OP_SUB:				alu_inst = SUB_AB;
			OP_NEGA:			alu_inst = NEG_A;
			OP_AND:				alu_inst = AND_AB;
			OP_OR:				alu_inst = OR_AB;
			OP_XOR:				alu_inst = XOR_AB;
			OP_NOTA:			alu_inst = NOT_A;
			OP_LT:				begin end
			OP_LTE:				begin end
			OP_GT:				begin end
			OP_GTE:				begin end
			OP_EQ:				begin end
			OP_NEQ:				begin end
			OP_A_EQ_0:		alu_b_in = 32'b0;
			OP_A_NEQ_0:		alu_b_in = 32'b0;
			OP_A_GT_0:		alu_b_in = 32'b0;
			OP_A_GTE_0:		alu_b_in = 32'b0;
			OP_A_LTE_0:		alu_b_in = 32'b0;
			OP_A_LT_0:		alu_b_in = 32'b0;
			OP_A_EQ_1:		alu_b_in = 32'b1;
			OP_A_NEQ_1:		alu_b_in = 32'b1;
			OP_A_GT_1:		alu_b_in = 32'b1;
			OP_A_GTE_1:		alu_b_in = 32'b1;
			OP_A_LTE_1:		alu_b_in = 32'b1;
			OP_A_LT_1:		alu_b_in = 32'b1;
			OP_SHR:				shift_log = 1'b1;
			OP_SHL:				begin shift_left = 1'b1; shift_log = 1'b1; end
			OP_ASHR:			begin end
			OP_ASHR_1:		shift_amount = 5'h1;
			OP_ASHR_2:		shift_amount = 5'h2;
			OP_ASHR_4:		shift_amount = 5'h4;
			OP_ASHR_16:		shift_amount = 5'h10;
			6'b1110zz:		madd_add_in = 32'b0;
			6'b1111zz:		madd_add_in = C;
			OP_SELECT:		begin end
			OP_SEL_AOR0:	mux_b_in = 32'b0;
			OP_SEL_AOR1:	mux_b_in = 32'b1;
			OP_SEL_0OR1:	begin mux_a_in = 32'b0; mux_b_in = 32'b1; end
			OP_SEL_1OR0:	begin mux_a_in = 32'b1; mux_b_in = 32'b0; end
			default: begin end
		endcase
	end


	/////////
	// ALU //
	/////////
	Alu ALU_inst (.Z(ALU_Z),.A(A),.B(B),.INST(alu_inst),
                .FLAGS(FLAGS),.CLOCK(Gated_clock_ALU));
		
	////////////////////
	// Barrel Shifter //
	////////////////////
	ShiftLR shifter_inst (.Z(BS_Z), .X(A), .S(), .LOG(), 
												.LEFT(), .CLOCK(Gated_clock_BS));

	//////////
	// MADD //
	//////////
  MADD madd_inst (.Z(MADD_Z), .A(A), .B(B), 
									.C(madd_add_in), .CLK(Gated_clock_MADD));

	////////////////
	// SELECT MUX //
	////////////////
	// Note: we may want to mux the data on the first clock cycle
	//       and only clock gate the data that has alread been muxed
	always @ (posedge Gated_clock_MUX) begin
		mux_a_qual <= mux_a_in;
		mux_b_qual <= mux_b_in;
		select_qual <= SELECT;
	end
	assign MUX_Z = select_qual ? mux_b_qual : mux_a_qual;

	/////////////////////
	// Output Data Mux //
	/////////////////////
	always @ (posedge CLOCK) INST_qual <= INST[5:2];
	always @ (*) begin
		casez(INST_qual)
			6'b0zzzzz:	Z = ALU_Z;
			6'b10zzzz:	Z = BS_Z;
			6'b111zzz:	Z = MADD_Z;
			6'b110zzz:	Z = MUX_Z;
			default:		Z = ALU_Z;
		endcase
	end
	
	////////////////////////
	// Output Control Mux //
	////////////////////////

	// Flags
	//	0:overflow
	//	1:carry
	//	2:zero
	//	3:sign
	assign COMPARE =	(INST_qual == OP_LT) ? Z[31] ^ FLAGS[0] :
										(INST_qual == OP_LTE) ? Z[31] ^ :
										(INST_qual == OP_GT) ? COMPARE = :
										(INST_qual == OP_GTE) ? COMPARE = :
										(INST_qual == OP_EQ) ? COMPARE = :
										(INST_qual == OP_NEQ) ? COMPARE = :
										(INST_qual == OP_A_EQ_0) ? COMPARE = :
										(INST_qual == OP_A_NEQ_0) ? COMPARE = :
										(INST_qual == OP_A_GT_0) ? COMPARE = :
										(INST_qual == OP_A_GTE_0) ? COMPARE = :
										(INST_qual == OP_A_LTE_0) ? COMPARE = :
										(INST_qual == OP_A_LT_0) ? COMPARE = :
										(INST_qual == OP_A_EQ_1) ? COMPARE = :
										(INST_qual == OP_A_NEQ_1) ? COMPARE = :
										(INST_qual == OP_A_GT_1) ? COMPARE = :
										(INST_qual == OP_A_GTE_1) ? COMPARE = :
										(INST_qual == OP_A_LTE_1) ? COMPARE = :
										(INST_qual == OP_A_LT_1) ? COMPARE = :
										1'b0;
endmodule
