`timescale 1ns/10ps

module cpu(input clock, reset, stop, run); 
	//import clock, reset 
	//cpu top level entity

	wire PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, incPC, Read, 
	Write, clear, Gra, Grb, Grc, Rin, Rout, BAout, Cout, ConIn, HIout, LOout, RoutPIn;
	wire CONFF;
	wire [4:0] aluControl;
	wire [31:0] instr; 
	wire RHiIn, RLOIn, ZHIout; 

	DataPath DUT(PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, Read, Write, aluControl, clock, clear, 
	Gra, Grb, Grc, Rin, Rout, BAout, Cout, ConIn, HIout, LOout, RoutPIn, incPC, instr, CONFF, RHiIn, RLOIn, ZHIout);

	control_unit CU(PCout, Zlowout, MDRout, incPC, MARin, Zin, PCin, MDRin, IRin, Yin, Read, Write, 
	clear, Gra, Grb, Grc, Rin, Rout, BAout, Cout, ConIn, HIout, LOout, RoutPIn, aluControl, clock, reset, CONFF, 
	instr, RHiIn, RLOIn, ZHIout, run); 
	
	
endmodule 