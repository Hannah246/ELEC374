module bus(input [31:0] BusMuxInR0, input [31:0] BusMuxInR1, input [31:0] BusMuxInR2, input [31:0] BusMuxInR3,input [31:0] BusMuxInR4,input [31:0] BusMuxInR5,input [31:0] BusMuxInR6,input [31:0] BusMuxInR7,input [31:0] BusMuxInR8,input [31:0] BusMuxInR9,input [31:0] BusMuxInR10,
input [31:0] BusMuxInR11,input [31:0] BusMuxInR12,input [31:0] BusMuxInR13,input [31:0] BusMuxInR14,input [31:0] BusMuxInR15,input [31:0] BusMuxInHi,input [31:0] BusMuxInLo,input [31:0] BusMuxInZHi,input [31:0] BusMuxInZLo,input [31:0] BusMuxInPC,
input [31:0] BusMuxInMDR,input [31:0] BusMuxInRInP,input [31:0] BusMuxInRCSign, input R0out, input R1out,input R2out,input R3out,input R4out,input R5out,input R6out,input R7out,input R8out,input R9out,input R10out,input R11out,input R12out,
input R13out,input R14out,input R15out,input HIout,input LOout,input Zhighout,input Zlowout,input PCout, input MDRout,input InPortout,input Cout, output [31:0] BusMuxOut);

reg [31:0] out;

always @ (*) begin  
// R0out or R1out or R2out or R4out or R5out or R6out or R7out or R8out or R9out or R10out or R11out or R12out or R13out or R14out or R15out or MDRout or PCout or HIout or LOout or Zhighout or Zlowout or InPortout or Cout
	if(R0out) begin
		out = BusMuxInR0;
	end
	else if(Cout) begin
		out =  BusMuxInRCSign;
	end
	else if(R1out) begin
		out = BusMuxInR1;
	end
	else if(R2out) begin
		out = BusMuxInR2;
	end
	else if(R3out) begin
		out = BusMuxInR3;
	end
	else if(R4out) begin
		out = BusMuxInR4;
	end
	else if(R5out) begin
		out = BusMuxInR5;
	end
	else if(R6out) begin
		out = BusMuxInR6;
	end
	else if(R7out) begin
		out = BusMuxInR7;
	end
	else if(R8out) begin
		out = BusMuxInR8;
	end
	else if(R9out) begin
		out = BusMuxInR9;
	end
	else if(R10out) begin
		out = BusMuxInR10;
	end
	else if(R11out) begin
		out = BusMuxInR11;
	end
	else if(R12out) begin
		out = BusMuxInR12;
	end
	else if(R13out)begin
		out = BusMuxInR13;
	end
	else if(R14out)begin
		out = BusMuxInR14;
	end
	else if(R15out)begin
		out = BusMuxInR15;
	end
	else if(HIout)begin
		out = BusMuxInHi;
	end
	else if(LOout)begin
		out = BusMuxInLo;
	end
	else if(Zhighout)begin
		out = BusMuxInZHi;
	end
	else if(Zlowout)begin
		out = BusMuxInZLo;
	end
	else if(PCout)begin
		out = BusMuxInPC;
	end
	else if(MDRout)begin
		out = BusMuxInMDR;
	end
	else if(InPortout)begin
		out = BusMuxInRInP;
	end
//	else if(Cout) begin
//		out =  BusMuxInRCSign;
//	end
	else begin
		out = 32'bx;
	end
end
assign BusMuxOut = out;
endmodule
