module maindec(input logic [6:0] op,
                output logic [1:0] ResultSrc,
                output logic MemWrite,
                output logic Branch, ALUSrc,
                output logic RegWrite, Jump,
                output logic [1:0] ImmSrc,
                output logic [1:0] ALUOp,
                output logic PCRControl,
                output logic Start);
    logic [12:0] controls;
    assign {RegWrite, ImmSrc, ALUSrc, MemWrite,
    ResultSrc, Branch, ALUOp, Jump, PCRControl, Start} = controls;
    always_comb
        case(op)
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump_PCRControl_Start
            7'b0000011: controls = 13'b1_00_1_0_01_0_00_0_0_0; // lw
            7'b0100011: controls = 13'b0_01_1_1_00_0_00_0_0_0; // sw
            7'b0110011: controls = 13'b1_xx_0_0_00_0_10_0_0_0; // R-type
            7'b1100011: controls = 13'b0_10_0_0_xx_1_01_0_1_0; // bne / beq
            7'b0010011: controls = 13'b1_00_1_0_00_0_10_0_0_0; // I-type ALU
            7'b1101111: controls = 13'b1_11_0_0_10_0_00_1_1_0; // jal
            7'b1100111: controls = 13'b1_00_1_0_00_0_10_1_0_0; // jalr

            7'b0000000: controls = 13'b1_xx_x_0_11_0_xx_0_0_1; // gcd
            7'b0000001: controls = 13'b1_xx_x_0_11_0_xx_0_0_1; // lcm
            default: controls = 13'bx_xx_x_x_xx_x_xx_x_1_0; // ???
            // 7'b0000011: controls = 11'b1_00_1_0_01_0_00_0; // lw
            // 7'b0100011: controls = 11'b0_01_1_1_00_0_00_0; // sw
            // 7'b0110011: controls = 11'b1_xx_0_0_00_0_10_0; // R–type
            // 7'b1100011: controls = 11'b0_10_0_0_00_1_01_0; // beq
            // 7'b0010011: controls = 11'b1_00_1_0_00_0_10_0; // I–type ALU
            // 7'b1101111: controls = 11'b1_11_0_0_10_0_00_1; // jal
            // 7'b1100111: controls = 11'b1_00_0_0_10_0_00_1; // jalr
            // default: controls = 11'bx_xx_x_x_xx_x_xx_x; // ???
    endcase
endmodule