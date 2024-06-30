module coReg(input logic clk,
            input logic RegWrite, start,
            input logic [2:0] AW, // loc of read and write
            input logic [7:0] WD,
            input logic [31:0] loadAll,
            output logic [7:0] RD [4:0]);
    
    logic [7:0] rf[7:0];
    logic prevStart;
    always_ff @(posedge clk) begin
        if (RegWrite) rf[AW] <= WD;
        if (prevStart == 0 && start == 1) begin
            rf[0] <= loadAll[7:0]; //  x
            rf[1] <= loadAll[7:0]; //  x0
            rf[2] <= loadAll[15:8]; // y
            rf[3] <= loadAll[15:8]; // y0
            rf[4] <= loadAll[16]; //   op
        end
        prevStart <= start;
    end
    assign RD[0] = rf[0]; // x
    assign RD[1] = rf[1]; // x0
    assign RD[2] = rf[2]; // y
    assign RD[3] = rf[3]; // y0
    assign RD[4] = rf[4]; // op
endmodule

module littleAlu(input  logic [7:0] a, b,
           input  logic [1:0]  op,
           output logic [7:0] y);

  always_comb
    case(op)
      2'b00:       y = a + b;
      2'b01:       y = a - b;
      2'b10:       y = b - a;
      default: y = 'x;
    endcase
endmodule

module coCtrl(input logic checkEq,
            input logic mainOp,
            input logic smaller,
            output logic [2:0] AW,
            output logic [1:0] aluOp,
            output logic topCtrl, botCtrl, RegWrite);

    always_comb begin
        if (checkEq == 1) begin
            topCtrl = 0;
            botCtrl = 0;
            aluOp = 2'b01;
            RegWrite = 0;
        end
        else if (mainOp == 0) begin //gcd
            if (smaller == 0) begin
                aluOp = 2'b10;
                AW = 3'b010;
            end else begin
                aluOp = 2'b01; 
                AW = 3'b000;
            end
            topCtrl = 0;
            botCtrl = 0;
            RegWrite = 1;
        end
        else begin // lcm
            if (smaller == 0) begin
                topCtrl = 0;
                botCtrl = 1;
                AW = 3'b000;
            end
            else begin
                topCtrl = 1;
                botCtrl = 0;
                AW = 3'b010;
            end
            aluOp = 2'b00; 
            RegWrite = 1;
        end
    end
endmodule

module coprocessor (input logic clk, Start,
                    input logic [31:0] WriteData,
                    output logic [31:0] ReadData);
        
        logic writeEn, topCtrl, botCtrl, smaller, checkEq, prevStart;
        logic [1:0] op;
        logic [2:0] writeAdr;
        logic [7:0] x, x0, y, y0, out1, out2, out3, mainOp;
        logic [7:0] RD[4:0]; // Intermediate RD signals

        always_ff @(posedge clk) begin
            if (checkEq == 1)
                checkEq <= 0;
            else
                checkEq <= 1;
            if (prevStart == 0 && Start == 1)
                checkEq <= 1;
            prevStart <= Start;
        end

        coReg coreg(clk, writeEn, Start, writeAdr, out3, WriteData, RD);

        // Map  RD  to esm
        assign x = RD[0];
        assign x0 = RD[1];
        assign y = RD[2];
        assign y0 = RD[3];
        assign mainOp = RD[4];

        mux2 #(8) topMux(x, y0, topCtrl, out1);
        mux2 #(8) botMux(y, x0, botCtrl, out2);

        littleAlu alu(out1, out2, op, out3);
        assign smaller = (x <= y) ? 0 : 1;
        assign eqFlag = ((x == y && checkEq == 1)? 1: 0); 
        assign ReadData = {24'b0, eqFlag, x};

        coCtrl coctrl(checkEq, mainOp[0], smaller, writeAdr, op, topCtrl, botCtrl, writeEn);

endmodule