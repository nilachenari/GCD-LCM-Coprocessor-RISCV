module riscv(input logic clk, reset,
            output logic [31:0] WriteData, DataAdr, WDFinal,
            output logic MemWrite,
            output logic Start);
    logic [31:0] PC, Instr, ReadData;
    // instantiate processor and memories
    riscvsingle rvsingle( clk, reset, PC, Instr, MemWrite,
    DataAdr, WriteData, ReadData, WDFinal ,Start);
    imem imem(PC, Instr);
    dmem dmem(clk, MemWrite, DataAdr, WDFinal, ReadData);
    coprocessor cop(clk, Start, WDFinal, copDone, AnsData);
endmodule