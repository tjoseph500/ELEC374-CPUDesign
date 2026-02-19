//Subtract (2)
module subtract(A_sub, B_sub, Result_sub);

input [31:0] A_sub, B_sub;
output reg [63:0] Result_sub; 

reg [31:0] temp;

TwoCom twoCom
(
	.BSub(A_twoCom), 
	.temp(Result_twoCom),
);
	 
Adder adder
(
	.A_sub(A_add),
	.temp(B_add), 
	.Result_sub(Result_add),
);
endmodule
