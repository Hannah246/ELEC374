module aluTest; 


reg Clock, clear;
reg [4:0] aluControl; 
reg [31:0] BusMuxInY, [31:0] BusMuxOut, [31:0] Zlowout, [31:0] Zhighout;
wire [31:0] Zlowout, Zhighout;
alu aluTest(clock, clear, aluControl, BusMuxInY, BusMuxOut, Zlowout, Zhighout);

initial 
    begin
        Clock = 0;
        forever #10 Clock = ~ Clock;
end


always @(posedge Clock)     //finite state machine; if clock rising-edge
    begin
        case (Present_state)
            Default  :   Present_state = Reg_load2;
          
        endcase
    end
    always @ (Present_state);



always @(Present_state)     // do the required job ineach state
    begin
        case (Present_state)              //assert the required signals in each clock cycle
            Default: begin
                clear <= 0;
                aluControl = 01001;
                BusMuxInY = 32'b1;
                BusMuxOut = 32'b0;
            end
            Reg_load2: begin
                clear <= 0;
                aluControl = 01001;
                BusMuxInY = 32'b1;
                BusMuxOut = 32'b0;
            end
        endcase
    end
endmodule