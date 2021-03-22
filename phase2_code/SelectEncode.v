module SelectEncode(
    input [31:0] IR,
    input Gra, Grb, Grc, Rin, Rout, BAout,
    output [31:0] C_sign,
    output R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
    output R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out
);

//have two outputs instead
reg [3:0] OpCode, Ra, Rb, Rc;
reg [3:0] DecoderInput;
reg [15:0] DecoderOutput;
reg [15:0] Out;
reg [31:0] C_sign_extended;
reg [15:0] In;
reg temp;
integer i;



always @ (*) begin
	// Gra or Grb or Grc
	 OpCode = IR[31:27];
	 Ra = IR[26:23];
	 Rb = IR[22:19];
	 Rc = IR[18:15];

    if(Gra == 1) begin //Add
        DecoderInput = Ra;
	 end
    else if(Grb == 1) begin //Sub
        DecoderInput = Rb;
	 end
    else if(Grc == 1) begin //Shift Right
        DecoderInput = Rc;
	 end

    if(DecoderInput == 4'b0000) begin
        DecoderOutput = 16'b0000000000000001;
    end
    else if(DecoderInput == 4'b0001) begin
        DecoderOutput = 16'b0000000000000010;
    end
    else if(DecoderInput == 4'b0010) begin
        DecoderOutput = 16'b0000000000000100;
    end
    else if(DecoderInput == 4'b0011) begin
        DecoderOutput = 16'b0000000000001000;
    end
    else if(DecoderInput == 4'b0100) begin
        DecoderOutput = 16'b0000000000010000;
    end
    else if(DecoderInput == 4'b0101) begin
        DecoderOutput = 16'b0000000000100000;
    end
    else if(DecoderInput == 4'b0110) begin
        DecoderOutput = 16'b0000000001000000;
    end
    else if(DecoderInput == 4'b0111) begin
        DecoderOutput = 16'b0000000010000000;
    end
    else if(DecoderInput == 4'b1000) begin
        DecoderOutput = 16'b0000000100000000;
    end
    else if(DecoderInput == 4'b1001) begin
        DecoderOutput = 16'b0000001000000000;
    end
    else if(DecoderInput == 4'b1010) begin
        DecoderOutput = 16'b0000010000000000;
    end
    else if(DecoderInput == 4'b1011) begin
        DecoderOutput = 16'b0000100000000000;
    end
    else if(DecoderInput == 4'b1100) begin
        DecoderOutput = 16'b0001000000000000;
    end
    else if(DecoderInput == 4'b1101) begin
        DecoderOutput = 16'b0010000000000000;
    end
    else if(DecoderInput == 4'b1110) begin
        DecoderOutput = 16'b0100000000000000;
    end
    else if(DecoderInput == 4'b1111) begin
        DecoderOutput = 16'b1000000000000000;
    end
	 else begin 
		DecoderOutput = 16'b0000000000000000;
	 end 
    for (i = 0 ; i < 16 ; i = i + 1)
        In[i] = DecoderOutput[i] & Rin;
	 temp = Rout | BAout;
    for (i = 0 ; i < 16 ; i = i + 1)
        Out[i] = DecoderOutput[i] & temp;
    C_sign_extended = {{13{IR[18]}}, {IR[18:0]}};
	 
end
assign {R15in, R14in, R13in, R12in, R11in, R10in, R9in, R8in, R7in, R6in, R5in, R4in, R3in, R2in, R1in, R0in} = In;
assign {R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out} = Out;
assign C_sign = C_sign_extended;

endmodule