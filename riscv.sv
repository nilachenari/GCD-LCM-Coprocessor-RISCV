// start
module riscv(input logic clk, reset,
            output logic [31:0] WriteData, DataAdr, // data add for memory and the address
            output logic MemWrite); // enable
    logic [31:0] PC, Instr, ReadData;
    // instantiate processor and memories
    riscvsingle rvsingle( clk, reset, PC, Instr, MemWrite,
    DataAdr, WriteData, ReadData);
    imem imem(PC, Instr);
    dmem dmem(clk, MemWrite, DataAdr, WriteData, ReadData);
    coprocessor cop(clk, Start ,WriteData, ReadData)
    // add coproc here (something)
endmodule