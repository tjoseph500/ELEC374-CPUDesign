module Bus (
	//Muxinput [31 :0]BusMuxIn-R2,
	input [31:0]BusMuxIn-R0, input [31:0]BusMuxIn-R1, input [31 :0]BusMuxIn-R2,input [31 :0]BusMuxIn-R3,input [31 :0]BusMuxIn-R4,input [31 :0]BusMuxIn-R5,input [31 :0]BusMuxIn-R6,input [31 :0]BusMuxIn-R7, input [31 :0]BusMuxIn-R8, input [31 :0]BusMuxIn-R9, input [31 :0]BusMuxIn-R10, input [31 :0]BusMuxIn-R11, input [31 :0]BusMuxIn-R12, input [31 :0]BusMuxIn-R13, input [31 :0]BusMuxIn-R14, input [31 :0]BusMuxIn-R15, input [31 :0]BusMuxIn-HI, input [31 :0]BusMuxIn-LO, input [31 :0]BusMuxIn-Zhigh, input [31 :0]BusMuxIn-Zlow, input [31 :0]BusMuxIn-PC, input [31 :0]BusMuxIn-MDR, input [31 :0]BusMuxIn_In.Port, input [31 :0]C_sign_extended
	//Encoder
	input R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out, HIout, LOout, Zhighout, Zlowout, PCout, MDRout, In.Portout, Cout,
	
	output wire [31:0] BusMuxOut
);

reg [31:0]q;

always @ (*) begin
	if(R0out) q = BusMuxIn-R0;
	if(R1out) q = BusMuxIn-R1;
	if(R2out) q = BusMuxIn-R2;
	if(R3out) q = BusMuxIn-R3;
	if(R4out) q = BusMuxIn-R4;
	if(R5out) q = BusMuxIn-R5;
	if(R6out) q = BusMuxIn-R6;
	if(R7out) q = BusMuxIn-R7;
	if(R8out) q = BusMuxIn-R8;
	if(R9out) q = BusMuxIn-R9;
	if(R10out) q = BusMuxIn-R10;
	if(R11out) q = BusMuxIn-R11;
	if(R12out) q = BusMuxIn-R12;
	if(R13out) q = BusMuxIn-R13;
	if(R14out) q = BusMuxIn-R14;
	if(R15out) q = BusMuxIn-R15;
	if(HIout) q = BusMuxIn-HI;
	if(LOout) q = BusMuxIn-LO;
	if(Zhighout) q = BusMuxIn-Zhigh;
	if(Zlowout) q = BusMuxIn-Zlow;
	if(PCout) q = BusMuxIn-PC;
	if(MDRout) q = BusMuxIn-MDR;
	if(In.Portout) q = BusMuxIn_In.Port;
	if(Cout) q = C_sign_extended;
	
end
assign BusMuxOut = q;
endmodule 

