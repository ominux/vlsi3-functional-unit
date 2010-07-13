// carry look ahead adder
module adder (A, B, Cin, S, P, G, OVF);

	////////
	// IO //
	////////
  input  [31:0]  A, B;
  input          Cin;
  output [31:0]	 S, P, G;
  output OVF;

	////////////////////
	// Internal Nodes //
	////////////////////
	reg    [31:0]  carrychain;
  
	// P, G
	assign G = A & B; // carry generate
  assign P = A ^ B; // carry propagate
  
	// Carry Chain
	always @(*)
    begin : carry_generation
      integer i;
      carrychain[0] = G[0] + (P[0] & Cin);
      for(i = 1; i <= 31; i = i + 1)
        begin
          carrychain[i] = G[i] + (P[i] & carrychain[i-1]);
        end
    end
	
	/*
	// 8 4-bit CLAs that interface directly with the bits
	CLA cla_0 (P, G, C, Cout, Pin, Gin, Cin);
	CLA cla_0 ();
	CLA cla_0 ();
	CLA cla_0 ();
	CLA cla_0 ();
	CLA cla_0 ();
	CLA cla_0 ();
	CLA cla_0 ();
		
	// 2 MS 4-bit CLAs that interface with the lower level CLAs
	CLA cla_0 ();
	CLA cla_0 ();
	*/
	
	// Sum
  wire [32:0] shiftedcarry;

	assign shiftedcarry = {carrychain,Cin};
  assign S = P ^ shiftedcarry[31:0];    // summation
  
	// Carry Out
	assign Cout = shiftedcarry[32];
	
	// Overflow
	assign OVF = shiftedcarry[32] ^ shiftedcarry[31];

endmodule

/*
// Carry Look-Ahead Unit
module CLA (P, G, C, Cout, Pin, Gin, Cin);

	// I/O
	output	[3:0] C;
	output				Cout, P, G;
	input		[3:0] Pin, Gin;
	input					Cin;
	
	assign C[0] = Cin;
	assign C[1] = Gin[0] + (Pin[0] & Cin);
	assign C[2] = Gin[1] + (Pin[1] & Gin[0]) + (Pin[1] & Pin[0] & Cin);
	assign C[3] = Gin[2] + (Pin[2] & Gin[1]) + (Pin[2] & Pin[1] & Gin[0]) + (Pin[2] & Pin[1] & Pin[0] & Cin);
	assign Cout = Gin[3] + (Pin[3] & Gin[2]) + (Pin[3] & Pin[2] & Gin[1]) + (Pin[3] & Pin[2] & Pin[1] & Gin[0]) + (Pin[3] & Pin[2] & Pin[1] & Pin[0] & Cin);
	
	assign P = &Pin;
	assign G = Gin[3] + Pin[3] & Gin[2] + Pin[3] & Pin[2] & Gin[1] + Pin[3] & Pin[2] & Pin[1] & Gin[0];
	
endmodule*/
