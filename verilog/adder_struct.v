// carry look ahead adder
module adder (A, B, Cin, S, P, G, OVF);

	////////
	// IO //
	////////
  input  [31:0]  A, B;
  input          Cin;
  output [31:0]	 S, P, G;
  output OVF;
	
	// P, G
	assign G = A & B; // carry generate
  assign P = A ^ B; // carry propagate

	/////////////////////////////
	// Ripple Carry Type Adder //
	/////////////////////////////
	reg		[31:0]  carrychain;
  wire	[32:0] shiftedcarry;
	 
	// Carry Chain
	always @(*) begin : carry_generation
		integer i;
		carrychain[0] = G[0] + (P[0] & Cin);
		for(i = 1; i <= 31; i = i + 1) begin
			carrychain[i] = G[i] + (P[i] & carrychain[i-1]);
		end
  end
	
	// Sum
	assign shiftedcarry = {carrychain,Cin};
  assign S = P ^ shiftedcarry[31:0];    // summation
	
	// Overflow
	assign OVF = shiftedcarry[32] ^ shiftedcarry[31];

endmodule

// End of Ripple Carry Adder



/*
	////////////////////////////////
	// Carry LookAhead Type Adder //
	////////////////////////////////
	wire	[7:0]		group_P, group_G, group_Cin;

	// 8 4-bit CLAs that interface directly with the bits
	CLA cla_0 (.P(group_P[0]), .G(group_G[0]), .C(carrychain[3:0]), 
							.Pin(P[3:0]), .Gin(G[3:0]),	.Cin(group_Cin[0]));
	CLA cla_1 (.P(group_P[1]), .G(group_G[1]), .C(carrychain[7:4]), 
							.Pin(P[7:4]), .Gin(G[7:4]), .Cin(group_Cin[1]));
	CLA cla_2 (.P(group_P[2]), .G(group_G[2]), .C(carrychain[11:8]), 
							.Pin(P[11:8]), .Gin(G[11:8]), .Cin(group_Cin[2]));
	CLA cla_3 (.P(group_P[3]), .G(group_G[3]), .C(carrychain[15:12]), 
							.Pin(P[15:12]), .Gin(G[15:12]), .Cin(group_Cin[3]));
	CLA cla_4 (.P(group_P[4]), .G(group_G[4]), .C(carrychain[19:16]), 
							.Pin(P[19:16]), .Gin(G[19:16]), .Cin(group_Cin[4]));
	CLA cla_5 (.P(group_P[5]), .G(group_G[5]), .C(carrychain[23:20]), 
							.Pin(P[23:20]), .Gin(G[23:20]), .Cin(group_Cin[5]));
	CLA cla_6 (.P(group_P[6]), .G(group_G[6]), .C(carrychain[27:24]), 
							.Pin(P[27:24]), .Gin(G[27:24]), .Cin(group_Cin[6]));
	CLA cla_7 (.P(group_P[7]), .G(group_G[7]), .C(carrychain[31:28]), 
							.Pin(P[31:28]), .Gin(G[31:28]), .Cin(group_Cin[7]));
		
	// 2 MS 4-bit CLAs that interface with the lower level CLAs
	CLA cla_lvl1_0 (.C(group_Cin[3:0]), .Cout(carry_lvl1), .Pin(group_P[3:0]), .Gin(group_G[3:0]), .Cin(Cin));
	CLA cla_lvl1_1 (.C(group_Cin[7:4]), .Cout(Cout), .Pin(group_P[7:4]), .Gin(group_G[7:4]), .Cin(carry_lvl1));
	
	// Sum
  assign S = P ^ carrychain;
	
	// Overflow
	assign OVF = Cout ^ carrychain[31];

endmodule

// Carry Look-Ahead Unit
module CLA (P, G, C, Cout, Pin, Gin, Cin);

	// I/O
	output	[3:0] C;
	output				Cout, P, G;
	input		[3:0] Pin, Gin;
	input					Cin;
	
	assign C[0] = Cin;
	assign C[1] = Gin[0] | (Pin[0] & Cin);
	assign C[2] = Gin[1] | (Pin[1] & Gin[0]) | (Pin[1] & Pin[0] & Cin);
	assign C[3] = Gin[2] | (Pin[2] & Gin[1]) | (Pin[2] & Pin[1] & Gin[0]) | (Pin[2] & Pin[1] & Pin[0] & Cin);
	assign Cout = Gin[3] | (Pin[3] & Gin[2]) | (Pin[3] & Pin[2] & Gin[1]) | (Pin[3] & Pin[2] & Pin[1] & Gin[0]) | (Pin[3] & Pin[2] & Pin[1] & Pin[0] & Cin);
	
	assign P = &Pin;
	assign G = Gin[3] | (Pin[3]&Gin[2]) | (Pin[3]&Pin[2]& Gin[1]) | (Pin[3]&Pin[2]&Pin[1]&Gin[0]);
	
endmodule

// End of Carry LookAhead Adder
*/
