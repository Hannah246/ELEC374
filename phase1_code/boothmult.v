module boothmult(result, X, Y);

output [32*2-1:0] result;
input signed [31:0] X, Y;

	reg [2:0] cc[(32 / 2)-1:0];
	reg [32:0] pp[(32 / 2)-1:0];
	reg [32*2-1:0] spp[(32 / 2)-1:0];
	reg [32*2-1:0] product;
	wire [32:0] inv_X;
	integer k,i;

	assign inv_X = {~X[31], ~X} + 1;

	always @ (X or Y or inv_X)
	begin
		cc[0] = {Y[1],Y[0],1'b0};

		for(k=1;k<(32 / 2);k=k+1)
			cc[k] = {Y[2*k+1], Y[2*k], Y[2*k-1]};

		for(k=0;k<(32 / 2);k=k+1)
		begin
			case(cc[k])
				3'b001 , 3'b010 : pp[k] = {X[32-1],X};
				3'b011 : pp[k] = {X,1'b0};
				3'b100 : pp[k] = {inv_X[32-1:0],1'b0};
				3'b101 , 3'b110 : pp[k] = inv_X;
				default : pp[k] = 0;
			endcase

			spp[k] = $signed(pp[k]);

			for(i=0;i<k;i=i+1)
				spp[k] = {spp[k],2'b00}; // multiply by 2 to the power x or shifting operation
		end

		product = spp[0];

		for(k=1;k<(32 / 2);k=k+1)
			product = product + spp[k];
	end

	assign result = product;

endmodule