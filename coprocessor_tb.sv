module coprocessor_tb;

  logic clk;
  logic Start;
  logic [31:0] WriteData;
  logic [31:0] ReadData;
  logic done;

  coprocessor dut (
    .clk(clk),
    .Start(Start),
    .WriteData(WriteData),
    .ReadData(ReadData)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Task to apply stimulus and wait for done
  task perform_operation(input [31:0] data);
    begin
      WriteData = data;
      Start = 1;
      wait (ReadData[8] == 1); // Wait until done signal is 1 (adjust index if needed)
      Start = 0; #10
      @(posedge clk); // Added extra cycle to ensure Start is reset
    end
  endtask

  // GCD operation
  task test_gcd;
    begin
      // Example: GCD of 48 and 18 (assume appropriate encoding for GCD operation)
      perform_operation(32'h12301E);
      $display("GCD of 48 and 30 = %d", ReadData[7:0]);
    end
  endtask

  // LCM operation
  task test_lcm;
    begin
      // Example: LCM of 4 and 6 (assume appropriate encoding for LCM operation)
      perform_operation(32'h10608);
      $display("LCM of 8 and 6 = %d", ReadData[7:0]);
    end
  endtask

  initial begin
    // Initialize signals
    clk = 0;
    WriteData = 0;
    done = 0;
    Start = 0;

    // Adding a delay before starting the tests
    #10;
    // $display("Testing GCD...");
    // test_gcd();

    // Test LCM
    $display("Testing LCM...");
    test_lcm();

    // Finish simulation
    $finish;
  end

endmodule
