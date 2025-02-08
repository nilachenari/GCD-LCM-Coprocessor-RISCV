GCD-LCM Coprocessor for V-RISC

Overview

This project implements a special-purpose coprocessor designed to compute the Greatest Common Divisor (GCD) and Least Common Multiple (LCM) of two 8-bit numbers. The coprocessor is integrated with a single-cycle V-RISC processor, allowing it to receive instructions, perform computations, and return results.

The project involves:

Designing a co-processor with a minimal instruction set for GCD and LCM.

Modifying the single-cycle processor to communicate with the co-processor.

Implementing a multi-cycle approach for the co-processor, since GCD and LCM computations require multiple clock cycles.

Writing a testbench to verify the correctness of the design.

Developing an assembly program to demonstrate real-world usage.

Features

Coprocessor Architecture:

Two 8-bit inputs (X0, Y0)

One 8-bit output (Result)

A Start signal to initiate computation

A Done signal to indicate completion

Opcode-based selection of GCD (op = 1) and LCM (op = 0)

Processor Modifications:

Extended the control unit to handle coprocessor instructions.

Implemented a mechanism to stall instruction fetching while the coprocessor is running.

Modified the data path to support reading from the coprocessor.

Multi-Cycle Execution:

Since GCD and LCM operations require multiple iterations, we designed a state machine that operates across multiple clock cycles, unlike the single-cycle processor.

The processor waits for the Done signal before proceeding with the next instruction.

Instruction Format

We used an R-type format for the coprocessor instructions:

0000000A|AAAA|BBBB|B000|CCCC|C000|0000  # GCD instruction
0000000A|AAAA|BBBB|B000|CCCC|C000|0001  # LCM instruction

Where:

A represents the destination register (rd)

B represents the first source register (rs1)

C represents the second source register (rs2)

Processor-Coprocessor Communication

Writing to the Coprocessor

31:17  | 16 | 15:8 | 7:0  
-------|----|------|------
  (Unused) | op | Y0 | X0  

The processor writes X0, Y0, and the operation type (op) to the coprocessor.

The Start signal is asserted automatically.

Reading from the Coprocessor

31:9  | 8 | 7:0  
------|---|------
  (Unused) | Done | Result  

The processor continuously polls the Done flag until computation is complete.

Once Done = 1, the result is stored in the processor’s register file.

Implementation Steps

Modify the V-RISC processor to:

Detect coprocessor instructions.

Send values and opcodes to the coprocessor.

Stall instruction fetching until the coprocessor finishes execution.

Design the Coprocessor:

Implement the state machine to handle multi-cycle execution.

Use registers and ALU logic for iterative GCD/LCM computation.

Create the Testbench:

Verify correct values are written to and read from the coprocessor.

Ensure the processor stalls correctly during computation.

Develop Assembly Code:

Implement an assembly program to compute GCD and LCM of stored values in a loop.

Translate it into machine code for simulation.

Testing

The testbench checks:

Correct execution of GCD and LCM computations.

Proper stalling and waiting for the Done signal.

Data integrity between processor and coprocessor.

Simulation Outputs:

Signal traces were used to verify the timing of computation cycles.

Expected vs. actual outputs were compared to confirm correctness.

Repository Structure

GCD-LCM-Coprocessor/
│── src/            # Hardware design files (Verilog/VHDL)
│── sim/            # Testbenches and simulation scripts
│── asm/            # Assembly programs for testing
│── docs/           # Report and documentation
│── README.md       # Project overview (this file)

Future Work

Optimize the multi-cycle execution to reduce the number of clock cycles required.

Extend the coprocessor to support additional arithmetic operations.

Implement a hardware-friendly division algorithm for faster GCD computation.

Contributors

[Nila Chenari]

[Barbod Coliae]

Instructor: Dr. Attarzadeh Niaki | Course: Computer ArchitectureSemester: Spring 2024

This project is the final project for the Computer Architecture course and serves as a practical implementation of integrating custom hardware with a RISC processor.

