// module coprocessor (input logic clk, Start,
//                     input logic [31:0] WDFinal,
//                     output logic [31:0] AnsData);

// // stuff here


// endmodule


module coprocessor (
    input logic clk,
    input logic Start,
    input logic [31:0] WriteData,
    output logic [31:0] ReadData);

    // Counter to track the number of consecutive cycles Start is 1
    logic [2:0] startCounter;

    always_ff @(posedge clk) begin
        if (Start) begin
            if (startCounter < 3'd6) begin
                startCounter <= startCounter + 1;
            end
        end else begin
            startCounter <= 3'd0;
        end
    end

    always_ff @(posedge clk) begin
        if (startCounter == 3'd6) begin
            ReadData <= 32'hFFFFF1FF; // Set every bit to 1
        end else begin
            ReadData <= 32'h00000010; // Set every bit to 0
            startCounter <= startCounter + 1;
        end
    end

endmodule