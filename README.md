# APB Based UART 16550 UVM Verification

UVM-based verification environment for an APB-connected UART 16550 controller with custom APB and UART UVM agents.

## Overview

The DUT is an APB-connected UART 16550 controller that provides UART transmit and receive functionality through an APB interface.

The controller includes UART TX/RX functionality, FIFO support, loopback operation, interrupt handling, and UART error detection.

The main focus of this project is the development of custom APB and UART UVM agents and functional verification of the UART 16550 DUT.

## Verification Architecture

The APB Master Agent generates APB transactions to access the UART registers of the DUT.

The UART Agent generates and monitors UART TX/RX transactions for verifying serial communication with the DUT.

The monitored APB and UART transactions are provided to the scoreboard for functional checking and coverage analysis.

## APB Agent Development

A custom UVM-based APB Master Agent was developed to generate and monitor APB transactions to the UART 16550 DUT.

### APB Agent Components

```text
apb_agt/
|
|-- apb_agent.sv
|-- apb_agent_top.sv
|-- apb_config.sv
|-- apb_driver.sv
|-- apb_monitor.sv
|-- apb_seqs.sv
|-- apb_sequencer.sv
`-- apb_xtn.sv
```

## UART Agent Development

A custom UVM-based UART Agent was developed to generate and monitor UART TX/RX transactions.

The UART Agent is used to verify UART communication, including normal data transfer and UART error conditions.

### UART Agent Components

```text
uart_agt/
|
|-- uart_agent.sv
|-- uart_agent_top.sv
|-- uart_config.sv
|-- uart_driver.sv
|-- uart_monitor.sv
|-- uart_seqs.sv
|-- uart_sequencer.sv
`-- uart_xtn.sv
```

## Project Structure

```text
APB_BASED_UART/
|
|-- apb_agt/                    # APB Master UVM Agent
|
|-- uart_agt/                   # UART UVM Agent
|
|-- uart_rtl/                   # Design Under Verification
|   |-- apb_if.v
|   |-- uart_16550.v
|   |-- uart_fifo.v
|   |-- uart_if.v
|   |-- uart_register_file.v
|   |-- uart_rx.v
|   `-- uart_tx.v
|
|-- tb/                         # UVM Testbench
|   |-- env.sv
|   |-- env_config.sv
|   |-- sb.sv
|   |-- top.sv
|   |-- uart_reg.sv
|   `-- uart_reg_block.sv
|
|-- test/                       # UVM Tests and Sequences
|   |-- pkg.sv
|   `-- test.sv
|
|-- sim/                        # Simulation
|   `-- Makefile
|
|-- .gitignore
`-- README.md
```

## Verification Scenarios

The following scenarios are verified:

* APB register read and write operations
* UART transmit and receive operations
* Half-duplex communication
* Full-duplex communication
* Loopback operation
* FIFO operation
* Parity error
* Framing error
* Overrun error
* Break interrupt
* THR empty interrupt
* Timeout/error conditions
* Multiple character transfers

## Key Verification Contributions

* Developed a custom APB Master UVM Agent
* Developed a custom UART UVM Agent
* Developed UVM sequences for functional and error scenarios
* Integrated both UVM agents with the UART 16550 DUT
* Developed UVM-based functional checking
* Implemented scoreboard-based data checking
* Implemented functional coverage
* Verified UART TX/RX communication
* Verified FIFO and loopback operation
* Verified UART error and interrupt conditions

## Tools Used

* SystemVerilog
* UVM
* QuestaSim

## Author

Bhoomika Palani
