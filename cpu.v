`timescale 1ns/10ps

module cpu(input clock, reset); 
	//import clock, reset 
	//cpu top level entity

	wire PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, incPC, Read, 
	Write, clear, Gra, Grb, Grc, Rin, Rout, BAout, Cout, ConIn, HIout, RoutPIn;
	reg CONFF;
	wire [4:0] aluControl;
	wire [31:0] instr; 

	DataPath DUT(PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, Read, Write, aluControl, clock, clear, 
	Gra, Grb, Grc, Rin, Rout, BAout, Cout, ConIn, HIout, RoutPIn, incPC, instr);

	control_unit CU(PCout, Zlowout, MDRout, incPC, MARin, Zin, PCin, MDRin, IRin, Yin, Read, Write, 
	clear, Gra, Grb, Grc, Rin, Rout, BAout, Cout, ConIn, HIout, RoutPIn, aluControl, clock, reset, CONFF, instr); 
	
	
endmodule 