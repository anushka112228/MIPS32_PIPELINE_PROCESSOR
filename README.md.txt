# MIPS32 Pipelined Processor (Verilog)

## Project Overview

This project implements a **5-stage pipelined MIPS32 processor** using **Verilog Hardware Description Language (HDL)**.
The processor executes a sequence of instructions using pipeline stages to improve instruction throughput.

The design is simulated using:

* **Icarus Verilog** – Verilog compiler and simulator
* **GTKWave** – waveform viewer for analyzing signal behavior

The project demonstrates how instructions move through the pipeline and how results are written back to the register file.

---

# Project Folder Structure

```
mips32_pipeline/
│
├── src/
│   └── pipe_MIPS32.v
│
├── tb/
│   └── test_mips32.v
│
├── waves/
│   └── waveform.png
│
└── README.md
```

### Folder Description

| Folder        | Description                                        |
| ------------- | -------------------------------------------------- |
| **src**       | Contains the main MIPS32 processor implementation  |
| **tb**        | Contains the testbench used for simulation         |
| **waves**     | Stores waveform screenshots generated from GTKWave |
| **README.md** | Documentation for the project                      |

---

# Processor Pipeline Stages

The MIPS32 processor uses a **5-stage pipeline architecture**.

| Stage | Name               | Description                               |
| ----- | ------------------ | ----------------------------------------- |
| IF    | Instruction Fetch  | Fetch instruction from instruction memory |
| ID    | Instruction Decode | Decode instruction and read registers     |
| EX    | Execute            | Perform ALU operation                     |
| MEM   | Memory Access      | Read or write data memory                 |
| WB    | Write Back         | Write result to register file             |

---

# Two-Phase Clocking

The design uses **two-phase clocking**:

| Clock | Stages     |
| ----- | ---------- |
| clk1  | IF, EX, WB |
| clk2  | ID, MEM    |

This helps reduce structural hazards between pipeline stages.

---

# Processor Architecture

```
                +--------------------+
                | Program Counter    |
                +---------+----------+
                          |
                          v
                 +------------------+
                 | Instruction      |
                 | Memory           |
                 +--------+---------+
                          |
                      IF/ID Register
                          |
                          v
                 +------------------+
                 | Instruction      |
                 | Decode           |
                 +--------+---------+
                          |
                     Register File
                          |
                      ID/EX Register
                          |
                          v
                 +------------------+
                 | Execute (ALU)    |
                 +--------+---------+
                          |
                      EX/MEM Register
                          |
                          v
                 +------------------+
                 | Data Memory      |
                 +--------+---------+
                          |
                      MEM/WB Register
                          |
                          v
                 +------------------+
                 | Write Back       |
                 +------------------+
```

---

# Pipeline Reservation Table

This table shows how instructions move through the pipeline stages over clock cycles.

| Cycle | Instruction 1 | Instruction 2 | Instruction 3 | Instruction 4 |
| ----- | ------------- | ------------- | ------------- | ------------- |
| 1     | IF            |               |               |               |
| 2     | ID            | IF            |               |               |
| 3     | EX            | ID            | IF            |               |
| 4     | MEM           | EX            | ID            | IF            |
| 5     | WB            | MEM           | EX            | ID            |
| 6     |               | WB            | MEM           | EX            |
| 7     |               |               | WB            | MEM           |
| 8     |               |               |               | WB            |

---

# Supported Instructions

The processor supports the following instructions:

| Instruction | Operation                   |
| ----------- | --------------------------- |
| ADD         | Addition                    |
| SUB         | Subtraction                 |
| AND         | Bitwise AND                 |
| OR          | Bitwise OR                  |
| SLT         | Set Less Than               |
| MUL         | Multiplication              |
| ADDI        | Add Immediate               |
| SUBI        | Subtract Immediate          |
| SLTI        | Set Less Than Immediate     |
| LW          | Load Word                   |
| SW          | Store Word                  |
| BEQZ        | Branch if Equal to Zero     |
| BNEQZ       | Branch if Not Equal to Zero |
| HLT         | Halt Processor              |

---

# Simulation Tools

| Tool           | Purpose                             |
| -------------- | ----------------------------------- |
| Icarus Verilog | Compiles and simulates Verilog code |
| GTKWave        | Displays waveform signals           |

---

# Installing Required Tools

### Ubuntu / Linux

```
sudo apt update
sudo apt install iverilog gtkwave
```

---

# Running the Simulation

### Step 1 – Compile the Verilog Files

Run the following command from the project folder:

```
iverilog -o mips src/pipe_MIPS32.v tb/test_mips32.v
```

---

### Step 2 – Run the Simulation

```
vvp mips
```

During simulation a waveform file will be generated:

```
mips.vcd
```

---

# Waveform Generation

Inside the testbench the following commands are used:

```
$dumpfile("mips.vcd");
$dumpvars(0,test_mips32);
```

These commands create a **Value Change Dump (VCD)** file which stores all signal transitions during simulation.

---

# Viewing Waveforms

Open the waveform file using GTKWave:

```
gtkwave mips.vcd
```

In GTKWave add signals such as:

```
clk1
clk2
PC
IF_ID_IR
ID_EX_A
EX_MEM_ALUOut
MEM_WB_ALUOut
```

These signals show the flow of instructions through the pipeline.

---

# Saving Waveform Screenshot

Inside GTKWave:

```
File → Export → Image
```

Save the image inside the project folder:

```
waves/waveform.png
```

---

# Expected Register Output

After simulation completes the register values printed are:

```
R0 - 0
R1 - 10
R2 - 20
R3 - 25
R4 - 30
R5 - 55
```

This confirms correct pipeline execution.

---

# Simulation Flow

```
Verilog Source Code
        ↓
Compile using Icarus Verilog
        ↓
Run simulation
        ↓
Generate VCD waveform
        ↓
View signals using GTKWave
        ↓
Analyze pipeline execution
```

---

# Learning Outcomes

This project demonstrates:

* Design of a pipelined processor
* Implementation of MIPS instruction execution
* Verilog hardware modeling
* Processor pipeline timing
* Hardware simulation and waveform analysis

---

# Conclusion

The implemented MIPS32 processor successfully demonstrates a **five-stage pipeline architecture** and shows how instructions move through the pipeline stages using simulation and waveform analysis.
