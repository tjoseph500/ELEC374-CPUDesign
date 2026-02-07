//TwoCom (1)
module twoCom(
input [31:0] A_twoCom,
output [31:0] Result_twoCom
);

reg [31:0] temp;
assign const_1 = 1'b1;

OneCom OneCom
(
	.A_twoCom(A_oneCom), 
	.temp(Result_oneCom),
);
	 
Adder adder
(
	.temp(A_add),
	.const_1(B_add), 
	.Result_twoCom(Result_add),
);
endmodule
