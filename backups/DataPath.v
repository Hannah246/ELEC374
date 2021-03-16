module DataPath(
    input [31:0] MDatain,
    input PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, incPC, Read, 
	input [4:0] aluControl, 
	input clock, clear,
    input R2In, R2out, R4In, R4out, R5In
);

//registers run behavior every positive clock edge, bus will update BusMuxOUt when a change in register output is detected
//define signals that will connect regiters to bus
wire [31:0] BusMuxOut; 
wire [31:0] BusMuxInR0;
wire [31:0] BusMuxInR1;
wire [31:0] BusMuxInR2;
wire [31:0] BusMuxInR3;
wire [31:0] BusMuxInR4;
wire [31:0] BusMuxInR5;
wire [31:0] BusMuxInR6;
wire [31:0] BusMuxInR7;
wire [31:0] BusMuxInR8;
wire [31:0] BusMuxInR9;
wire [31:0] BusMuxInR10;
wire [31:0] BusMuxInR11;
wire [31:0] BusMuxInR12;
wire [31:0] BusMuxInR13;
wire [31:0] BusMuxInR14;
wire [31:0] BusMuxInR15;
wire [31:0] BusMuxInZHi;
wire [31:0] BusMuxInZLo;
wire [31:0] BusMuxInPC;
wire [31:0] BusMuxInMDR;
wire [31:0] BusMuxInRinP;
wire [31:0] BusMuxInRCSign;
wire [31:0] BusMuxInRY;
wire [31:0] ALULoOut; 
wire [31:0] ALUHiOut; 

//instantiate all registers
 register R0(clock, clear, R0In, BusMuxOut, BusMuxInR0);
 register R1(clock, clear, R1In, BusMuxOut, BusMuxInR1);
 register R2(clock, clear, R2In, BusMuxOut, BusMuxInR2);
 register R3(clock, clear, R3In, BusMuxOut, BusMuxInR3);
 register R4(clock, clear, R4In, BusMuxOut, BusMuxInR4);
 register R5(clock, clear, R5In, BusMuxOut, BusMuxInR5);
 register R6(clock, clear, R6In, BusMuxOut, BusMuxInR6);
 register R7(clock, clear, R7In, BusMuxOut, BusMuxInR7);
 register R8(clock, clear, R8In, BusMuxOut, BusMuxInR8);
 register R9(clock, clear, R9In, BusMuxOut, BusMuxInR9);
 register R10(clock, clear, R10In, BusMuxOut, BusMuxInR10);
 register R11(clock, clear, R11In, BusMuxOut, BusMuxInR11);
 register R12(clock, clear, R12In, BusMuxOut, BusMuxInR12);
 register R13(clock, clear, R13In, BusMuxOut, BusMuxInR13);
 register R14(clock, clear, R14In, BusMuxOut, BusMuxInR14);
 register R15(clock, clear, R15In, BusMuxOut, BusMuxInR15);
 register RHi(clock, clear, RHiIn, BusMuxOut, BusMuxInRHi);
 register RLO(clock, clear, RLOIn, BusMuxOut, BusMuxInRLo);
 register RZHi(clock, clear, Zin, ALUHiOut, BusMuxInZHi);
 register RZLO(clock, clear, Zin, ALULoOut, BusMuxInZLo);
 register PC(clock, clear, PCIn, BusMuxOut, BusMuxInPC);
 MDR mdr(clock, clear, MDRin, Read, BusMuxOut, MDatain, BusMuxInMDR); 
 register RInP(clock, clear, RInPIn, BusMuxOut, BusMuxInRInP);
 register RCSign(clock, clear, RCSignIn, BusMuxOut, BusMuxInRCSign);

 register RY(clock, clear, Yin, BusMuxOut, BusMuxInRY);
 
//instantiate bus
bus cpuBUS(
    BusMuxInR0,BusMuxInR1,BusMuxInR2, BusMuxInR3,BusMuxInR4,BusMuxInR5,BusMuxInR6,BusMuxInR7,BusMuxInR8,BusMuxInR9,BusMuxInR10,BusMuxInR11,BusMuxInR12,BusMuxInR13,BusMuxInR14,BusMuxInR15,
    BusMuxInHi,BusMuxInLo,BusMuxInZHi,BusMuxInZLo,BusMuxInPC,BusMuxInMDR,BusMuxInRInP,BusMuxInRCSign,
    R0out,R1out,R2out,R3out,R4out,R5out,R6out,R7out,R8out,R9out,R10out,R11out,R12out,R13out,R14out,R15out,
    HIout,LOout,Zhighout,Zlowout,PCout,MDRout,INportout,Cout,BusMuxOut
);


ALU alu(aluControl, BusMuxInRY, BusMuxOut, ALULoOut, ALUHiOut); 


endmodule

//we essentially need to perform an action anytime one of the control signals changes
// testbench changes state every rising-edge of clock, does the job associated with state for each
//#10 = time delay of 10 before instruction is ran, same concept with #15
// wires are used to create connection between to ports (input and output port), they do not store data, only drive data
// MDRout = 1, updates BusMuxOut with value of BusMuxInMDR, since R2in  =1, R2 will hold value (write to register)
// the always @ block is used for cyclic behavior