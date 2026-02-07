// Booth Multiplier
module booth_multiplier (
    input [31:0] M,         
    input [31:0] Q,        
    output reg [63:0] Result
);

    integer i;
    reg [32:0] M_2;
	 reg [32:0] M_Neg2;
    reg [31:0] M_Neg1;
	 reg [63:0] temp;
	 	 
	 assign const_1 = 1'b1;
    wire [32:0] Q_Implicit;
    assign Q_Implicit = Q<<1;	 
	 
	 shiftLeft shiftMX2 (.M(A), .const_1(B), .M_2(Result));
	 shiftLeft shiftXNeg2 (.M(A), .const_1(B), .M_Neg2(Result));
	 shiftLeft shiftXNeg1 (.M(A), .const_1(B), .M_Neg1(Result));
	 
	TwoCom twoComNeg1(.M_Neg1(A_twoCom), .M_Neg1(Result_twoCom));
	TwoCom twoComNeg2(.M_Neg2(A_twoCom), .M_Neg2(Result_twoCom));

    always @(M or Q)
	 begin       
        for (i = 1; i < 32; i = i + 2)
		  begin
				if(Q_Implicit[i+1]==1&&Q_Implicit[i]==0&&Q_Implicit[i-1]==0)
				begin
					//Case -2
					temp<=M_Neg2<<i;
					Result<=temp+Result;
				end
				else if(Q_Implicit[i+1]==0&&Q_Implicit[i]==0&&Q_Implicit[i-1]==1||Q_Implicit[i+1]==0&&Q_Implicit[i]==1&&Q_Implicit[i-1]==0)
				begin
					//Case 1
					temp<=M<<i;
					Result<=temp+Result;
				end
				else if(Q_Implicit[i+1]==1&&Q_Implicit[i]==0&&Q_Implicit[i-1]==1||Q_Implicit[i+1]==1&&Q_Implicit[i]==1&&Q_Implicit[i-1]==0)
				begin
					//Case -1
					temp<=M_Neg1<<i;
					Result<=temp+Result;
				end
				else if(Q_Implicit[i+1]==0&&Q_Implicit[i]==1&&Q_Implicit[i-1]==1)
				begin
					//Case +2
					temp<=M_2<<i;
					Result<=temp+Result;
				end
				else 
				begin
					//Case 0
				end
		  
        end
    end
	 
endmodule