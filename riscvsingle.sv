module riscvsingle(input logic clk, reset,
                output logic [31:0] PC,
                input logic [31:0] Instr,
                output logic MemWrite,
                output logic [31:0] ALUResult, WriteData,
                input logic [31:0] ReadData);
    logic RegWrite, Jump, Zero, PCRControl, PCSrc, ALU3SrcASelect, Start;
    logic [1:0] ResultSrc, ImmSrc, ALU3SrcBSelect;
    logic [2:0] ALUControl;
    controller c(Instr[6:0], Instr[14:12], Instr[30], Zero,
            ResultSrc, MemWrite, PCSrc,
            ALU3SrcBSelect, RegWrite, Jump,
            ImmSrc, ALUControl, PCRControl, Start, ALU3SrcASelect);
    datapath dp(clk,
                reset,
                PCRControl,
                ResultSrc,
                ALU3SrcBSelect, 
                ALU3SrcASelect,
                PCSrc,
                RegWrite,
                ImmSrc,
                ALUControl,
                Zero,
                PC,
                Instr,
                ALUResult, 
                WriteData,
                ReadData);
endmodule