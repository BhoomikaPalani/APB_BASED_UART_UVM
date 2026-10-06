class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  env_config m_cfg;  // Environment configuration

  // Analysis FIFOs to receive transactions from monitors
  uvm_tlm_analysis_fifo #(apb_xtn) fifo_h_w;  // FIFO for APB write transactions
  uvm_tlm_analysis_fifo #(uart_xtn) fifo_h_r;  // FIFO for UART read transactions

  apb_xtn uart1;   // APB transaction from monitor
  uart_xtn uart2, uart3;  // UART transactions from monitor
  apb_xtn cov_data1;  // Data for APB coverage
  uart_xtn cov_data2;  // Data for UART coverage
  bit [7:0] rx[$], tx[$];  // Queues for received and transmitted data
  int thr1size, rbr1size;  // Size of THR and RBR queues

  // Coverage group for basic APB signals
  covergroup apb_signals_cov;
    option.per_instance = 1;

    ADDRESS: coverpoint cov_data1.Paddr { bins add = {[0:255]}; }

    // DATA: coverpoint cov_data.addr_i[2:0] { bins addr_sign = {[0:7]}; }

    WR_ENB: coverpoint cov_data1.Pwrite { bins rd = {0};
                                          bins wr = {1}; }
    // ERROR: coverpoint cov_data.Pslverr {bins p1={0};
    //                                          bins p2 = {1};}
  endgroup

  // Coverage group for LCR register fields
  covergroup apb_lcr_cov;
    option.per_instance = 1;

    CHAR_SIZE: coverpoint cov_data1.lcr[1:0] { bins five  = {2'b00};
                                               bins eight = {2'b11}; }

    STOP_BIT: coverpoint cov_data1.lcr[2] { bins one  = {1'b0};
                                            bins more = {1'b1}; }

    PARITY: coverpoint cov_data1.lcr[3] { bins no_parity  = {1'b0};
                                          bins parity_en  = {1'b1}; }

    EV_ODD_PARITY: coverpoint cov_data1.lcr[4] { bins odd_parity  = {1'b0};
                                                 bins even_parity = {1'b1}; }

    // STICK_PARITY: coverpoint cov_data.lcr[5] { bins no_stick_parity = {1'b0};
    //                                       bins stick_parity = {1'b1}; }

    // BREAK: coverpoint cov_data.lcr[6] { bins low = {1'b0};
    //   bins high = {1'b1}; }

    // DIV_LCH: coverpoint cov_data.lcr[7] { bins low = {1'b0};
    //   bins high = {1'b1}; }

    // LCR_RST: coverpoint cov_data.lcr[7:0] { bins lcr_rst = {8'd3};}

    // CHAR_SIZE_X_STOP_BIT_X_EV_ODD_PARITY: cross CHAR_SIZE,STOP_BIT,EV_ODD_PARITY;
  endgroup

  // Coverage group for IER register
  covergroup apb_ier_cov;
    option.per_instance = 1;

    RCVD_INT: coverpoint cov_data1.ier[0] { bins dis = {1'b0};
                                            bins en  = {1'b1}; }

    THRE_INT: coverpoint cov_data1.ier[1] { bins dis = {1'b0};
                                            bins en  = {1'b1}; }

    LSR_INT: coverpoint cov_data1.ier[2] { bins dis = {1'b0};
                                           bins en  = {1'b1}; }

    IER_RST: coverpoint cov_data1.ier[7:0] { bins ier_rst = {8'd0}; }
  endgroup

  // Coverage group for FCR register
  covergroup apb_fcr_cov;
    option.per_instance = 1;

    RFIFO: coverpoint cov_data1.fcr[1] { bins dis = {1'b0};
                                         bins clr = {1'b1}; }

    TFIFO: coverpoint cov_data1.fcr[2] { bins dis = {1'b0};
                                         bins clr = {1'b1}; }

    TRG_LVL: coverpoint cov_data1.fcr[7:6] { bins one      = {2'b00};
                                             // bins four = {2'b01};
                                             bins eight    = {2'b10};
                                             bins fourteen = {2'b11}; }

    // FCR_RST: coverpoint cov_data.fcr[7:0] { bins fcr_rst = {8'd192};}
  endgroup

  // Coverage group for MCR register
  covergroup apb_mcr_cov;
    option.per_instance = 1;

    LB: coverpoint cov_data1.mcr[4] { bins dis = {1'b0};
                                      bins en  = {1'b1}; }

    MCR_RST: coverpoint cov_data1.mcr[7:0] { bins lcr_rst = {8'd0}; }
  endgroup

  // Coverage group for IIR register
  covergroup apb_iir_cov;
    option.per_instance = 1;

    IIR: coverpoint cov_data1.iir[3:1] { bins lsr  = {3'b011};
                                         bins rdf  = {3'b010};
                                         bins ti_o = {3'b110}; }

    // IIR_RST: coverpoint cov_data.iir[3:0] { bins iir_rst = {4'h1};}
  endgroup

  // Coverage group for LSR register
  covergroup apb_lsr_cov;
    option.per_instance = 1;

    DATA_READY: coverpoint cov_data1.lsr[0] { bins fifoempty = {1'b0};
                                              bins datarcvd  = {1'b1}; }

    OVER_RUN: coverpoint cov_data1.lsr[1] { bins nooverrun = {1'b0};
                                            bins overrun   = {1'b1}; }

    PARITY_ERR: coverpoint cov_data1.lsr[2] { bins noparityerr = {1'b0};
                                              bins parityerr   = {1'b1}; }

    FRAME_ERR: coverpoint cov_data1.lsr[3] { bins frameerr = {1'b0}; }

    BREAK_INT: coverpoint cov_data1.lsr[4] { bins nobreakint = {1'b0};
                                             bins breakint   = {1'b1}; }

    b1: coverpoint cov_data1.lsr[5] { bins a1 = {1'b0};
                                      bins a2 = {1'b1}; }
  endgroup

  // Constructor
  function new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    apb_signals_cov = new();
    apb_lcr_cov = new();
    apb_ier_cov = new();
    apb_fcr_cov = new();
    apb_mcr_cov = new();
    apb_iir_cov = new();
    apb_lsr_cov = new();
  endfunction: new

  // Build phase - get config and create FIFOs
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(env_config)::get(this, "", "env_config", m_cfg))
      `uvm_fatal("CONFIG", "Cannot get config")
    fifo_h_w = new("fifo_h_w", this);
    fifo_h_r = new("fifo_h_r", this);
  endfunction: build_phase

  // Run phase - process transactions from both FIFOs
  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    begin
      fork
        // Process APB transactions
        forever begin
          fifo_h_w.get(uart1);
          uart1.print;
          thr1size = uart1.thr.size;
          rbr1size = uart1.rbr.size;
          `uvm_info("SCOREBOARD", $sformatf("PRINTING FROM SCOREBOARD OF UART1 \n %s", uart1.sprint()), UVM_LOW)
          cov_data1 = uart1;
        end

        // Process UART transactions
        forever begin
          fifo_h_r.get(uart2);
          `uvm_info("SB UART2", "PRINTING UART2 DATA IN SCOREBOARD", UVM_LOW)
          uart2.print;
          cov_data2 = uart2;
          `uvm_info("SCOREBOARD", $sformatf("PRINTING FROM SCOREBOARD OF UART2 \n %s", uart2.sprint()), UVM_LOW)
        end
      join
    end


        cov_data1=uart1;
        apb_signals_cov.sample();
        apb_lcr_cov.sample();
        apb_ier_cov.sample();
        apb_fcr_cov.sample();
        apb_mcr_cov.sample();
        apb_iir_cov.sample();
        apb_lsr_cov.sample();

  endtask: run_phase

  // Check phase - compare transactions and report results
  function void check_phase(uvm_phase phase);

	 if (uart1 == null) begin
    `uvm_warning("SCOREBOARD",
                 "No APB transaction received. uart1 is NULL.")
    return;
  end

  if (uart2 == null) begin
    `uvm_warning("SCOREBOARD",
                 "No UART transaction received. uart2 is NULL.")
    return;
  end
    `uvm_info(get_type_name(), $sformatf("size of thr 1 = %0d", thr1size), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("size of rbr 1 = %0d", rbr1size), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("values sent by UART1 = %p", uart1.thr), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("values sent by UART2 = %p", uart2.tx), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("values received by UART1 = %p", uart1.rbr), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("values received by UART2 = %p", uart2.rx), UVM_LOW)


    // Check for half duplex, full duplex, and loopback modes
    if ((uart1.iir[3:1] == 3'b010)) begin
      if ((uart1.mcr[4] == 0)) begin
        if (uart1.thr.size() == 0) begin
          if ((uart1.Pwdata[7:0] == uart2.rx) || (uart2.tx == uart1.Prdata[7:0]))
            `uvm_info(get_type_name(), "\nIn scoreboard half duplex comparison passed", UVM_LOW)
          else
            `uvm_info(get_type_name(), "\nIn scoreboard half duplex comparison failed", UVM_LOW)
        end
        // end
        else begin
          if ((uart1.Pwdata[7:0] == uart2.rx) && (uart2.tx == uart1.Prdata[7:0]))
            `uvm_info(get_type_name(), "\nIn scoreboard full duplex comparison passed", UVM_LOW)
          else
            `uvm_info(get_type_name(), "\nIn scoreboard full duplex comparison failed", UVM_LOW)
        end
      end
      // end
      else begin
        if ((uart1.Pwdata[7:0] == uart1.Prdata[7:0]))
          `uvm_info(get_type_name(), "\nIn scoreboard loop back comparison passed", UVM_LOW)
        else
          `uvm_info(get_type_name(), "\nIn scoreboard loop back comparison failed", UVM_LOW)
        // end
      end
    end

    // Check for various error conditions
    if ((uart1.iir[3:1] == 3)) begin
      if ((uart1.lsr[1] == 1))
        `uvm_info(get_type_name(), "\nIn scoreboard overrun error", UVM_LOW)
      if ((uart1.lsr[2] == 1))
        `uvm_info(get_type_name(), "\nIn scoreboard parity error", UVM_LOW)
      if ((uart1.lsr[3] == 1))
        `uvm_info(get_type_name(), "\nIn scoreboard framing error", UVM_LOW)
      if ((uart1.lsr[4] == 1))
        `uvm_info(get_type_name(), "\nIn scoreboard break interrupt error", UVM_LOW)
    end
    if ((uart1.iir[3:1] == 3'b110))
      `uvm_info(get_type_name(), "\nIn scoreboard timeout error", UVM_LOW)
    if ((uart1.iir[3:1] == 3'b001))
      `uvm_info(get_type_name(), "\nIn scoreboard thr empty error", UVM_LOW)

  endfunction: check_phase

endclass: scoreboard
