class env_config extends uvm_object;
  `uvm_object_utils(env_config)

  apb_agent_config m_cfg[];
  uart_agent_config s_cfg[];

  bit has_agent         = 1;
  int  has_no_of_agent  = 2;
  bit has_virtual_seqr  = 1;
  bit has_scoreboard    = 1;

  function new(string name = "env_config");
    super.new(name);
  endfunction: new

endclass: env_config
