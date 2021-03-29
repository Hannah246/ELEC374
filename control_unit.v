`timescale 1ns/10ps
//do we need to create new file for both control and datapath
//need to define clock, reset, stop, con_FF
//Stop->how do we halt?, Run-> 1 (do we need if statement to set state to fetch0), Reset ->clear =1, initialize everything to 0
//if stop=1, run =0 stop clk
module control_unit( 
    output reg PCout, Zlowout, MDRout, IncPC, 
    MARin, Zin, PCin, MDRin, IRin, Yin,
    Read, Write, clear,
    Gra, Grb, Grc, Rin, Rout, BAout, Cout, ConIn, HIout, RoutPIn,
	output reg [4:0] aluControl,
    input clk, reset, CONFF, 
	input [31:0] IR
);

    parameter Reset_state = 6'b000000, fetch0 = 6'b000001, fetch1 = 6'b000010, 
        fetch2 = 6'b000011, addi3 = 6'b000100, addi4 = 6'b000101, addi5 = 6'b000110, load3 = 6'b000111, load4 = 6'b001000, 
		  load5 = 6'b001001, load6 = 6'b001010, load7 = 6'b001011, loadi3 = 6'b001100, loadi4 = 6'b001101, loadi5 = 6'b001110, 
        store3 = 6'b001111, store4 = 6'b010000, store5 = 6'b010001, store6 = 6'b010010, alu3 = 6'b010011, alu4 = 6'b010100, alu5 = 6'b010101, 
        alureg3 = 6'b010110, alureg4 = 6'b010111, alureg5 = 6'b011000, muldiv3 = 6'b011001, muldiv4 = 6'b011010, muldiv5 = 6'b011011, 
        andi3 = 6'b011100, andi4 = 6'b011101, andi5 = 6'b011110, ori3 = 6'b011111, ori4 = 6'b100000, ori5 = 6'b100001, 
        branch3 = 6'b100010, branch4 = 6'b100011, branch5 = 6'b100100, branch6 = 6'b100101, 
        jump3 = 6'b100110, mfhilo3 = 6'b100111, inout3 = 6'b101000; 
    reg [5:0] Present_state = Reset_state; 
	 //reg [4:0] aluCode; 
	 

always @ (posedge clk, posedge reset) 
    begin 
        aluControl = IR[31:27]; 
        if (reset == 1'b1) Present_state = Reset_state; 
        else case (Present_state) 
            Reset_state     :   #40 Present_state = fetch0; 
            fetch0          :   #40 Present_state = fetch1; 
            fetch1          :   #40 Present_state = fetch2; 
            fetch2          :   begin
                                    case(aluControl) 
                                        5'b00000     :   #40 Present_state = load3;
                                        5'b00001     :   #40 Present_state = loadi3;
                                        5'b00010     :   #40 Present_state = store3;
                                        5'b00011     :   #40 Present_state = alu3;
                                        5'b00100     :   #40 Present_state = alu3;
                                        5'b00101     :   #40 Present_state = alu3;
                                        5'b00110     :   #40 Present_state = alu3;
                                        5'b00111     :   #40 Present_state = alu3;
                                        5'b01000     :   #40 Present_state = alu3;
                                        5'b01001     :   #40 Present_state = alu3;
                                        5'b01010     :   #40 Present_state = alu3;
													 5'b01011	  :   #40 Present_state = addi3; //addi
													 5'b01100	  : 	#40 Present_state = andi3; //andi 
													 5'b01101	  : 	#40 Present_state = ori3; //ori
													 
 
                                        5'b01110     :   #40 Present_state = muldiv3;
                                        5'b01111     :   #40 Present_state = muldiv3;
                                        5'b10000     :   #40 Present_state = alureg3;
                                        5'b10001     :   #40 Present_state = alureg3;
													 5'b10010 	  :   #40 Present_state = branch3; 

                                        5'b10011     :   #40 Present_state = jump3; //jr
                                        5'b10100     :   #40 Present_state = jump3; //jal
                                        5'b10011     :   #40 Present_state = inout3; //in 
                                        5'b10110     :   #40 Present_state = inout3; //out 
                                        5'b10111     :   #40 Present_state = mfhilo3; //mfhi
                                        5'b10100     :   #40 Present_state = mfhilo3; //mflo


                                    endcase
                                end   

            //any alu related operations with three registers
            alu3            :   #40 Present_state = alu4; 
            alu4            :   #40 Present_state = alu5; 

            //any alu related operations with two registers (not/neg)
            alureg3         :   #40 Present_state = alureg4; 
            alureg4         :   #40 Present_state = alureg5; 
            
            //mul and div
            muldiv3         :   #40 Present_state = muldiv4; 
            muldiv4         :   #40 Present_state = muldiv5; 
            
            //addi         
            addi3            :   #40 Present_state = addi4; 
            addi4            :   #40 Present_state = addi5; 
            
            //load
            load3           :   #40 Present_state = load4; 
            load4           :   #40 Present_state = load5; 
            load5           :   #40 Present_state = load6; 
            load6           :   #40 Present_state = load7; 
            
            //load immediate
            loadi3           :   #40 Present_state = loadi4; 
            loadi4           :   #40 Present_state = loadi5; 
            
            //store
            store3           :   #40 Present_state = store4; 
            store4           :   #40 Present_state = store5; 
            store5           :   #40 Present_state = store6;

            //andi
            andi3            :   #40 Present_state = andi4; 
            andi4            :   #40 Present_state = andi5; 

            //ori 
            ori3            :   #40 Present_state = ori4; 
            ori4            :   #40 Present_state = ori5; 

            //branch 
            branch3         :   #40 Present_state = branch4; 
            branch4         :   #40 Present_state = branch5; 
            branch5         :   #40 Present_state = branch6; 

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

            //fetch instruction
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
				MDRout<= 1; 
				IRin <= 1; 
			 end
			 
             //alu three reg
            alu3:begin
				MDRout<= 0; 
				IRin <= 0;
				Grb <= 1;
				BAout <= 1;
				Yin <= 1; 
				#5 Grb <= 0; 
			 end
			 
			 alu4:begin
                 Yin <= 0; 
                 Grc <= 1;
				 BAout <= 1;   
				 #5 Zin <=1;
                 #10 Grc <= 0; 
			 end
			 
			 alu5:begin
                BAout <= 0;
				Zin <=0;
				Zlowout <= 1;
				Gra <= 1;  
				Rin <= 1;
			 end

            //alu two reg
            alureg3:begin
				MDRout<= 0; 
				IRin <= 0;
				Grb <= 1;
				BAout <= 1;
				Yin <= 1; 
				#5 Grb <= 0; 
			 end
			 
			alureg4:begin
                BAout <= 0;
				Yin <=0; 
                Zin <= 1;
			 end
			 
			 alureg5:begin
				Zin <=0;
				Zlowout <= 1;
				Gra <= 1;  
				Rin <= 1;
			 end
            
            //muldiv
            muldiv3:begin
				MDRout<= 0; 
				IRin <= 0;
				Gra <= 1;
				BAout <= 1;
				Yin <= 1; 
				#5 Gra <= 0; 
			 end

             muldiv4:begin
				 Yin <= 0; 
                 Grb <= 1;
				 BAout <= 1;   
				 #5 Zin <=1;
                 #10 Grb<=0;
			 end

              muldiv5:begin
				Zlowout <= 1;
                //LOout <= 1;
               //#5 Zhighout < =1;
               //#5 Hiout <= 1;
			 end



             //addi
			 addi3:begin
				MDRout<= 0; 
				IRin <= 0;
				Grb <= 1;
				BAout <= 1;
				Yin <= 1; 
				#5 Grb <= 0; 
			 end
			 
			 addi4:begin
				 BAout <= 0;
				 Yin <= 0; 
				 Cout <=1; 
             //aluCode <= 5'b00011;
				 Zin <=1;
			 end
			 
			 addi5:begin
				Cout <= 0;
				Zin <=0;
				Zlowout <= 1;
				Gra <= 1;  
				Rin <= 1;
			 end

             //load
			 load3:begin
			    MDRout<= 0;
                IRin <= 0;
                Grb <= 1;
                BAout <= 1;
                Yin <= 1; 
				#5 Grb <= 0;	  

			 end

			 load4:begin
			    BAout <= 0;
                Yin <= 0; 
                Cout <=1; 
                //aluCode <= 5'b00011;
                Zin <=1;	  

			 end
             load5:begin
			  	Cout <= 0;
                Zin <=0;
                Zlowout <= 1;
                MARin <= 1;    

			 end

             load6:begin
			   Zlowout <=0;
               MARin<=0;
               Read <= 1; 
               MDRin <= 1;
					 

			 end
             load7:begin
			   Read <= 0; 
               MDRin <= 0;
			   MDRout <= 1;
               Gra <= 1;  
               Rin <= 1;	    

			 end

             //load immediate
             loadi3:begin
                MDRout<= 0;
                IRin <= 0;
                Grb <= 1;
                BAout <= 1;
                Yin <= 1; 
                #5 Grb <= 0; 

             end

             loadi4:begin
                BAout <= 0;
                Yin <= 0; 
                Cout <=1; 
					 //aluCode <= 5'b00011;	
                Zin <=1;

             end

             loadi5:begin
		        Cout <= 0;
                Zin <=0;
                Zlowout <= 1;
                Gra <= 1;  
                Rin <= 1;

             end

             //store
            store3:begin
		        MDRout<= 0;
                IRin <= 0;
                Gra <= 1;
                BAout <= 1;
                Yin <= 1; 
                #5 Gra <= 0; 
             end
            store4:begin
		       BAout <= 0;
               Yin <= 0; 
               Cout <=1; 
			   //aluCode <= 5'b00011;	
               Zin <=1;
            end
            store5:begin
		      Cout <= 0;
              Zin <=0;
              Zlowout <= 1;
              MARin <= 1;
            end
            store6:begin
		       Zlowout <=0;
               MARin<=0;
               Grb <= 1;  
               BAout <= 1;
               MDRin <= 1; 
               #10 Write <=1;
            end

            // and immediate 
            andi3: begin 
                MDRout<= 0;
                IRin <= 0;
                Grb <= 1;
                Rout <= 1; 
                Yin <= 1; 
			    #5 Grb <= 0; 
            end 
            andi4: begin 
                Rout <= 0;
                Yin <= 0; 
                Cout <= 1; 
				//aluCode <= 5'b01001; 
                Zin <=1;
            end 
            andi5: begin 
                Cout <= 0;
                Zin <=0;
                Zlowout <= 1;
                Gra <= 1; 
                Rin <= 1;
            end 

            //or immediate 
            ori3: begin 
                MDRout<= 0;
                IRin <= 0;
                Grb <= 1;
                Rout <= 1; 
                Yin <= 1; 
				#5 Grb <= 0; 
            end
            ori4: begin 
                Rout <= 0;
                Yin <= 0; 
                Cout <= 1; 
					 //aluCode <= 5'b01010; // Or 
                Zin <=1;
            end  
            ori5: begin 
                Cout <= 0;
                Zin <= 0;
                Zlowout <= 1;
                Gra <= 1; 
                Rin <= 1;
            end 

            //branch 
            branch3: begin 
                MDRout<= 0;
                IRin <= 0;
                Gra <= 1;
                Rout <= 1; 
                ConIn <= 1; 
				#5 Gra <= 0; 
            end 
            branch4: begin 
                Rout <= 0; 
				ConIn <= 0; 
                PCout <= 1; 
                Yin <= 1; 
            end 
            branch5: begin 
                PCout <= 0; Yin <= 0; 
                Cout <= 1;
                //aluCode <= 5'b00011; // ADD
					 Zin <= 1; 
            end 
            branch6: begin 
                Cout <= 0; 
                Zin <= 0; 
                Zlowout <= 1;
            end 

            //jump 
            jump3: begin 
                MDRout <= 0; 
				IRin <= 0; 
                Gra <= 1;
                Rout <= 1;
                PCin <= 1;
				BAout <= 1; 
            end 

            //mfhilo 
            mfhilo3: begin 
                MDRout <= 0; 
				IRin <= 0; 
                Read <= 0; 
                MDRin <= 0;
				HIout <= 1;
                Gra <= 1;  
                Rin <= 1;
            end 

            //inout 
            inout3: begin 
                MDRout <= 0; 
					IRin <= 0; 
                Gra <= 1;
                Rout <= 1;
                RoutPIn <= 1;
            end 

		endcase
		
end
endmodule