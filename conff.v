module conff(
    input [31:0] BusMuxIn, 
    input [3:0] BusMuxInIR,  // C2 = IR[22:19]
    // import IR fully then specfically select those few regs
    input conIn, // phase 3
    output [1:0] BusMuxOut
); 

reg [1:0] temp; 
integer i; 

if (BusMuxInIR[0] == 1'b1) begin
    
    temp = BusMuxInIR[0] & (|BusMuxIn);     // IR[0] AND Bus
    // decoder[0] & (|bus)
    
    if (temp == 1'b0) begin             // if equals 0
        assign BusMuxOut = temp; 
    end 
end 
else if (BusMuxInIR[1] == 1'b1) begin 

    temp = BusMuxInIR[1] & (~(|BusMuxIn));            // IR[1] AND (NOT Bus)

    if (temp != 1'b0) begin                 // if not equals 0
        assign BusMuxOut = temp; 
    end 
end 
else if (BusMuxInIR[2] == 1'b1) begin 
    temp = BusMuxInIR[2] & ~BusMuxIn[31];          // IR[2] AND (NOT Bus[31])
    
    if (temp >= 1b'0) begin             // if greater than equal to 0
        assign BusMuxOut = temp; 
    end 
end 
else if (BusMuxInIR[3] == 1'b1) begin 
    temp = BusMuxInIR[3] & BusMuxIn[31];           // IR[3] AND Bus[31]
    
    if (temp < 1b'0) begin              // if less than 0
        assign BusMuxOut = temp; 
    end 
end 

assign BusMuxOut = (((temp[0] | temp[1]) | temp[2]) | temp[3]); 


endmodule 