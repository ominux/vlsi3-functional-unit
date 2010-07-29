/*

File: Bi-directional shifter used in the 
			functional unit of the Mosaic project.
			This unit is purely comibinational.

Author: Corey Olson

Date: 5/13/2010

*/
module ShiftLR( Z, X, S, LEFT, LOG);
input [31:0] X;
input [4:0] S;
input LEFT;
input LOG;
output [31:0] Z;

// intermediate wires needed
wire [4:0] shift;
wire [31:0] shift4;
wire [31:0] shift3;
wire [31:0] shift2;
wire [31:0] shift1;
wire [31:0] shift0;

// Naming conventions:
// _cg = clock gated
// _n = inverted signal

// insert these so we can use clock gating on the inputs
wire [4:0] shift_n;
wire [31:0] mask, mask_rev;
  
assign shift_n = ~S;

assign shift0 = ~(LEFT | S[0]) ? X : (S[0] ? {X[0], X[31:1]} : {X[1:0], X[31:2]});
assign shift1 = (S[1] ^ LEFT) ? {shift0[1:0], shift0[31:2]} : shift0;
assign shift2 = (S[2] ^ LEFT) ? {shift1[3:0], shift1[31:4]} : shift1;
assign shift3 = (S[3] ^ LEFT) ? {shift2[7:0], shift2[31:8]} : shift2;
assign shift4 = (S[4] ^ LEFT) ? {shift3[15:0], shift3[31:16]} : shift3;

generate
   genvar  i,j;
   for (j=0; j<32; j=j+1) begin : maskgen
      assign mask[j] = S > j;
      assign mask_rev[31 - j] = mask[j];
   end
//   for (i=0; i<32; i=i+1) begin : outgen
//      assign Z[i] = (LEFT) ? (mask & shift4) : ((~mask & shift4) | ({32{LOG}} & ~mask & X[31]));
//   end
endgenerate
assign Z = (LEFT) ? (~mask & shift4) : ((~mask_rev & shift4) | ({32{~LOG}} & mask_rev & {32{X[31]}}));
   
initial $monitor("Input:%h, output:%h, shift:%h, left:%b, logical:%b, mask:%h, mask_rev:%h, shift4:%h",X,Z,S,LEFT,LOG,mask, mask_rev,shift4);

endmodule
