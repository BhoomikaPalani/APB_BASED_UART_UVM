class uart_agent_top extends uvm_env;
  `uvm_component_utils(uart_agent_top)

  env_config    m_tb_cfg;
  uart_agent    agnth[];

  function new(string name = "uart_agent_top", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(env_config)::get(this, "", "env_config", m_tb_cfg))
      `uvm_fatal("CONFIG", "Cannot get env_config")

    agnth = new[1];

    foreach (agnth[i]) begin
      agnth[i] = uart_agent::type_id::create($sformatf("agnth[%0d]", i), this);
      uvm_config_db #(uart_agent_config)::set(this, $sformatf("agnth[%0d]*", i), "uart_agent_config", m_tb_cfg.s_cfg[i]);
    end
  endfunction: build_phase

endclass: uart_agent_top
