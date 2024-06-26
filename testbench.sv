module testbench();
    logic clk;
    logic reset;
    logic [31:0] WriteData, DataAdr;
    logic MemWrite;
    
    // instantiate device to be tested
    riscv dut(clk, reset, WriteData, DataAdr, MemWrite);
    
    // initialize test
    initial begin
        reset <= 1; # 30; reset <= 0;
    end
        
    // generate clock to sequence tests
    always begin
        clk <= 1; # 15; clk <= 0; # 15;
    end
     
    // check results
    always @(negedge clk) begin
        if(MemWrite)
        begin
            if(DataAdr === 100 & WriteData === 25) begin
                $display("Simulation succeeded");
                $stop;
            end 
            else if (DataAdr !== 96) begin
                $display("Simulation failed");
                $stop;
            end
        end
    end
endmodule