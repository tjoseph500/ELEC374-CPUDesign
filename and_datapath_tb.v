`timescale 1ns/10ps

module datapath_tb;
   
    // Control signals
    reg PCout, Zlowout, MDRout, R5out, R6out;          
    reg MARin, Zin, PCin, MDRin, IRin, Yin;    
    reg IncPC, Read, AND, R2in, R5in, R6in;
    reg Clock;
    reg [31:0] Mdatain;
   
    // Add these missing signals (referenced in Default state)
    reg R3out, R7out;
   
    // State parameters
    parameter Default     = 4'b0000,
              Reg_load1a  = 4'b0001,
              Reg_load1b  = 4'b0010,
              Reg_load2a  = 4'b0011,  
              Reg_load2b  = 4'b0100,
              Reg_load3a  = 4'b0101,
              Reg_load3b  = 4'b0110,
              T0          = 4'b0111,  
              T1          = 4'b1000,
              T2          = 4'b1001,
              T3          = 4'b1010,
              T4          = 4'b1011,
              T5          = 4'b1100;
   
    reg [3:0] Present_state = Default;
   
    // Device Under Test - using your CPU_G16 module
    CPU_G16 DUT (
        .clock(Clock),
        .clear(1'b0),  // No clear during test
       
        // ALU input (you'll connect this to your ALU modules)
        .ALU(32'b0),
       
        // Output control signals
        .PCout(PCout),
        .Zlowout(Zlowout),
        .MDRout(MDRout),
        .R5out(R5out),
        .R6out(R6out),
        .R0out(1'b0), .R1out(1'b0), .R2out(1'b0), .R3out(1'b0), .R4out(1'b0),
        .R7out(1'b0), .R8out(1'b0), .R9out(1'b0), .R10out(1'b0), .R11out(1'b0),
        .R12out(1'b0), .R13out(1'b0), .R14out(1'b0), .R15out(1'b0),
        .HIout(1'b0), .LOout(1'b0), .Zhighout(1'b0), .InPortout(1'b0), .Cout(1'b0),
       
        // Input control signals
        .MARin(MARin),
        .Zin(Zin),
        .PCin(PCin),
        .MDRin(MDRin),
        .IRin(IRin),
        .Yin(Yin),
        .R2in(R2in),
        .R5in(R5in),
        .R6in(R6in),
        .R0in(1'b0), .R1in(1'b0), .R3in(1'b0), .R4in(1'b0),
        .R7in(1'b0), .R8in(1'b0), .R9in(1'b0), .R10in(1'b0), .R11in(1'b0),
        .R12in(1'b0), .R13in(1'b0), .R14in(1'b0), .R15in(1'b0),
        .HIin(1'b0), .LOin(1'b0), .Zhighin(1'b0), .Zlowin(1'b0),
        .InPortin(1'b0), .Cin(1'b0),
       
        // Testbench signals
        .IncPC(IncPC),
        .Read(Read),
        .AND(AND),
        .Mdatain(Mdatain),
       
        // Outputs (for monitoring)
        .R0(), .R1(), .R2(), .R3(), .R4(), .R5(), .R6(), .R7(),
        .R8(), .R9(), .R10(), .R11(), .R12(), .R13(), .R14(), .R15(),
        .HI(), .LO(), .PC(), .IR(), .MAR(), .MDR(), .Y(),
        .Z(),
        .BusMuxOut()
    );
   
    // Clock generation
    initial begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end
   
    // State transitions
    always @(posedge Clock) begin
        case (Present_state)
            Default:    Present_state <= Reg_load1a;
            Reg_load1a: Present_state <= Reg_load1b;
            Reg_load1b: Present_state <= Reg_load2a;
            Reg_load2a: Present_state <= Reg_load2b;
            Reg_load2b: Present_state <= Reg_load3a;
            Reg_load3a: Present_state <= Reg_load3b;
            Reg_load3b: Present_state <= T0;
            T0:         Present_state <= T1;
            T1:         Present_state <= T2;
            T2:         Present_state <= T3;
            T3:         Present_state <= T4;
            T4:         Present_state <= T5;
            T5:         Present_state <= Default;
        endcase
    end
   
    // Control signals in each state
    always @(Present_state) begin
        // Default all signals to 0
        PCout <= 0; Zlowout <= 0; MDRout <= 0; R5out <= 0; R6out <= 0;
        MARin <= 0; Zin <= 0; PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0;
        IncPC <= 0; Read <= 0; AND <= 0; R2in <= 0; R5in <= 0; R6in <= 0;
        R3out <= 0; R7out <= 0;
        Mdatain <= 32'h00000000;
       
        case (Present_state)
            Default: begin
                // All signals already defaulted
            end
           
            Reg_load1a: begin
                Mdatain <= 32'h00000034;
                Read <= 1;
                MDRin <= 1;
            end
           
            Reg_load1b: begin
                MDRout <= 1;
                R5in <= 1;      // Initialize R5 with 0x34
            end
           
            Reg_load2a: begin
                Mdatain <= 32'h00000045;
                Read <= 1;
                MDRin <= 1;
            end
           
            Reg_load2b: begin
                MDRout <= 1;
                R6in <= 1;      // Initialize R6 with 0x45
            end
           
            Reg_load3a: begin
                Mdatain <= 32'h00000067;
                Read <= 1;
                MDRin <= 1;
            end
           
            Reg_load3b: begin
                MDRout <= 1;
                R2in <= 1;      // Initialize R2 with 0x67
            end
           
            T0: begin
                PCout <= 1;
                MARin <= 1;
                IncPC <= 1;
                Zin <= 1;       // PC -> MAR, IncPC, Z gets PC+1
            end
           
            T1: begin
                Zlowout <= 1;
                PCin <= 1;
                Read <= 1;
                MDRin <= 1;  
                Mdatain <= 32'h112B0000;  // Opcode for "and R2, R5, R6"
            end
           
            T2: begin
                MDRout <= 1;
                IRin <= 1;      // MDR -> IR
            end
           
            T3: begin
                R5out <= 1;
                Yin <= 1;       // R5 -> Y
            end
           
            T4: begin
                R6out <= 1;
                AND <= 1;
                Zin <= 1;       // R6 AND Y -> Z
            end
           
            T5: begin
                Zlowout <= 1;
                R2in <= 1;      // Zlow -> R2
            end
        endcase
    end
   
    // Monitor results
    initial begin
        $monitor("Time=%0t State=%s R5=%h R6=%h R2=%h",
                 $time, Present_state, DUT.R5, DUT.R6, DUT.R2);
    end
   
    // End simulation
    initial begin
        #500 $finish;
    end

endmodule