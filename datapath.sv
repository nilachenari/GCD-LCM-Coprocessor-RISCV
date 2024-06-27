module datapath(input logic clk, reset, PCRControl,
                input logic [1:0] ResultSrc,
                input logic PCSrc, ALUSrc,
                input logic RegWrite,
                input logic [1:0] ImmSrc,
                input logic [2:0] ALUControl,
                output logic Zero,
                output logic [31:0] PC,
                input logic [31:0] Instr,
                output logic [31:0] ALUResult, WriteData,
                input logic [31:0] ReadData,
                output logic [31:0] WDFinal,
                input logic Start,
                input logic [31:0] copAns);
    logic [31:0] PCNext, PCPlus4, PCAdderRes, PCTarget;
    logic [31:0] ImmExt;
    logic [31:0] SrcA, SrcB;
    logic [31:0] Result;
    logic [31:0] WDCop;
    // next PC logic
    flopr #(32) pcreg(clk, reset, PCNext, PC);
    adder pcadd4(PC, 32'd4, PCPlus4);
    adder pcaddbranch(PC, ImmExt, PCAdderRes);
    mux2 #(32) r_or_not(ALUResult, PCAdderRes, PCRControl, PCTarget);
    mux2 #(32) pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
    
    // register file logic
    regfile rf(clk, RegWrite, Instr[19:15], Instr[24:20],
    Instr[11:7], Result, SrcA, WriteData);
    extend ext(Instr[31:7], ImmSrc, ImmExt);
    
    // make the 32 bit word you wanna pass to cop
    assign WDCop = {15'b0, Instr[0], WriteData[7:0], SrcA[7:0]};

    // logics
    WDSel sel (WDCop, WriteData, Start, WDFinal);

    // ALU logic

    logic [31:0] ans;
    assign ans = {24'b0, copAns[7:0]};
    
    mux2 #(32) srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
    alu alu(SrcA, SrcB, ALUControl, ALUResult, Zero);
    mux3 #(32) resultmux( ALUResult, ReadData, PCPlus4, ans, ResultSrc, Result);
endmodule