class uart_agent_config extends uvm_object;

  `uvm_object_utils(uart_agent_config)

  // Agent mode: active
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Virtual interface for UART signals
  virtual uart_if vif;

  // Constructor
  function new(string name = "uart_agent_config");
    super.new(name);
  endfunction: new

endclass: uart_agent_config

