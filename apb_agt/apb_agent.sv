class apb_agent extends uvm_agent;

  `uvm_component_utils(apb_agent)

  //------------------------------------------
  // Handles of config,driver,monitor and sequencer
  //------------------------------------------

  apb_agent_config  m_cfg;
  apb_driver        drvh;
  apb_monitor       monh;
  apb_sequencer     seqrh;

  //------------------------------------------
  // Constructor
  //------------------------------------------

  function new(string name = "apb_agent", uvm_component parent);
    super.new(name, parent);
  endfunction : new


  //------------------------------------------
  // Build Phase
  //------------------------------------------

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get configuration object
    if (!uvm_config_db#(apb_agent_config)::get(this, "", "apb_agent_config", m_cfg)) begin
      `uvm_fatal("APB_AGENT_CFG","Failed to get apb_agent_config from config_db")
    end

    // Create monitor (always created)
    monh = apb_monitor::type_id::create("monh", this);

    // Create driver & sequencer only if ACTIVE
    if (m_cfg.is_active == UVM_ACTIVE) begin
      drvh  = apb_driver   ::type_id::create("drvh",  this);
      seqrh = apb_sequencer::type_id::create("seqrh", this);
    end

  endfunction : build_phase


  //------------------------------------------
  // Connect Phase
  //------------------------------------------

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (m_cfg.is_active == UVM_ACTIVE) begin
      drvh.seq_item_port.connect(seqrh.seq_item_export);
    end

  endfunction : connect_phase

endclass : apb_agent

