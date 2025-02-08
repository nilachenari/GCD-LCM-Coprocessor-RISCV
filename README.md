# Special-Purpose Coprocessor for GCD & LCM Calculation

## Overview
This project implements a **special-purpose coprocessor** designed to compute the **Greatest Common Divisor (GCD)** and **Least Common Multiple (LCM)** of two 8-bit numbers. The coprocessor is integrated into a **single-cycle processor** and communicates using a custom instruction format.  

## Features
- Computes **GCD** and **LCM** using hardware-based algorithms.
- Uses a **start signal** to begin operations and a **done signal** to indicate completion.
- Integrated with a **single-cycle processor** (V-RISC).
- Implements a **control unit (FSM)** and **datapath** for efficient computation.
- Fully tested using **assembly programs** and **testbench simulations**.

## Architecture
The coprocessor is designed as a **multi-cycle processing unit** that interacts with the processor. It consists of:
1. **Datapath**: Performs computations using a single **ALU-based subtraction/addition unit**.
2. **Control Unit (FSM)**: Controls execution flow based on instruction type.
3. **Memory & Register Interface**: Uses custom instruction formats to communicate with the main processor.

### **Instruction Format**
The coprocessor uses a custom **R-type instruction format**:

| Opcode   | rs1  | rs2  | func  | rd   |
|----------|------|------|-------|------|
| `0000000A` | `AAAA` | `BBBB` | `B000` | `CCCC` | (GCD) |
| `0000000A` | `AAAA` | `BBBB` | `B000` | `CCCC` | (LCM) |

### **Processor-Coprocessor Communication**
1. The processor writes a 32-bit word to the coprocessor.
2. The coprocessor processes the GCD/LCM operation.
3. The processor continuously reads until the **done signal** is asserted.
4. The result is then stored in the destination register.

### **Control Signals**
- **Start**: Signals the coprocessor to begin execution.
- **Done**: Indicates the completion of the operation.
- **Opcode**: Determines whether to compute GCD (`0`) or LCM (`1`).

## Implementation
### **Processor Modifications**
- Added a **Start signal** to trigger computation.
- Integrated a **MUX for WriteData selection** (memory vs. coprocessor).
- Modified **PC update logic** to **stall** execution until computation is complete.
- Created a **new instruction decoder** for coprocessor instructions.

### **Coprocessor Design**
- **Datapath**:
  - Uses an **ALU-based iterative approach** for GCD and LCM.
  - Optimized to share a **single arithmetic unit** for subtraction/addition.
  
  ![image](https://github.com/user-attachments/assets/85df97bb-c209-4162-9bce-d27ee24987be)

- **Control Unit (FSM)**:
  - Implements a state machine to manage execution.
  - Waits for **start signal** and asserts **done signal** upon completion.

## Testing & Verification
1. **Assembly Program**:  
   - Implemented an assembly program that tests GCD & LCM computations.
   - The program reads numbers from memory, writes them to the coprocessor, and stores the results.
2. **Testbench Simulation**:  
   - Created a **testbench** to verify hardware functionality.
   - Checks **WriteData, DataAddress, and Done signals** for correctness.
   - Simulated using **ModelSim**.

## How to Run
1. **Compile and synthesize the processor and coprocessor in Verilog**.
2. **Load the assembly program** into the instruction memory.
3. **Simulate the system** using ModelSim or another HDL simulator.
4. **Verify output in memory/registers**.

## Synthesis and FPGA Implementation
In the first phase, synthesize the coprocessor alone and then the entire system designed so far on an FPGA. This project assumes that the final system will be implemented using a Nano10-DE board, with the FPGA used in synthesis and simulation being a **7I23U6CSEBA5 SE V Cyclone**. Report the synthesis results in a table format for each case as outlined in the exercises.

![photo_5769166227548260876_y](https://github.com/user-attachments/assets/ae74c8f6-ff8d-4d4b-a84c-bc285d0b2726)

![photo_5769166227548260875_y](https://github.com/user-attachments/assets/154bc17b-367e-4357-bbfd-255cc8de7b16)

## Authors
- **Nila Chenari**
- **Barbod Coliae**

Instructor: Dr. Attarzadeh Niaki  
Course: Computer Architecture  
Semester: Spring 2024  

This project is the final project for the Computer Architecture course and serves as a practical implementation of integrating custom hardware with a RISC processor.
