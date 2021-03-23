`timescale 1ns/10ps

module cpu(); 
	//define clock, reset ConFF

	wire PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, incPC, Read, 
	Write, clear, Gra, Grb, Grc, Rin, Rout, BAout, Cout;
	reg reset, CONFF, clock;
	wire [4:0] aluControl;

	initial begin
		clock = 0;
		forever #10 clock = ~clock; 
	end 

	DataPath DUT(PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, incPC, Read, Write,aluControl, clock, clear,Gra, Grb, Grc, Rin, Rout, BAout, Cout);

	control_unit CU( PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin,incPC, Read, Write, clear,Gra, Grb, Grc, Rin, Rout, BAout, Cout,aluControl,clock, reset, CONFF);

endmodule 