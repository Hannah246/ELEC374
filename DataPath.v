
//added write signal to DataPath
module DataPath(
    input PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, Read, Write,
	 input [4:0] aluControl, 
	 input clock, clear,
    input Gra, Grb, Grc, Rin, Rout, BAout, Cout, ConIn, HIout, LOout, RoutPIn, incPC,
	 inout [31:0] ramOut, 
	 output conffOut, 
	 input RHiIn, RLOIn, Zhighout
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
wire [31:0] BusMuxInCSign;
wire [31:0] BusMuxInRY;
wire [31:0] ALULoOut; 
wire [31:0] ALUHiOut; 
//phase 2
wire [8:0] Address;
wire [31:0] BusMuxInIR;
wire r0out; 
wire r1out; 
wire R2out; 
wire r3out; 
wire R4out; 
wire r5out; 
wire r6out; 
wire r7out; 
wire r8out; 
wire r9out; 
wire r10out;
wire r11out;
wire r12out;
wire r13out;
wire r14out;
wire r15out; 
wire [31:0] BusMuxInRoutP; 
wire [31:0] BusMuxInRHi; 
// phase 3 
wire branch; 
wire [31:0] BusMuxInLo; 

//instantiate all register
 register R1(clock, clear, R1in, BusMuxOut, BusMuxInR1);
 register R2(clock, clear, R2in, BusMuxOut, BusMuxInR2);
 register R3(clock, clear, R3in, BusMuxOut, BusMuxInR3);
 register R4(clock, clear, R4in, BusMuxOut, BusMuxInR4);
 register R5(clock, clear, R5in, BusMuxOut, BusMuxInR5);
 register R6(clock, clear, R6in, BusMuxOut, BusMuxInR6);
 register R7(clock, clear, R7in, BusMuxOut, BusMuxInR7);
 register R8(clock, clear, R8in, BusMuxOut, BusMuxInR8);
 register R9(clock, clear, R9in, BusMuxOut, BusMuxInR9);
 register R10(clock, clear, R10in, BusMuxOut, BusMuxInR10);
 register R11(clock, clear, R11in, BusMuxOut, BusMuxInR11);
 register R12(clock, clear, R12in, BusMuxOut, BusMuxInR12);
 register R13(clock, clear, R13in, BusMuxOut, BusMuxInR13);
 register R14(clock, clear, R14in, BusMuxOut, BusMuxInR14);
 register R15(clock, clear, R15in, BusMuxOut, BusMuxInR15);
 register RHi(clock, clear, RHiIn, BusMuxOut, BusMuxInRHi);
 register RLO(clock, clear, RLOIn, BusMuxOut, BusMuxInLo);
 register RZHi(clock, clear, Zin, ALUHiOut, BusMuxInZHi);
 register RZLO(clock, clear, Zin, ALULoOut, BusMuxInZLo);
 //register PC(clock, clear, PCIn, BusMuxOut, BusMuxInPC);
 register RInP(clock, clear, RInPIn, BusMuxOut, BusMuxInRInP);
 //register RCSign(clock, clear, RCSignIn, BusMuxOut, BusMuxInCSign);
 register RoutP(clock, clear, RoutPIn, BusMuxOut, BusMuxInRoutP);
 register RY(clock, clear, Yin, BusMuxOut, BusMuxInRY);


//phase 2 Select and Encode
 SelectEncode selectencode(BusMuxInIR, Gra, Grb, Grc, Rin, Rout, BAout, BusMuxInCSign, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out);
 
 //phase 2 Memory subsystem
 register IR(clock, clear, IRin, BusMuxOut, BusMuxInIR);
 registerR0 R0(clock, clear, R0in, BAout, BusMuxOut, BusMuxInR0);
 MAR mar(clock, clear, MARin, BusMuxOut,Address);
 ram1 ram(Address, clock, BusMuxInMDR, Write, ramOut);
 MDR mdr(clock, clear, MDRin, Read, BusMuxOut, ramOut, BusMuxInMDR); 
 pc PC(clock, clear, PCin, incPC, branch, BusMuxOut, BusMuxInPC); //incPC to PCin to '1

 
 //phase 2 conff
conff CONFF(BusMuxOut, BusMuxInIR, ConIn, conffOut); 

//instantiate bus
bus cpuBUS(
    BusMuxInR0,BusMuxInR1,BusMuxInR2, BusMuxInR3,BusMuxInR4,BusMuxInR5,BusMuxInR6,BusMuxInR7,BusMuxInR8,BusMuxInR9,BusMuxInR10,BusMuxInR11,BusMuxInR12,BusMuxInR13,BusMuxInR14,BusMuxInR15,
    BusMuxInRHi,BusMuxInLo,BusMuxInZHi,BusMuxInZLo,BusMuxInPC,BusMuxInMDR,BusMuxInRInP,BusMuxInCSign,
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