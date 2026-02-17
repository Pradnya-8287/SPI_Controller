# SPI_Controller
This project implements a Serial Peripheral Interface (SPI) Controller in Verilog, consisting of a master, slave, and memory-mapped register interface. The design demonstrates full-duplex serial communication, finite state machine control, and data shifting operations.

The controller supports command, address, and data transfer between master and slave over standard SPI signals.

This project was developed as a learning exercise in digital design and RTL verification.

## Features 
- Memory-mapped register interface
- SPI Master and SPI Slave implementation
- Full-duplex serial communication
- FSM-based control logic
- Command, address, and data transfer
- GTKWave simulation support
- Modular RTL design
- Parameterized data shifting

## Architecture
The design consists of three main modules:

### 1. SPI Top Module
Acts as the register interface and connects master and slave.
| Address | Register |
|--------|----------|
| 000 | Enable |
| 001 | Command |
| 010 | Address |
| 011 | Data In |
| 100 | Data Out |
