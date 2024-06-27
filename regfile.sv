module regfile(input logic clk,
            input logic RegWrite,
            input logic [4:0] A1, A2, A3, // loc of read and write
            input logic [31:0] WD,
            output logic [31:0] RD1, RD2);
    
    logic [31:0] rf[31:0];
    always_ff @(posedge clk)
        if (RegWrite) rf[A3] <= WD;

    assign RD1 = (A1 != 0) ? rf[A1] : 0;
    assign RD2 = (A2 != 0) ? rf[A2] : 0;
endmodule