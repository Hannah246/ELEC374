`timescale 1ns/10ps
//do we need to create new file for both control and datapath
//need to define clock, reset, stop, con_FF
//Stop->how do we halt?, Run-> 1 (do we need if statement to set state to fetch0), Reset ->clear =1, initialize everything to 0
//if stop=1, run =0 stop clk
module control_unit( 
    output reg PCout, Zlowout, MDRout, IncPC, 
    MARin, Zin, PCin, MDRin, IRin, Yin,
    Read, Write, clear,
    Gra, Grb, Grc, Rin, Rout, BAout, Cout,
	 output reg [4:0] aluControl,
    input clk, reset, CONFF, 
	 input [31:0] IR
);

    parameter Reset_state = 4'b0000, fetch0 = 4'b0001, fetch1 = 4'b0010, 
        fetch2 = 4'b0011, add3 = 4'b0100, add4 = 4'b0101, add5 = 4'b0110, load3 = 4'b0111, load4 = 4'b1000, 
		  load5 = 4'b1001; 
    reg [3:0] Present_state = Reset_state; 
	 

always @ (posedge clk, posedge reset) 
    begin 
        aluControl = IR[31:27]; 
        if (reset == 1'b1) Present_state = Reset_state; 
        else case (Present_state) 
            Reset_state     :   Present_state = fetch0; 
            fetch0          :   Present_state = fetch1; 
            fetch1          :   Present_state = fetch2; 
            fetch2          :   begin
                                    case(aluControl) 
                                        5'b00000     :   Present_state = load3;
                                        5'b00011     :   Present_state = add3;

                                    endcase
                                end              
            add3            :   Present_state = add4; 
            load3           :   Present_state = load4; 
            load4           :   Present_state = load5; 
            add4            :   Present_state = add5; 
        endcase 
    end 
            



always @(Present_state)
    begin 
			case (Present_state)
				Reset_state: begin
					 PCout <= 0;   Zlowout <= 0;   MDRout<= 0;   //initialize the signals
                MARin <= 0;   Zin <= 0;  
                PCin <=0;   MDRin <= 0;   IRin  <= 0;   Yin <= 0;  
                IncPC <= 0;   Read <= 0;   
                Gra<= 0; Grb<= 0; Grc<= 0; Rin<= 0; Rout<= 0; BAout<= 0; Cout<=0;
                clear <= 1; //initialize registers to 0
					 #10 clear <= 0; 
			end

			fetch0: begin
				PCout <= 1; 
				MARin <= 1; 
				IncPC <= 1;
			end

			fetch1: begin
				PCout <= 0;
				MARin <= 0; 
				IncPC <= 0;
				#5 Read <= 1; 
				#5 MDRin <= 1;
			 end
			 
			 fetch2: begin
				Read <= 0;
				MDRin <= 0;
				//load MDR value to bus which contains instruction, instruction is then stored in IR
				MDRout<= 1; 
				IRin <= 1; 
			 end
			 
			 add3:begin
				MDRout<= 0; 
				IRin <= 0;
				Grb <= 1;
				//set to 1 to generate R0out = 1 and store value of R0 (0) into Y register
				BAout <= 1;
				Yin <= 1; 
				#5 Grb <= 0; 
			 end
			 
			 add4:begin
				 BAout <= 0;
				 Yin <= 0; 
				 //store C sign extended value on bus (should be 85 decimal)
				 Cout <=1;   
				 Zin <=1;
			 end
			 
			 add5:begin
				Cout <= 0;
				Zin <=0;
				Zlowout <= 1;
				Gra <= 1;  
				Rin <= 1;
			 end
			 
			 load3:begin
				  

			 end

			 load4:begin
				  

			 end

		endcase
end
endmodule