`timescale 1ns/10ps

module control_unit; 
    reg PCout, Zlowout, MDRout; 
    reg MARin, Zin, PCin, MDRin, IRin, Yin;
    reg incPC, Read, Write, clear;
	reg [4:0] aluControl;
    reg clk, reset, CONFF; 
    reg Gra, Grb, Grc, Rin, Rout, BAout, Cout;

    parameter Reset_state = 4'b0000, fetch0 = 4'b0001, fetch1 = 4'b0010, 
        fetch2 = 4'b0011, add3 = 4'b0100, add4 = 4'b0101, add5 = 4'b0110; 
    reg [3:0] Present_state = Reset_state; 

always @ (posedge clk, posedge reset) 
    begin 
        if (reset == 1'b1) Present_state = Reset_state; 
        else case (Present_state) 
            Reset_state     :   Present_state = fetch0; 
            fetch0          :   Present_state = fetch1; 
            fetch1          :   Present_state = fetch2; 
            fetch2          :   begin
                                    case(aluControl) 
                                        5'b0011     :   Present_state = add3; 
                                    endcase
                                end              
            add3            :   Present_state = add4; 
            add4            :   Present_state = add5; 
        endcase 
    end 
            


