module adder (A, B, Cin, S, Cout);
// carry look ahead adder

  input  [31:0]  A, B;
  input          Cin;
  output [31:0]  S;
  reg    [31:0]  carrychain;
  output Cout;

  wire   [31:0]  g = A & B; // carry generate
  wire   [31:0]  p = A ^ B; // carry propagate
  
  always @(A or B or Cin)
    begin : carry_generation
      integer i;
      carrychain[0] = g[0] + (p[0] & Cin);
      for(i = 1; i <= 31; i = i + 1)
        begin
          #0                // force evaluation
          carrychain[i] = g[i] + (p[i] & carrychain[i-1]);
        end
    end

  wire  [32:0]  shiftedcarry = {carrychain, Cin} ;
  wire  [31:0]  S = p ^ shiftedcarry;    // summation
  wire  Cout = shiftedcarry[32];
endmodule

