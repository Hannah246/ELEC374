// make tbs for:
// ALU immediate instructions: addi, andi, ori
// branch instructions: brzr, brnz, brpl, brmi 
// Op-code: 31-27, Ra: 26-23, C2: 22-19, C: 18-0
// brzr: 0108 0023, C2: 0001
// 0 0000, 0010, 0001, 000 0000 0000 0010 0011
// brnz: 0110 0023, C2: 0010
// 0 0000, 0010, 0010, 000 0000 0000 0010 0011
// brpl: 0120 0023, C2: 0100
// brmi: 0140 0023, C2: 1000

`timescale 1ns/10ps

module branch_tb; 
    reg PCout, Zlowout, MDRout, R2out, R4out;// add any other signals to see in your simulation
    reg MARin, Zin, PCin, MDRin, IRin, Yin;
    reg Read;
  	 reg [4:0] Operator;
    reg clk;
	 reg clear, Write; 
    reg Gra, Grb, Grc, Rin, Rout, BAout, Cout;
	 reg ConIn; 

    parameter   Default = 4'b0000, T0= 4'b0111, T1= 4'b1000, T2= 4'b1001, T3= 4'b1010, T4= 4'b1011, T5= 4'b1100, T6= 4'b1101;
    reg[3:0] Present_state= Default;

DataPath DUT(PCout, Zlowout, MDRout, MARin, Zin, PCin, MDRin, IRin, Yin, Read, Write, Operator, clk, clear, 
Gra, Grb, Grc, Rin, Rout, BAout, Cout, ConIn);

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
            T5          :   #40 Present_state = T6;
        endcase
    end

always @(Present_state)     // do the required job ineach state
    begin
        case (Present_state)              //assert the required signals in each clk cycle
            Default: begin
                PCout <= 0;   Zlowout <= 0;   MDRout<= 0;   //initialize the signals
                MARin <= 0;   Zin <= 0;  
                PCin <=0;   MDRin <= 0;   IRin  <= 0;   Yin <= 0;  
                // incPC <= 0;   
					 Read <= 0;   Operator <= 5'b00000;
                Gra<= 0; Grb<= 0; Grc<= 0; Rin<= 0; Rout<= 0; BAout<= 0; Cout<=0;
                // clear <= 1; //initialize registers to 0
					 //#10 clear <= 0; 
            end
           
            T0: begin 
                //load value in PC register (0) in MAR
                #5 PCout <= 1; 
					 #5 MARin <= 1;  //IncPC <= 1; Zin <= 1; used to inc PC by 4
                // incPC <= 1; 
					 // Zin <= 1;
            end
            T1: begin
                // Zlowout <= 1; PCin <= 1; 
                PCout <= 0;
                //MDR will grab value from ram @ address 0, this addess should contain instruction
                #5 Read <= 1; // Mdatain <= 1; 
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
                
                Gra <= 1;
                Rout <= 1; 
                ConIn <= 1; 
                //set to 1 to generate R0out = 1 and store value of R0 (0) into Y register
					 #5 Gra <= 0; 
            end 
           
            T4: begin
					 Rout <= 0; 
					 ConIn <= 0; 
                
                PCout <= 1; Yin <= 1; 
            end

            T5: begin
                PCout <= 0; Yin <= 0; 

					 Cout <= 1;
                Operator <= 5'b00011; // ADD
					 Zin <= 1; 

                // store Z register contents (85) in bus
                // Zlowout <= 1;
                // load 85/busMuxOut into MAR to get address of 85
                // MARin <= 1;
            end
            
            T6: begin
               Cout <= 0; 
               Zin <= 0; 

               Zlowout <= 1;
               // PC <= Con; 
               // read from ram at address 85 and load that value in MDR -> we will need to have a preset value in memory at address 85
				   // Read <= 1; 
               // MDRin <= 1;
					 
            end
            
        endcase
    end
endmodule