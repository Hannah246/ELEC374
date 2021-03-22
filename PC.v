module pc #(parameter VAL = 0)(
	input clock, 
	input clear, 
	input enable, 
	input incPC, 
	input branch
	input [31:0] BusMuxOut, 
	output [31:0] BusMuxIn
);

reg [31:0] q; 
initial q = VAL;

	// Behavioral section for writing to the register 
	always @ (posedge clock) 
		begin
			if(clear) begin
				q <= 32'b0;
			end
			else if(enable) begin 
				q <= BusMuxOut;
			end
			else if(incPC) begin
				q <= q + 1;
			end
			else if(branch) begin 
				q <= q + BusMuxOut; 
			end
		end	
	 
	assign BusMuxIn = q;	
			
endmodule
