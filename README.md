# Reti Logiche: Final Test

## Authors
This Project was developed by:
- Francesco Di Giore

## Introduction
This is the repository for the Final Test (Prova Finale) of Logical Networks (Reti Logiche) in the academic year 2022/2023 at Polytechnic of Milan.

## Description of the Project
The project requires implementing a **hardware module in VHDL** that interfaces with a memory and directs the data read from memory to one of the **four available output channels** (Z0, Z1, Z2, Z3).  

The module receives as input a serial bit stream, organized as follows:
- **2 header bits** → identify the output channel:  
  - `00` → Z0  
  - `01` → Z1  
  - `10` → Z2  
  - `11` → Z3  
- **N address bits** (0 ≤ N ≤ 16) → specify the memory address to read an 8-bit data value from.  
  - If N < 16, the address is extended with leading zeros.  

The module then reads the memory content at the given address and outputs the value to the selected channel.

For further details, please review the [full description](Requirements/Specifica_progetto_di_reti_logiche_AA_2022-2023.pdf).
