module riscvsingle(input logic clk, reset,
                output logic [31:0] PC,
                input logic [31:0] Instr,
                output logic MemWrite,
                output logic [31:0] ALUResult, WriteData,
                input logic [31:0] ReadData,
                output logic [31:0] WDFinal,
                output logic Start,
                input logic [31:0] AnsData);
    logic ALUSrc, RegWrite, Jump, Zero, PCRControl, PCSrc;
    logic [1:0] ResultSrc, ImmSrc;
    logic [2:0] ALUControl;
    logic copDone;
    assign copDone = AnsData[8];
    controller c(Instr[6:0], Instr[14:12], Instr[30], Zero,
            ResultSrc, MemWrite, PCSrc,
            ALUSrc, RegWrite, Jump,
            ImmSrc, ALUControl, PCRControl, Start, copDone);
    datapath dp(clk, reset, PCRControl, ResultSrc, PCSrc,
            ALUSrc, RegWrite,
            ImmSrc, ALUControl,
            Zero, PC, Instr,
            ALUResult, WriteData, ReadData, WDFinal, Start, AnsData);
endmodule