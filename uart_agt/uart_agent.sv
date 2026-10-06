class uart_agent extends uvm_agent;
  `uvm_component_utils(uart_agent)

  uart_agent_config m_cfg;

  uart_driver       drvh;
  uart_monitor      monh;
  uart_sequencer    seqrh;

  function new(string name = "uart_agent", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get agent configuration from config DB
    if (!uvm_config_db #(uart_agent_config)::get(this, "", "uart_agent_config", m_cfg))
      `uvm_fatal("CONFIG", "Cannot get config in uart_agent")

    // Monitor always created in both active/passive mode
    monh = uart_monitor::type_id::create("monh", this);

    // Driver and sequencer created only in active mode
    if (m_cfg.is_active == UVM_ACTIVE) begin
      drvh  = uart_driver::type_id::create("drvh", this);
      seqrh = uart_sequencer::type_id::create("seqrh", this);
    end
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect driver to sequencer in active mode
    if (m_cfg.is_active) begin
      drvh.seq_item_port.connect(seqrh.seq_item_export);
    end
  endfunction: connect_phase

endclass: uart_agent
