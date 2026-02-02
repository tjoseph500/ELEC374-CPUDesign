//TwoCom (1)
module twoCom(A_twoCom, Result_twoCom);

input [31:0] A_twoCom;
output [31:0] Result_twoCom; 

reg [31:0] Result_twoCom;
reg [31:0] temp;

integer i;

always@(A_twoCom)
	begin
	
end

OneCom OneCom
(
	.A_twoCom(A_oneCom), 
	.temp(Result_oneCom),
);
	 
Adder adder
(
	.temp(A_add),
	1’b1(B_add), 
	.Result_twoCom(Result_add),
);
endmodule
