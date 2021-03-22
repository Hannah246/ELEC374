`timescale 1ns/10ps

module mdr_tb; 
    reg PCout, Zlowout, MDRout, R2out, R4out;// add any other signals to see in your simulation
    reg MARin, Zin, PCin, MDRin, IRin, Yin;
    reg IncPC,Read, R5in, R2in, R4in;
	 reg [4:0] Operator;
    reg Clock;
    reg clear;
    reg [31:0] Mdatain;
    wire [31:0] BusMuxOut;
    wire [31:0] BusMuxInMDR;

    parameter   Default = 4'b0000, Reg_load1a= 4'b0001, Reg_load1b= 4'b0010, Reg_load2a= 4'b0011, 
                Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0= 4'b0111, 
                T1= 4'b1000,T2= 4'b1001, T3= 4'b1010, T4= 4'b1011, T5= 4'b1100;
    reg[3:0] Present_state= Default;

MDR MDR1(Clock, clear, MDRin, Read, BusMuxOut, Mdatain, BusMuxInMDR); 

// add test logic here
 
// use the clock from the lab doc
initial begin
	Clock = 0;
	forever #10 Clock = ~ Clock; 
end 



always @(posedge Clock)     //finite state machine; if clock rising-edge
    begin
        case (Present_state)
            Default     :   #40 Present_state = Reg_load1a;
        endcase
    end
    
always @(Present_state)     // do the required job ineach state
    begin
        case (Present_state)              //assert the required signals in each clock cycle
            Default: begin
//                PCout <= 0;   Zlowout <= 0;   MDRout<= 0;   //initialize the signals
//                R2out <= 0;   R4out <= 0;   MARin <= 0;   Zin <= 0;  
//                PCin <=0;   MDRin <= 0;   IRin  <= 0;   Yin <= 0;  
//                IncPC <= 0;  
// 				   Operator <= 5'b00000;
//                R5in <= 0; 
//					 R2in <= 0; 
//					 R4in <= 0; 
					 Read <= 0;  clear <= 0; 
					 MDRin <= 0;	
					 Mdatain <= 32'h00000000;
            end
            Reg_load1a: begin
                Mdatain<= 32'h00000022;
                // Read = 0; 
					 MDRin = 0;				//the first zero is there for completeness
                #10 Read <= 1; MDRin <= 1;  
                // #15 Read <= 0; MDRin <= 0;
                

            end
			endcase
    end
endmodule