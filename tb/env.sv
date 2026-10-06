class env extends uvm_env;
  `uvm_component_utils(env)

  apb_agent_top   m_agt_top;   // APB agent top instance
  uart_agent_top  s_agt_top;   // UART agent top instance
  scoreboard      sb;          // Scoreboard for comparison
  env_config      m_cfg;       // Environment configuration

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get environment configuration from config DB
    if (!uvm_config_db #(env_config)::get(this, "", "env_config", m_cfg))
      `uvm_fatal("CONFIG", "Cannot get env_config")

    // Create agent tops if enabled in config
    if (m_cfg.has_agent) begin
      s_agt_top = uart_agent_top::type_id::create("s_agt_top", this);
      m_agt_top = apb_agent_top::type_id::create("m_agt_top", this);
    end

    // Create scoreboard if enabled in config
    if (m_cfg.has_scoreboard) begin
      sb = scoreboard::type_id::create("sb", this);
    end
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect monitors to scoreboard for comparison
    if (m_cfg.has_scoreboard) begin
      // Connect APB monitor to scoreboard write FIFO
      m_agt_top.agnth[0].monh.monitor_port.connect(sb.fifo_h_w.analysis_export);
      // Connect UART monitor to scoreboard read FIFO
      s_agt_top.agnth[0].monh.monitor_port.connect(sb.fifo_h_r.analysis_export);
    end
  endfunction: connect_phase

endclass: env
