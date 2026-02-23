module CPU_G16(
    input wire clock, clear,
   
    // ALU result input (from your ALU modules)
    input wire [31:0] ALU,
   
    // Output control signals
    input wire R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out,
    input wire R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out,
    input wire HIout, LOout, Zhighout, Zlowout, PCout, MDRout, InPortout, Cout,
   
    // Input control signals
    input wire R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in,
    input wire R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in,
    input wire HIin, LOin, Zhighin, Zlowin, PCin, MDRin, InPortin, Cin, Yin,
	 //input wire IRin, MARin, //added?
   
    // ADD THESE MISSING SIGNALS (from testbench)
    input wire IncPC, Read, AND,
    input wire [31:0] Mdatain,
	 input wire IRin, MARin, Zin, //add Zin
   
    // ADD OUTPUTS so testbench can see results
    output wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7,
    output wire [31:0] R8, R9, R10, R11, R12, R13, R14, R15,
    output wire [31:0] HI, LO, PC, IR, MAR, MDR, Y,
    output wire [63:0] Z,
    output reg [31:0] BusMuxOut //reg/wire?
);

    // Internal wires for register outputs
    wire [31:0] BusMuxIn_R0, BusMuxIn_R1, BusMuxIn_R2, BusMuxIn_R3;
    wire [31:0] BusMuxIn_R4, BusMuxIn_R5, BusMuxIn_R6, BusMuxIn_R7;
    wire [31:0] BusMuxIn_R8, BusMuxIn_R9, BusMuxIn_R10, BusMuxIn_R11;
    wire [31:0] BusMuxIn_R12, BusMuxIn_R13, BusMuxIn_R14, BusMuxIn_R15;
    wire [31:0] BusMuxIn_HI, BusMuxIn_LO;
    wire [31:0] BusMuxIn_Zhigh, BusMuxIn_Zlow;
    wire [31:0] BusMuxIn_PC, BusMuxIn_MDR, BusMuxIn_IR, BusMuxIn_MAR;
    wire [31:0] BusMuxIn_Y, BusMuxIn_InPort;
    wire [31:0] C_sign_extended;
   
    // Additional internal wires
    wire [31:0] PC_out, PC_plus1;
    reg [31:0] MDR_out; //wire/reg?
    wire [31:0] Y_out;
    wire [31:0] ZHigh_out, ZLow_out;
   
    // PC increment logic
    assign PC_plus1 = PC_out + 1;
   
    // Connect outputs for testbench
    assign R0 = BusMuxIn_R0;
    assign R1 = BusMuxIn_R1;
    assign R2 = BusMuxIn_R2;
    assign R3 = BusMuxIn_R3;
    assign R4 = BusMuxIn_R4;
    assign R5 = BusMuxIn_R5;
    assign R6 = BusMuxIn_R6;
    assign R7 = BusMuxIn_R7;
    assign R8 = BusMuxIn_R8;
    assign R9 = BusMuxIn_R9;
    assign R10 = BusMuxIn_R10;
    assign R11 = BusMuxIn_R11;
    assign R12 = BusMuxIn_R12;
    assign R13 = BusMuxIn_R13;
    assign R14 = BusMuxIn_R14;
    assign R15 = BusMuxIn_R15;
    assign HI = BusMuxIn_HI;
    assign LO = BusMuxIn_LO;
    assign PC = PC_out;
    assign Y = Y_out;
    assign Z = {ZHigh_out, ZLow_out};
   
    // --- BUS MULTIPLEXER (choose which register drives the bus) ---
    always @(*) begin
        BusMuxOut = 32'b0;
       
        if (R0out) BusMuxOut = BusMuxIn_R0;
        else if (R1out) BusMuxOut = BusMuxIn_R1;
        else if (R2out) BusMuxOut = BusMuxIn_R2;
        else if (R3out) BusMuxOut = BusMuxIn_R3;
        else if (R4out) BusMuxOut = BusMuxIn_R4;
        else if (R5out) BusMuxOut = BusMuxIn_R5;
        else if (R6out) BusMuxOut = BusMuxIn_R6;
        else if (R7out) BusMuxOut = BusMuxIn_R7;
        else if (R8out) BusMuxOut = BusMuxIn_R8;
        else if (R9out) BusMuxOut = BusMuxIn_R9;
        else if (R10out) BusMuxOut = BusMuxIn_R10;
        else if (R11out) BusMuxOut = BusMuxIn_R11;
        else if (R12out) BusMuxOut = BusMuxIn_R12;
        else if (R13out) BusMuxOut = BusMuxIn_R13;
        else if (R14out) BusMuxOut = BusMuxIn_R14;
        else if (R15out) BusMuxOut = BusMuxIn_R15;
        else if (HIout) BusMuxOut = BusMuxIn_HI;
        else if (LOout) BusMuxOut = BusMuxIn_LO;
        else if (Zhighout) BusMuxOut = ZHigh_out;
        else if (Zlowout) BusMuxOut = ZLow_out;
        else if (PCout) BusMuxOut = PC_out;
        else if (MDRout) BusMuxOut = MDR_out;
        else if (InPortout) BusMuxOut = BusMuxIn_InPort;
        else if (Cout) BusMuxOut = C_sign_extended;
    end
   
    // --- REGISTERS (using your register module) ---
   
    // General purpose registers
    register #(32,32,32'h0) R0_reg(clear, clock, R0in, BusMuxOut, BusMuxIn_R0);
    register #(32,32,32'h0) R1_reg(clear, clock, R1in, BusMuxOut, BusMuxIn_R1);
    register #(32,32,32'h0) R2_reg(clear, clock, R2in, BusMuxOut, BusMuxIn_R2);
    register #(32,32,32'h0) R3_reg(clear, clock, R3in, BusMuxOut, BusMuxIn_R3);
    register #(32,32,32'h0) R4_reg(clear, clock, R4in, BusMuxOut, BusMuxIn_R4);
    register #(32,32,32'h0) R5_reg(clear, clock, R5in, BusMuxOut, BusMuxIn_R5);
    register #(32,32,32'h0) R6_reg(clear, clock, R6in, BusMuxOut, BusMuxIn_R6);
    register #(32,32,32'h0) R7_reg(clear, clock, R7in, BusMuxOut, BusMuxIn_R7);
    register #(32,32,32'h0) R8_reg(clear, clock, R8in, BusMuxOut, BusMuxIn_R8);
    register #(32,32,32'h0) R9_reg(clear, clock, R9in, BusMuxOut, BusMuxIn_R9);
    register #(32,32,32'h0) R10_reg(clear, clock, R10in, BusMuxOut, BusMuxIn_R10);
    register #(32,32,32'h0) R11_reg(clear, clock, R11in, BusMuxOut, BusMuxIn_R11);
    register #(32,32,32'h0) R12_reg(clear, clock, R12in, BusMuxOut, BusMuxIn_R12);
    register #(32,32,32'h0) R13_reg(clear, clock, R13in, BusMuxOut, BusMuxIn_R13);
    register #(32,32,32'h0) R14_reg(clear, clock, R14in, BusMuxOut, BusMuxIn_R14);
    register #(32,32,32'h0) R15_reg(clear, clock, R15in, BusMuxOut, BusMuxIn_R15);
   
    // Special registers
    register #(32,32,32'h0) HI_reg(clear, clock, HIin, BusMuxOut, BusMuxIn_HI);
    register #(32,32,32'h0) LO_reg(clear, clock, LOin, BusMuxOut, BusMuxIn_LO);
   
    // Y register - output goes to ALU
    register #(32,32,32'h0) Y_reg(clear, clock, Yin, BusMuxOut, Y_out);
   
    // PC register with increment
    wire PC_input = IncPC ? PC_plus1 : BusMuxOut;
    register #(32,32,32'h0) PC_reg(clear, clock, PCin, PC_input, PC_out);
   
    // IR and MAR registers
    register #(32,32,32'h0) IR_reg(clear, clock, IRin, BusMuxOut, IR);
    register #(32,32,32'h0) MAR_reg(clear, clock, MARin, BusMuxOut, MAR);
   
    // Z register (64-bit using two 32-bit registers)
    wire [31:0] Z_high_in, Z_low_in;
   
    // For now, using ALU input as result (you'll connect your actual ALU modules here)
    assign Z_low_in = ALU;      // Lower 32 bits from ALU
    assign Z_high_in = 32'b0;   // Upper 32 bits (for mul/div results)
   
    register #(32,32,32'h0) ZHigh_reg(clear, clock, Zhighin, Z_high_in, ZHigh_out);
    register #(32,32,32'h0) ZLow_reg(clear, clock, Zlowin, Z_low_in, ZLow_out);
   
    // MDR register (special - needs Mdatain)
    always @(posedge clock or posedge clear) begin
        if (clear)
            MDR_out <= 32'b0;
        else if (MDRin) begin
            if (Read)
                MDR_out <= Mdatain;  // From memory
            else
                MDR_out <= BusMuxOut; // From bus
        end
    end
    assign MDR = MDR_out;
   
    // InPort register (for I/O - Phase 2)
    register #(32,32,32'h0) InPort_reg(clear, clock, InPortin, BusMuxOut, BusMuxIn_InPort);

endmodule