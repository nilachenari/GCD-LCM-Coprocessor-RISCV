module maindec(input logic [6:0] op,
                output logic [1:0] ResultSrc,
                output logic MemWrite,
                output logic Branch,
                output logic [1:0] ALU3SrcB,
                output logic RegWrite, Jump,
                output logic [1:0] ImmSrc, 
                output logic [1:0] ALUOp,
                output logic PCRControl,
                output logic Start,
                output logic ALU3SrcA);
    logic [14:0] controls;

    // 0        RegWrite
    // 1,2      ImmSrc
    // 3,4      ALU3SrcB  // here
    // 5        MemWrite
    // 6,7      ResultSrc // added 11 for CoProcessor
    // 8        Branch
    // 9,10     ALUOp     // here
    // 11       Jump
    // 12       PCRControl

    // 13       Start     // here : (like branch) 1 if its gcd or lcm
    // 14       ALU3SrcA  // here : choose A or '100000000A


    assign {RegWrite, ImmSrc, ALUSrc, MemWrite,
    ResultSrc, Branch, ALUOp, Jump, PCRControl, Start, ALU3SrcA } = controls;
    always_comb
        case(op)
        // RegWrite_ImmSrc_ALU3SrcB_MemWrite_ResultSrc_Branch_ALUOp_Jump_PCRControl // Start_ALU3SrcA


            7'b0000011: controls = 15'b1_00_01_0_01_0_00_0_0_0_0; // lw
            7'b0100011: controls = 15'b0_01_01_1_00_0_00_0_0_0_0; // sw
            7'b0110011: controls = 15'b1_xx_00_0_00_0_10_0_0_0_0; // R-type
            7'b1100011: controls = 15'b0_10_00_0_xx_1_01_0_1_0_0; // bne / beq
            7'b0010011: controls = 15'b1_00_01_0_00_0_10_0_0_0_0; // I-type ALU
            7'b1101111: controls = 15'b1_11_00_0_10_0_00_1_1_0_0; // jal
            7'b1100111: controls = 15'b1_00_01_0_00_0_10_1_0_0_0; // jalr

            7'b0000000: controls = 15'b1_xx_10_0_00_0_11_0_0_1_0; // gcd
            7'b0000001: controls = 15'b1_xx_10_0_00_0_11_0_0_1_1; // lcm

            default: controls = 15'bx_xx_xx_x_xx_x_xx_x_1_0_0; // ???
    endcase
endmodule










// module maindec(input logic [6:0] op,
//                 output logic [1:0] ResultSrc,
//                 output logic MemWrite,
//                 output logic Branch, ALUSrc,
//                 output logic RegWrite, Jump,
//                 output logic [1:0] ImmSrc,
//                 output logic [1:0] ALUOp,
//                 output logic PCRControl);
//     logic [11:0] controls;
//     assign {RegWrite, ImmSrc, ALUSrc, MemWrite,
//     ResultSrc, Branch, ALUOp, Jump, PCRControl} = controls;
//     always_comb
//         case(op)
//         // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump_PCRControl
//             7'b0000011: controls = 12'b1_00_1_0_01_0_00_0_0; // lw
//             7'b0100011: controls = 12'b0_01_1_1_00_0_00_0_0; // sw
//             7'b0110011: controls = 12'b1_xx_0_0_00_0_10_0_0; // R-type
//             7'b1100011: controls = 12'b0_10_0_0_xx_1_01_0_1; // bne / beq
//             7'b0010011: controls = 12'b1_00_1_0_00_0_10_0_0; // I-type ALU
//             7'b1101111: controls = 12'b1_11_0_0_10_0_00_1_1; // jal
//             7'b1100111: controls = 12'b1_00_1_0_00_0_10_1_0; // jalr

//             7'b0000000: controls = 12'b1_xx_0_0_00_0_00_0_0; // gcd
//             7'b0000001: controls = 12'b1_xx_0_0_00_0_00_0_0; // lcm

//             // add new intructions here... two 
//             default: controls = 12'bx_xx_x_x_xx_x_xx_x_1; // ???
//     endcase
// endmodule