

module registerR0(input clock, input clear, input enable,input BAout, input [31:0] BusMuxOut, output [31:0] BusMuxIn);
	reg [31:0] q; 
	reg [31:0] out;
	reg test; 
	integer i;
	// Behavioral section for writing to the register 
	always @ ( posedge clock) 
		begin
			if(clear) begin
				q <= 32'b0;
				test <= 1; 
			end
			else if(enable) begin 
				q <= BusMuxOut;
			end
			for (i = 0 ; i < 32 ; i = i + 1)
       			out[i] = q[i] & !BAout;
		end	

	// and each bit with BAout notted
	
	    assign BusMuxIn = out;	
			
endmodule