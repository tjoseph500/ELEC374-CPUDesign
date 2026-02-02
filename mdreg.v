module mdr
(
	input clear, clock, enable, read,
	input [31:0]BusMuxOut,
	input [31:0]Mdatain,
	output wire [31:0]BusMuxIn
	
);
	wire mdrin;
	initial mdrIn = 32'h0;
	
	always @(posedge clock)begin
		
		if (read) begin
			mdrIn <= Mdatain;
		end
		else begin
			mdrIn <= BusMuxOut;
		end
		
	end
	
   Register register
	 (
		.clear(clear), 
		.clock(clock),
		.enable(enable),
		.mdrIn(BusMuxOut),
		.BusMuxIn(BusMuxIn)
    );
endmodule