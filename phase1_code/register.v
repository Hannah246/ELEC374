module register(input clock, input clear, input enable, input [31:0] BusMuxOut, output [31:0] BusMuxIn);
	reg [31:0] q; 
	// Behavioral section for writing to the register 
	always @ ( posedge clock) 
		begin
			if(clear) begin
				q <= 32'b0;
			end
			else if(enable) begin 
				q <= BusMuxOut;
			end
		end	
	 
	assign BusMuxIn = q;	
			
endmodule