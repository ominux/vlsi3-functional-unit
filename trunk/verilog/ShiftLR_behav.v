/*

File: Bi-directional shifter behavioral model

Author: Nathaniel McVicar

Date: 5/17/2010

*/

module ShiftLR(Z, X, S, LEFT, LOG);

   input signed [31:0]  X;
   input [4:0]   S;
   input         LEFT;
   input         LOG;
   output reg signed [31:0] Z;

   always @(*) begin
      case ({LEFT, LOG})
        2'b00 : Z <= X >>> S;
        2'b01 : Z <= X >> S;
        2'b10 : Z <= X <<< S;
        2'b11 : Z <= X << S;
      endcase
   end

endmodule // ShiftLR
