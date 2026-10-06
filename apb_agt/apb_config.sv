class apb_agent_config extends uvm_object;

  `uvm_object_utils(apb_agent_config)


  // Active/Passive control (default ACTIVE)
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Virtual interface handle
  virtual apb_if vif;

  //------------------------------------------
  // Constructor
  //------------------------------------------
  function new(string name = "apb_agent_config");
    super.new(name);
  endfunction : new

endclass : apb_agent_config
