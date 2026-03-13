`timescale 1ns/1ps
module test_mips32;

reg clk1, clk2;
integer k;

// Instantiate the MIPS32 processor
pipe_MIPS32 mips (clk1, clk2);


// Clock generation: two-phase clock
initial begin
    clk1 = 0; clk2 = 0;
    repeat (40) // enough cycles for pipeline
    begin
        #5 clk1 = 1; #5 clk1 = 0;
        #5 clk2 = 1; #5 clk2 = 0;
    end
end

// Initialize registers and memory
initial begin
    for (k = 0; k < 32; k = k + 1)
        mips.Reg[k] = 0; // start from zero

    // Program instructions
    mips.Mem[0] = 32'h2801000a;   // ADDI R1, R0, 10
    mips.Mem[1] = 32'h28020014;   // ADDI R2, R0, 20
    mips.Mem[2] = 32'h28030019;   // ADDI R3, R0, 25
    mips.Mem[3] = 32'h0ce77800;   // OR R7, R7, R7 -- dummy
    mips.Mem[4] = 32'h0ce77800;   // OR R7, R7, R7 -- dummy
    mips.Mem[5] = 32'h00222000;   // ADD R4, R1, R2
    mips.Mem[6] = 32'h0ce77800;   // OR R7, R7, R7 -- dummy
    mips.Mem[7] = 32'h00832800;   // ADD R5, R4, R3
    mips.Mem[8] = 32'hfc000000;   // HLT

    // Control signals
    mips.HALTED = 0;
    mips.PC = 0;
    mips.TAKEN_BRANCH = 0;
end

// Display register values after execution
initial begin
    #1000 // wait enough time for all pipeline stages
    for (k = 0; k < 6; k = k + 1)
        $display("R%1d - %2d", k, mips.Reg[k]);
end

// Waveform generation
// Waveform generation
initial begin
    $dumpfile("mips.vcd");            // VCD file
    $dumpvars(0, test_mips32);        // dump all signals
    // Dump the R0-R5 wires so GTKWave can see them
    $dumpvars(0, mips.R0, mips.R1, mips.R2, mips.R3, mips.R4, mips.R5);
    #600 $finish;                     // finish after enough time
end

endmodule