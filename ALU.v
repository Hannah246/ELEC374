module ALU(
    input [4:0] aluControl, 
    input [31:0] BusMuxInY, 
	 input [31:0] BusMuxOut, 
    output [31:0] Zlowout, 
	 output [31:0] Zhighout
);

//have two outputs instead
reg [63:0] ZOut;
reg [31:0] COut;
reg [31:0] temp;
reg [31:0] temp1; 
integer i;

always @ (aluControl) begin
	 temp1 = BusMuxOut; 
    if(aluControl == 5'b00011) begin //Add
        COut = BusMuxInY + BusMuxOut;
	 end
    else if(aluControl == 5'b00100) begin //Sub
        COut = BusMuxInY - BusMuxOut;
	 end
    else if(aluControl == 5'b00101) begin //Shift Right
        for (i = 1 ; i < 32 ; i = i + 1) begin 
            COut[i] = BusMuxInY[i-1];
		  end 
        COut[0] = 0;
	 end
    else if(aluControl == 5'b00110) begin //Shift Left
        for (i = 0 ; i < 31 ; i = i + 1) begin
            COut[i] = BusMuxInY[i+1];
		  end 
        COut[31] = 0;
	 end
    else if(aluControl == 5'b00111) begin //Rotate Right
        for (i = 1 ; i < 32 ; i = i + 1) begin 
            COut[i] = BusMuxInY[i-1];
		  end 
        COut[0] = BusMuxInY[31];
	 end
    else if(aluControl == 5'b01000) begin //Rotate Left
        for (i = 0 ; i < 31 ; i = i + 1) begin 
            COut[i] = BusMuxInY[i+1];
		  end 
        COut[31] = BusMuxInY[0];
	 end
    else if(aluControl == 5'b01001) begin //AND
    //loop with for loop, then use logial and for each bit 
        for (i = 0 ; i < 32 ; i = i + 1) begin 
            COut = (BusMuxInY & temp1);
		  end
	 end 
    else if(aluControl == 5'b01010) begin //OR
        for (i = 0 ; i < 32 ; i = i + 1) begin 
            COut[i] = BusMuxInY[i] | BusMuxOut[i];
		  end 
	 end 
    else if(aluControl == 5'b01110) begin //Multiply
        //COut <=
	 end
    else if(aluControl == 5'b01111) begin //Divide
        COut = BusMuxInY / BusMuxOut;
	 end
    else if(aluControl == 5'b10000) begin //Negate
        COut = BusMuxInY*-1;
	 end
    else if(aluControl == 5'b10001) begin //Not
        for (i = 0 ; i < 32 ; i = i + 1) begin 
            COut[i] = ~BusMuxInY[i];
		  end 
	 end
	 temp = {32{COut[31]}};
	// assign the results to z high and z low 
	
end

assign Zhighout = temp; // ZOut[31:0]
assign Zlowout = COut;  // ZOut[63:32]

endmodule

// Z register holds the results of the operation in ALU