module datapath(input logic clk, reset, PCRControl,
                input logic [1:0] ALU3SrcBSelect, // here
                input logic ALU3SrcASelect, // here
                input logic [1:0] ResultSrc,
                input logic PCSrc,
                input logic RegWrite,
                input logic [1:0] ImmSrc,
                input logic [2:0] ALUControl,
                output logic Zero,
                output logic [31:0] PC,
                input logic [31:0] Instr,
                output logic [31:0] ALUResult, WriteData,
                input logic [31:0] ReadData);
    logic [31:0] PCNext, PCPlus4, PCAdderRes, PCTarget;
    logic [31:0] ImmExt;
    logic [31:0] SrcA, SrcB;
    logic [31:0] Result;
    
    logic [31:0] ALU1Result, AlU2Rresult;

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
    

    // ALU1 logic
    alu alu1(SrcA[7:0], 17'b1_00000000_00000000, 3'b000, ALU1Result, Zero);


    // ALU2 logic

    alu alu2(SrcB[7:0], 8, 3'b110, ALU2Result, Zero);


    
    // ALU3 logic

    alu alu3(SrcA, SrcB, ALUControl, ALUResult, Zero);
    mux2 #(32) ALU3srcAmux(SrcA, ALU1Result, ALU3SrcASelect, SrcB);    
    mux3 #(32) ALU3srcBmux(WriteData, ImmExt, ALU2Result, ALU3SrcBSelect, SrcB);

    mux3 #(32) resultmux( ALUResult, ReadData, PCPlus4,
    ResultSrc, Result);
endmodule













// module datapath(input logic clk, reset, PCRControl,
//                 input logic [1:0] ResultSrc,
//                 input logic PCSrc, ALUSrc,
//                 input logic RegWrite,
//                 input logic [1:0] ImmSrc,
//                 input logic [2:0] ALUControl,
//                 output logic Zero,
//                 output logic [31:0] PC,
//                 input logic [31:0] Instr,
//                 output logic [31:0] ALUResult, WriteData,
//                 input logic [31:0] ReadData);
//     logic [31:0] PCNext, PCPlus4, PCAdderRes, PCTarget;
//     logic [31:0] ImmExt;
//     logic [31:0] SrcA, SrcB;
//     logic [31:0] Result;
    
//     // next PC logic
//     flopr #(32) pcreg(clk, reset, PCNext, PC);
//     adder pcadd4(PC, 32'd4, PCPlus4);
//     adder pcaddbranch(PC, ImmExt, PCAdderRes);
//     mux2 #(32) r_or_not(ALUResult, PCAdderRes, PCRControl, PCTarget);
//     mux2 #(32) pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
    
//     // register file logic
//     regfile rf(clk, RegWrite, Instr[19:15], Instr[24:20],
//     Instr[11:7], Result, SrcA, WriteData);
//     extend ext(Instr[31:7], ImmSrc, ImmExt);
    
//     // ALU logic
//     mux2 #(32) srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
//     alu alu(SrcA, SrcB, ALUControl, ALUResult, Zero);
//     mux3 #(32) resultmux( ALUResult, ReadData, PCPlus4,
//     ResultSrc, Result);
// endmodule