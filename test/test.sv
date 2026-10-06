class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  // Data members
  bit [7:0] lcr;

  env              envh;
  env_config       m_cfg;
  apb_agent_config m_agt_cfg[];
  uart_agent_config s_agt_cfg[];

  bit   has_agent        = 1;
  int   has_no_of_agent  = 1;
  bit   has_virtual_seqr = 1;
  bit   has_scoreboard   = 1;

  // Constructor
  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Configure test environment components
  function void config_test();
    if (has_agent) begin: master_agent_config
      m_agt_cfg = new[has_no_of_agent];
      s_agt_cfg = new[has_no_of_agent];

      foreach (m_agt_cfg[i]) begin: master_agent_loop
        m_agt_cfg[i] = apb_agent_config::type_id::create(
                          $sformatf("m_agt_cfg[%0d]", i));

        if (!uvm_config_db #(virtual apb_if)::get(this, "", "avif",m_agt_cfg[i].vif)) begin
          `uvm_fatal("VIF_CONFIG_WRITE","Cannot get() interface vif from uvm_config_db. Have you set it?")
        end

        m_agt_cfg[i].is_active = UVM_ACTIVE;
        m_cfg.m_cfg[i] = m_agt_cfg[i];
      end: master_agent_loop
    end: master_agent_config

    if (has_agent) begin: slave_agent_config
      s_agt_cfg = new[has_no_of_agent];

      foreach (s_agt_cfg[i]) begin: slave_agent_loop
        s_agt_cfg[i] = uart_agent_config::type_id::create($sformatf("s_agt_cfg[%0d]", i));

        if (!uvm_config_db #(virtual uart_if)::get(this, "", "uvif",s_agt_cfg[i].vif)) begin
          `uvm_fatal("VIF_CONFIG_WRITE","Cannot get() interface vif from uvm_config_db. Have you set it?")
        end

        s_agt_cfg[i].is_active = UVM_ACTIVE;
        m_cfg.s_cfg[i] = s_agt_cfg[i];
      end: slave_agent_loop
    end: slave_agent_config

    m_cfg.has_agent        = has_agent;
    m_cfg.has_no_of_agent  = has_no_of_agent;
    m_cfg.has_virtual_seqr = has_virtual_seqr;
    m_cfg.has_scoreboard   = has_scoreboard;
  endfunction: config_test

  // Build phase - create and configure testbench components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_cfg = env_config::type_id::create("m_cfg", this);

    if (has_agent) begin: create_agent_configs
      m_cfg.m_cfg = new[has_no_of_agent];
      m_cfg.s_cfg = new[has_no_of_agent];
    end: create_agent_configs

    config_test();

    uvm_config_db #(env_config)::set(this, "*", "env_config", m_cfg);
    uvm_config_db #(bit [7:0])::set(this, "*", "lcr", lcr);

    envh = env::type_id::create("envh", this);
  endfunction: build_phase

  // Print UVM topology at end of elaboration
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction: end_of_elaboration_phase

endclass: base_test


class half_duplex_test extends base_test;

  `uvm_component_utils(half_duplex_test)

  // Data members
  apb_agent_half_duplex_sequence hdseq0;
  apb_read_sequence              read1;
  uart_half_duplex_sequence      seq1;

  // Constructor
  function new(string name = "half_duplex_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build phase - configure test parameters
  function void build_phase(uvm_phase phase);
    lcr = 8'h03;
    super.build_phase(phase);
  endfunction: build_phase

  // Main test execution
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    // Create sequences
    seq1   = uart_half_duplex_sequence::type_id::create("seq1");
    hdseq0 = apb_agent_half_duplex_sequence::type_id::create("hdseq0");
    read1  = apb_read_sequence::type_id::create("read1");

    phase.raise_objection(this);

    hdseq0.start(envh.m_agt_top.agnth[0].seqrh);
    seq1.start(envh.s_agt_top.agnth[0].seqrh);
    read1.start(envh.m_agt_top.agnth[0].seqrh);

    #200000;
    phase.drop_objection(this);
  endtask: run_phase

endclass: half_duplex_test


class full_duplex_test extends base_test;

  `uvm_component_utils(full_duplex_test)

  // Data members
  apb_read_sequence               read1;
  apb_agent_fullduplex_sequence   fdseq0;
  uart_full_duplex_sequence       seq1;

  // Constructor
  function new(string name = "full_duplex_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build phase - configure test parameters
  function void build_phase(uvm_phase phase);
    lcr = 8'h03;
    super.build_phase(phase);
  endfunction: build_phase

  // Main test execution
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    // Create sequences
    fdseq0 = apb_agent_fullduplex_sequence::type_id::create("fdseq0");
    seq1   = uart_full_duplex_sequence::type_id::create("seq1");
    read1  = apb_read_sequence::type_id::create("read1");

    fdseq0.start(envh.m_agt_top.agnth[0].seqrh);
    seq1.start(envh.s_agt_top.agnth[0].seqrh);
    read1.start(envh.m_agt_top.agnth[0].seqrh);

    #20000;
    phase.drop_objection(this);
  endtask: run_phase

endclass: full_duplex_test


class loopback_test extends base_test;

  `uvm_component_utils(loopback_test)

  // Data members
  apb_agent_loopback_sequence           lbseq0;
  uart_loopback_sequence                seq1;
  apb_read_sequence                     read1;

  // Constructor
  function new(string name = "loopback_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build phase - configure test parameters
  function void build_phase(uvm_phase phase);
    lcr = 32'h03;
    super.build_phase(phase);
  endfunction: build_phase

  // Main test execution
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    // Create sequences
    lbseq0 = apb_agent_loopback_sequence::type_id::create("lbseq0");
    seq1   = uart_loopback_sequence::type_id::create("seq1");
    read1  = apb_read_sequence::type_id::create("read1");

    lbseq0.start(envh.m_agt_top.agnth[0].seqrh);
    seq1.start(envh.s_agt_top.agnth[0].seqrh);
    read1.start(envh.m_agt_top.agnth[0].seqrh);

    #20000;
    phase.drop_objection(this);
  endtask: run_phase

endclass: loopback_test


class parity_error_test extends base_test;

  `uvm_component_utils(parity_error_test)

  // Data members
  apb_parity_sequence              pseq0;
  uart_sequence_parity             seq1;
  apb_read_sequence                read1;

  // Constructor
  function new(string name = "parity_error_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build phase - configure test parameters
  function void build_phase(uvm_phase phase);
    lcr = 8'h00;
    super.build_phase(phase);
  endfunction: build_phase

  // Main test execution
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    // Create sequences
    pseq0 = apb_parity_sequence::type_id::create("pseq0");
    seq1  = uart_sequence_parity::type_id::create("seq1");
    read1 = apb_read_sequence::type_id::create("read1");

    pseq0.start(envh.m_agt_top.agnth[0].seqrh);
    seq1.start(envh.s_agt_top.agnth[0].seqrh);
    read1.start(envh.m_agt_top.agnth[0].seqrh);

    #20000;
    phase.drop_objection(this);
  endtask: run_phase

endclass: parity_error_test


class break_interrupt_test extends base_test;

  `uvm_component_utils(break_interrupt_test)

  // Data members
  apb_break_error_sequence         bseq0;
  uart_sequence_break_interrupt    seq1;
  apb_read_sequence                read1;

  // Constructor
  function new(string name = "agnt_h", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build phase - configure test parameters
  function void build_phase(uvm_phase phase);
    lcr = 8'd67;
    super.build_phase(phase);
  endfunction: build_phase

  // Main test execution
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    // Create sequences
    bseq0 = apb_break_error_sequence::type_id::create("bseq0");
    seq1  = uart_sequence_break_interrupt::type_id::create("seq1");
    read1 = apb_read_sequence::type_id::create("read1");

    bseq0.start(envh.m_agt_top.agnth[0].seqrh);
    seq1.start(envh.s_agt_top.agnth[0].seqrh);
    read1.start(envh.m_agt_top.agnth[0].seqrh);

    #20000;
    phase.drop_objection(this);
  endtask: run_phase

endclass: break_interrupt_test


class framing_error_test extends base_test;

  `uvm_component_utils(framing_error_test)

  // Data members
  apb_framing_error_sequence            fseq0;
  apb_read_sequence                     read1;
  uart_sequence_framing_error           seq1;

  // Constructor
  function new(string name = "framing_error_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build phase - configure test parameters
  function void build_phase(uvm_phase phase);
    lcr = 8'h02;
    super.build_phase(phase);
  endfunction: build_phase

  // Main test execution
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    // Create sequences
    seq1  = uart_sequence_framing_error::type_id::create("seq1");
    read1 = apb_read_sequence::type_id::create("read1");
    fseq0 = apb_framing_error_sequence::type_id::create("fseq0");

    fseq0.start(envh.m_agt_top.agnth[0].seqrh);
    seq1.start(envh.s_agt_top.agnth[0].seqrh);
    read1.start(envh.m_agt_top.agnth[0].seqrh);

    #20000;
    phase.drop_objection(this);
  endtask: run_phase

endclass: framing_error_test


class overrun_error_test extends base_test;

  `uvm_component_utils(overrun_error_test)

  // Data members
  apb_overrun_error_sequence       oseq0;
  uart_sequence_overrun            seq1;
  apb_read_sequence                read1;

  // Constructor
  function new(string name = "overrun_error_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build phase - configure test parameters
  function void build_phase(uvm_phase phase);
    lcr = 2'b11;
    super.build_phase(phase);
  endfunction: build_phase

  // Main test execution
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    // Create sequences
    oseq0 = apb_overrun_error_sequence::type_id::create("oseq0");
    seq1  = uart_sequence_overrun::type_id::create("seq1");
    read1 = apb_read_sequence::type_id::create("read1");

    fork
    oseq0.start(envh.m_agt_top.agnth[0].seqrh);
    seq1.start(envh.s_agt_top.agnth[0].seqrh);
   // read1.start(envh.m_agt_top.agnth[0].seqrh);
    join

    #20000;
    phase.drop_objection(this);
  endtask: run_phase

endclass: overrun_error_test


class thr_empty_test extends base_test;

  `uvm_component_utils(thr_empty_test)

  // Data members
  thr0_empty_sequence           thrseq0;
  uart_thr_empty_sequence       seq1;

  // Constructor
  function new(string name = "thr_empty_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build phase - configure test parameters
  function void build_phase(uvm_phase phase);
    lcr = 8'h03;
    super.build_phase(phase);
  endfunction: build_phase

  // Main test execution
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    // Create sequences
    thrseq0 = thr0_empty_sequence::type_id::create("thrseq0");
    seq1    = uart_thr_empty_sequence::type_id::create("seq1");

    fork
      thrseq0.start(envh.m_agt_top.agnth[0].seqrh);
      seq1.start(envh.s_agt_top.agnth[0].seqrh);
    join

    #20000;
    phase.drop_objection(this);
  endtask: run_phase


endclass: thr_empty_test


class timeout_error_test extends base_test;

  `uvm_component_utils(timeout_error_test)

  // Data members
  apb_timeout_error_sequence teseq0;
  uart_sequence_timeout      seq1;
  apb_read_sequence          read1;

  // Constructor
  function new(string name = "timeout_error_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Build phase - configure test parameters
  function void build_phase(uvm_phase phase);
    lcr = 8'b00001011;
    super.build_phase(phase);
  endfunction: build_phase

  // Main test execution
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    // Create sequences
    teseq0 = apb_timeout_error_sequence::type_id::create("teseq0");
    seq1   = uart_sequence_timeout::type_id::create("seq1");
    read1 = apb_read_sequence::type_id::create("read1");

      teseq0.start(envh.m_agt_top.agnth[0].seqrh);
      seq1.start(envh.s_agt_top.agnth[0].seqrh);
      read1.start(envh.m_agt_top.agnth[0].seqrh);

    #20000;
    phase.drop_objection(this);
  endtask: run_phase

endclass: timeout_error_test

/*
class multiple_characters_test extends base_test;

  `uvm_component_utils(multiple_characters_test)

  // Data members
  multiple_character0_sequence mcseq0;
  multiple_character1_sequence mcseq1;

  // Constructor
  function new(string name = "multiple_characters_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  // Main test execution
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    phase.raise_objection(this);

    // Create sequences
    mcseq0 = multiple_character0_sequence::type_id::create("mcseq0");
    mcseq1 = multiple_character1_sequence::type_id::create("mcseq1");

    fork
      mcseq0.start(envh.m_agt_top.agnth[0].seqrh);
      mcseq1.start(envh.m_agt_top.agnth[1].seqrh);
    join

    #20000;
    phase.drop_objection(this);
  endtask: run_phase

endclass: multiple_characters_test*/

