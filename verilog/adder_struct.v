// carry look ahead adder
module adder (A, B, Cin, S, P, G, Cout, OVF);

	////////
	// IO //
	////////
  input  [31:0]  A, B;
  input          Cin;
  output [31:0]	 S, P, G;
  output Cout, OVF;

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
      carrychain[0] = P[0] + (P[0] & Cin);
      for(i = 1; i <= 31; i = i + 1)
        begin
          carrychain[i] = G[i] + (P[i] & carrychain[i-1]);
        end
    end
	
	// Sum
  wire [32:0] shiftedcarry = {carrychain,Cin};
  assign S = P ^ shiftedcarry;    // summation
  
	// Carry Out
	assign Cout = shiftedcarry[32];
	
	// Overflow
	assign OVF = shiftedcarry[32] ^ shiftedcarry[31];

endmodule
