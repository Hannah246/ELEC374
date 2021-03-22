`timescale 1ns/10ps

module ldiR0; 
    reg PCout, Zlowout, MDRout, R2out, R4out;// add any other signals to see in your simulation
    reg MARin, Zin, PCin, MDRin, IRin, Yin;
    reg incPC, Read;
	reg [4:0] Operator;
    reg clk;
	reg clear,Write; 
    reg Gra, Grb, Grc, Rin, Rout, BAout, Cout;

    parameter   Default = 4'b0000, T0= 4'b0111,T1= 4'b1000,T2= 4'b1001, T3= 4'b1010, T4= 4'b1011, T5= 4'b1100,T6= 4'b1101,T7= 4'b1110;
    reg[3:0] Present_state= Default;

DataPath DUT(PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, Read, Write, Operator, clk, clear, 
Gra, Grb, Grc, Rin, Rout, BAout,Cout);


initial begin
	clk = 0;
	forever #10 clk = ~clk; 
end 


always @(posedge clk)     //finite state machine; if clk rising-edge
    begin
        case (Present_state)
            Default     :   #40 Present_state = T0;
            T0          :   #40 Present_state = T1;
            T1          :   #40 Present_state = T2;
            T2          :   #40 Present_state = T3;
            T3          :   #40 Present_state = T4;
            T4          :   #40 Present_state = T5;
        endcase
    end
    
always @(Present_state)     // do the required job ineach state
    begin
        case (Present_state)              //assert the required signals in each clk cycle
            Default: begin
                PCout <= 0;   Zlowout <= 0;   MDRout<= 0;   //initialize the signals
                MARin <= 0;   Zin <= 0;  
                PCin <=0;   MDRin <= 0;   IRin  <= 0;   Yin <= 0;  
                incPC <= 0;   Read <= 0;   Operator <= 5'b00000;
                Gra<= 0; Grb<= 0; Grc<= 0; Rin<= 0; Rout<= 0; BAout<= 0; Cout<=0;
                // clear <= 1; //initialize registers to 0
					 // #10 clear <= 0; 
            end
           
            T0: begin 
                //load value in PC register (0) in MAR
                #5 PCout <= 1; 
					 #5 MARin <= 1;  //IncPC <= 1; Zin <= 1; used to inc PC by 4
            end
            T1: begin
                //Zlowout <= 1; PCin <= 1; 
                PCout <= 0;
                //MDR will grab value from ram @ address 0, this addess should contain instruction
                #5 Read <= 1; 
				#5 MDRin <= 1;
        
            end
            T2: begin
                Read <= 0;
                MARin <= 0;
                MDRin <= 0;
                //load MDR value to bus which contains instruction, instruction is then stored in IR
                MDRout<= 1; IRin <= 1; 
            end

            T3: begin 
                MDRout<= 0;
                IRin <= 0;
                Grb <= 1;
                //set to 1 to generate R1out = 1 and store value of R1 (5 hex) into Y register
                BAout <= 1;
                Yin <= 1; 
                #5 Grb <= 0; 
            end 
           
            T4: begin
				BAout <= 0;
                Yin <= 0; 
                //store C sign extended value on bus (should be 35 decimal)
                Cout <=1; 
                //perform add between 35/BuxMuxOut + R1 (5)/BuxMuxInY
				Operator <= 5'b00011;	
                //store result in Z register
                Zin <=1;

            end

            //read from ram
            T5: begin
				Cout <= 0;
                Zin <=0;

                //store Z register contents (85) in bus
                Zlowout <= 1;
                Gra <= 1;  //RA in Selectencode should be 0000 in binary
                Rin <= 1;	 
            
					 
            end
           

        endcase
    end
endmodule