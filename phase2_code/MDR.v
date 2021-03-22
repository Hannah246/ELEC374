module MDR( 
    input clk, clear, MDRin, read,  
    input [31:0] BusMuxOut,  
    input [31:0] Mdatain, 
    output [31:0] BusMuxInMDR 
);  

 

// Behavioral section for writing to the register  
reg [31:0] Din; 
reg [31:0] In; 
always @ (posedge clk) 
    begin 
        if (read) begin  
            Din <= Mdatain; 
        end 
        else begin 
            Din<= BusMuxOut; 
		end

        if(clear) begin 
            In <= 32'b0; 
        end 
        else if(MDRin) begin 
            In <= Din; 
        end 
    end 

    assign BusMuxInMDR = In; 

endmodule 