//Divider
module divider(
    input  [31:0] M,      // Divisor
    input  [31:0] Q,      // Dividend
    output reg [63:0] Result  // {Remainder, Quotient}
);

reg [32:0] A;

integer i;

always@(M or Q)
begin
	A = 33'd0;
	Result=Q;
	for(i=0; i<32; i=i+1)
	begin
		Result=Result<<1;
		A=A<<1;
		A=A-M;
		if(A<0)
		begin
			Result[0]=0;
			A=A+M;
		end
		else
		begin
			Result[0]=1;
		end
	end
	Result = {A[32:0], Q_temp};
end
endmodule
a
