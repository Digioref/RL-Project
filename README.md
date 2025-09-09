# Reti Logiche: Final Test

## Authors
This Project was developed by:
- Francesco Di Giore

With Professor Fornaciari William.

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

## Architecture
The system uses a Finite State Machine (FSM) with six distinct states:

### State Definitions
1. **INIT_READ_W0** - Initial state, reads first selection bit
2. **READ_W1** - Reads second selection bit
3. **READ_ADDRESS** - Reads 16-bit memory address serially
4. **ASK_MEM** - Requests memory access
5. **READ_MEM** - Reads data from memory
6. **SHOW_OUT** - Outputs results and signals completion

## Operation Flow
1. **Initialization**: System starts in `INIT_READ_W0` state
2. **Selection Reading**: Reads 2-bit selection pattern serially
3. **Address Reading**: Reads 16-bit memory address serially
4. **Memory Access**: Requests memory read operation
5. **Data Storage**: Stores retrieved data in selected output register
6. **Output**: Presents all four output registers and asserts `o_done`
7. **Completion**: Returns to initial state for next operation

## Memory Interface
The system acts as a memory controller with the following characteristics:
- Always operates in read mode (`o_mem_we` = '0')
- Address is presented on `o_mem_addr`
- Data is read from `i_mem_data`
- Memory is enabled during access phases (`o_mem_en` = '1')

## Reset Behavior
Asserting `i_rst` (high) will:
- Clear all internal registers
- Return the FSM to the `INIT_READ_W0` state
- Set all outputs to zero
- Deassert all control signals

## Design Features
- **Serial-to-Parallel Conversion**: Efficiently converts serial input to parallel data
- **Registered Outputs**: Maintains stable output values between operations
- **Synchronous Design**: All operations synchronized to clock edges
- **Clear State Machine**: Well-defined states with explicit transitions

For further details, please check [Report](Report.pdf), where you can find the complete description of the structure of the components and the results of all the tests used to verify robustness, consistency and behavior of the designed component.

## Final Considerations
Final Mark: 30/30

