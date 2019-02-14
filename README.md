# Multi-Cycle Pipelined Processor

This is the VHDL implementation of a MIPS Multi-Cycle Pipelined Processor that I developed for the computer architecture course at my university. The processor is written entirely in VHDL and strictly "structural" in programming style i.e. no control flow (if/elsif/then/else etc.) or sequential statements. This processor fulfills a part of the MIPS instruction set architecture (ISA) and is able to perform arithmetic operations, logic comparison and operations, branch operations, register read/writes, memory read/writes, register-to-memory and memory-to-register operations.

This processor fulfills the following subset of the MIPS instruction set architecture:
* arithmetic: add, addi, addu, sub, subu
* logical: and, or, sll
* data transfer: lw, sw
* conditional branch: beq, bne, bgtz, slt, sltu

This processor is also pipelined and features basic forwarding capabilities:
* ALU to ALU forwarding
* ALU to Memory forwarding
* ALU to Register forwarding

## Deployment

This processor was tested and verified using ModelSim. We verify the functionality of the processor by feeding it binary MIPS instructions line-by-line and verify that all the operations are correctly interpreted, executed, and stored: cycle-by-cycle.

The top-level entity of the processor is "pipeline_CPU.vhd"

## Built With

* [Notepad++](https://notepad-plus-plus.org) - Editor used for developing VHDL
* [ModelSim](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-sim.html) - Simulation tool for testing and verifying valid processor outputs

## Acknowledgments

* Course professor for project guidance
* Course partners for co-development of the datapath
