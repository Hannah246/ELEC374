module BoothMulti(input [4:0] aluControl, input [31:0] BusMuxOut, input [31:0] Yout, input clock, output Cout, output busy); 

    reg [31:0] A, Q, M; 
    reg Q_1; 
    reg [31:0] count; 
    wire [31:0] sum, difference; 
    
    always @ (posedge clock) begin 

        if (Present_state) begin 
             
            A <= 32'b0
            M <= mc; 
            Q <= mp; 
            Q_1 <= 1'b0; 
            count <= 32'b0; 

        end 
        else begin 
            case ({Q[0], Q_1})
                2'b0_1 : {A, Q, Q_1} <= {sum[31], sum, Q}; 
                2'b1_0 : {A, Q, Q_1} <= {difference[31], difference, Q}; 
                default : {A, Q, Q_1} <= {A[31], A, Q}; 
            endcase 
        count <= count + 1'b1; 
        end 
    end 

    COut = A + M + 1'b0; // adder 
    COut = Q - M + 1'b1; // substracter
    assign COut =  {A, Q}; // product 
    assign busy = (count < 32); 

endmodule; 
