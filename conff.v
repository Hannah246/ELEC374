module conff(
    input [31:0] BusMuxIn, 
    input [31:0] IR,  // C2 = IR[22:19]
    input ConIn, // phase 3
    output branch
); 

/*
make input BusMuxInIR 32 bits and isolate the 4 required bits
output name should be controlOut
you should have an always block that runs anytime inputs change
assign statement will need to be outside of always block (may need a temp reg variable and assign output to that outside always block)

*/

reg temp; 
reg temp2; 
reg [3:0] BusMuxInIR; 
integer i; 



always @ (ConIn) begin

	BusMuxInIR = IR[22:19]; 

	if (BusMuxInIR[0] == 1'b1) begin
		 
		 temp = BusMuxInIR[0] & ~(|BusMuxIn);     // IR[0] AND Bus
		 // decoder[0] & (|bus)
		 
		 if (temp == 1'b1) begin             // if equals 0
			  temp2 = 1'b1; 
		 end 
	end 
	else if (BusMuxInIR[1] == 1'b1) begin 

		 temp = BusMuxInIR[1] & (|BusMuxIn);            // IR[1] AND (NOT Bus)

		 if (temp != 1'b0) begin                 // if not equals 0
																
			  temp2 = temp; 
		 end 
	end 
	else if (BusMuxInIR[2] == 1'b1) begin 
		 temp = BusMuxInIR[2] & ~BusMuxIn[31];          // IR[2] AND (NOT Bus[31])
		 
																		// if greater than equal to 0
		 temp2 = temp; 
		 
	end 
	else if (BusMuxInIR[3] == 1'b1) begin 
		 temp = BusMuxInIR[3] & BusMuxIn[31];           // IR[3] AND Bus[31]
		 															// if less than 0
		 temp2 = temp; 
		 
	end 
	
	if (ConIn == 1'b0) begin 
		temp2 = 1'b0; 
	end 
	
end 
	
assign branch = temp2; // (((temp[0] | temp[1]) | temp[2]) | temp[3]); 


endmodule 