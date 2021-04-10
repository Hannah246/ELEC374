`timescale 1ns/10ps

module cpu_tb; 

reg clock; 
reg reset; 
reg stop; 
reg run; 

initial begin
		reset <= 1; 
		stop <= 0; 
		#10 reset <= 0; 
		clock = 0;
		forever #10 clock = ~clock; 
end 

cpu cpu1(clock, reset, stop, run); 


endmodule