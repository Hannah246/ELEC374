`timescale 1ns/10ps

module regTest; 

reg clk, clear,R0In;
reg [31:0] out;
wire [31:0] BusMuxInR0;

parameter   Default = 4'b0000, Reg_load2= 4'b0001, timeout = 500;
    reg[3:0] Present_state= Default;

register R0(clk, clear, R0In, out, BusMuxInR0);
 
initial begin
	clk = 0;
	forever #10 clk = ~clk; 
end 

always @(posedge clk)     //finite state machine; if clk rising-edge
    begin
        case (Present_state)
            Default  :   #40 Present_state = Reg_load2;
          
        endcase
    end
    always @ (Present_state);



always @(Present_state)     // do the required job ineach state
    begin
        case (Present_state)              //assert the required signals in each clk cycle
            Default: begin
                clear <= 0;
                R0In <= 1;
                out <= 32'b1;
            end
            Reg_load2: begin
                clear <= 0;
                R0In <= 1;
                out <= 32'b0;
            end
        endcase
    end
endmodule