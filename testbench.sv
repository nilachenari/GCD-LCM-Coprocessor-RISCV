module testbench();
    logic clk;
    logic reset;
    logic [31:0] WriteData, DataAdr, WDFinal;
    logic MemWrite, Start;
    
    // instantiate device to be tested
    riscv dut(clk, reset, WriteData, DataAdr, WDFinal, MemWrite, Start);
    
    // initialize test
    initial begin
        reset <= 1; # 10; reset <= 0;
    end
        
    // generate clock to sequence tests
    always begin
        clk <= 1; # 5; clk <= 0; # 5;
    end
     
    // check results
    always @(negedge clk) begin
        if(MemWrite)
        begin
            if(DataAdr === 124 & WDFinal === 21) begin
                $display("Simulation succeeded");
                $stop;
            end 
            else if (DataAdr === 96) begin
                $display("Simulation running: DataAdr = %d", DataAdr);
            end
            else begin
                $display("Simulation failed: DataAdr = %d", DataAdr);
                $stop;
            end
        end
    end
endmodule