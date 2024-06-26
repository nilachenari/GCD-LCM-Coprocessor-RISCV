module datapath(input logic clk ,reset, PCRControl,
                input logic [1:0] ResultSrc,
                input logic [1:0] ALU3SrcBSelect, // here
                input logic ALU3SrcASelect, // here
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
    logic [31:0] SrcA, SrcB, SrcAfterMux;
    logic [31:0] Result;
    logic [1:0] dontcare;
    
    logic [31:0] ALU1Result, ALU2Result;

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
    // ******* make bit 16 and 0-7
    alu alu1({24'b0, SrcA[7:0]}, 32'b1_00000000_00000000, 3'b000, ALU1Result, dontcare[0]);


    // ALU2 logic
    // ******* make bit 8-15
    alu alu2({24'b0, SrcB[7:0]}, 32'b1000, 3'b110, ALU2Result, dontcare[1]);


    
    // ALU3 logic

    // ******* hopefully we have the 32'b 17x_op_y0_x0   in ALU3Result after this

    alu alu3(SrcAfterMux, SrcB, ALUControl, ALUResult, Zero);
    mux2 #(32) ALU3srcAmux(SrcA, ALU1Result, ALU3SrcASelect, SrcAfterMux); 
    mux3 #(32) ALU3srcBmux(WriteData, ImmExt, ALU2Result, ALU3SrcBSelect, SrcB);

    mux3 #(32) resultmux( ALUResult, ReadData, PCPlus4, ResultSrc, Result);
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