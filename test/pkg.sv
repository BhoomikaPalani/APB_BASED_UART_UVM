package apb_uart_pkg;

  import uvm_pkg::*;

  `include "uvm_macros.svh"

  // Configuration files
  `include "apb_config.sv"
  `include "uart_config.sv"
  `include "env_config.sv"

  // UART UVC components
  `include "uart_xtn.sv"
  `include "uart_seqs.sv"
  `include "uart_sequencer.sv"
  `include "uart_monitor.sv"
  `include "uart_driver.sv"
  `include "uart_agent.sv"
  `include "uart_agent_top.sv"

  // APB UVC components
  `include "apb_xtn.sv"
  `include "apb_seqs.sv"
  `include "apb_sequencer.sv"
  `include "apb_monitor.sv"
  `include "apb_driver.sv"
  `include "apb_agent.sv"
  `include "apb_agent_top.sv"

  // Environment and testbench components
  `include "sb.sv"
  `include "env.sv"
  `include "test.sv"

endpackage: apb_uart_pkg

