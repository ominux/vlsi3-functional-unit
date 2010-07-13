module Alu( Z, A, B, INST, SEL);
output [31:0] Z;
input signed [31:0] A;
input signed [31:0] B;
input [3:0] INST;
input SEL;

reg [31:0] Z;

always @ (A or B or INST or SEL) begin
	case (INST)
		4'b0000: Z = A + B;
		4'b0001: Z = 32'h00000001 + ~A;
		4'b0010: Z = A & B;
		4'b0011: Z = A | B;
		4'b0100: Z = A ^ B;
		4'b0101: Z = ~A;
		4'b0110: begin
			if(SEL)
				Z = B;
			else
				Z = A;
			end
		4'b0111: begin
			if(SEL)
				Z = A;
			else
				Z = B;
			end
		4'b1000: Z = A - B;
		4'b1001: Z = {31'b0, A < B};
		4'b1010: Z = {31'b0, A <= B};
		4'b1011: Z = {31'b0, A > B};
		4'b1100: Z = {31'b0, A >= B};
		4'b1101: Z = {31'b0, A == B};
		4'b1110: Z = {31'b0, A != B};
		4'b1111: Z = {31'b0, SEL ^ B}; 
		default: Z = 32'b0;
	endcase
end

endmodule
