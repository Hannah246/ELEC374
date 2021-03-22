module MAR(input clock, input clear, input MARin, input [31:0] BusMuxOut, output [8:0] Address);

reg [31:0] q; 
	// Behavioral section for writing to the register 
	always @ ( posedge clock) 
		begin
			if(clear) begin
				q <= 32'b0;
			end
			else if(MARin) begin 
				q <= BusMuxOut;
			end
		end	
	 
	assign Address = q[8:0];	
			
endmodule