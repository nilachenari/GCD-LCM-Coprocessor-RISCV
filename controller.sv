// this shit
module controller(input logic [6:0] op,
                    input logic [2:0] funct3,
                    input logic funct7b5,
                    input logic Zero,
                    output logic [1:0] ResultSrc,
                    output logic MemWrite,
                    output logic PCSrc, ALUSrc,
                    output logic RegWrite, Jump,
                    output logic [1:0] ImmSrc,
                    output logic [2:0] ALUControl,
                    output logic PCRControl);
    logic [1:0] ALUOp;
    logic Branch;
    logic  Start, ALU3SrcA;
    maindec md(op, ResultSrc, MemWrite, Branch,
    ALUSrc, RegWrite, Jump, ImmSrc, ALUOp, Start, ALU3SrcA);
    aludec ad(op[5], funct3, funct7b5, ALUOp, ALUControl);
    assign PCSrc = (Branch & (Zero ^ funct3[0])) | Jump; // if beq func3[0] == 0 and zero should be 1. if bne func3[0] == 1 and zero should be 0
endmodule
