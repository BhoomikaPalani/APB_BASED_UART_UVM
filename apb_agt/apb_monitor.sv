class apb_monitor extends uvm_monitor;

   `uvm_component_utils(apb_monitor)

   // Agent configuration handle
   apb_agent_config            m_cfg;

   // Virtual interface (monitor modport)
   virtual apb_if.MON_MP       vif;

   // Transaction object
   apb_xtn                     xtn;

   // Analysis port to send collected transactions
   uvm_analysis_port #(apb_xtn) monitor_port;


   function new(string name = "apb_monitor",uvm_component parent);
      super.new(name, parent);
      monitor_port = new("monitor_port", this);
   endfunction : new


   function void build_phase(uvm_phase phase);

      super.build_phase(phase);

      // Get agent configuration
      if (!uvm_config_db#(apb_agent_config)::get(this, "", "apb_agent_config", m_cfg))
         `uvm_fatal("config","cannot get apb_agent_config")

      // Create transaction object
      xtn = apb_xtn::type_id::create("xtn");

   endfunction : build_phase


   function void connect_phase(uvm_phase phase);

      super.connect_phase(phase);
      vif = m_cfg.vif;

   endfunction : connect_phase


   task run_phase(uvm_phase phase);

      forever begin : monitor_loop
         collect_data();
      end : monitor_loop

   endtask : run_phase


   // --------------------------------------------------
   // Task : collect_data
   // Collects one complete APB transfer
   // --------------------------------------------------
   task collect_data();

      @(vif.mon_cb);

      // Wait for enable phase
      while (vif.mon_cb.Penable !== 1)
         @(vif.mon_cb);

      begin : transfer_capture

         // Wait for ready
         while (vif.mon_cb.Pready !== 1)
            @(vif.mon_cb);

         // Sample common signals
         xtn.Presetn  = vif.mon_cb.Presetn;
         xtn.Paddr    = vif.mon_cb.Paddr;
         xtn.Pwrite   = vif.mon_cb.Pwrite;
         xtn.Pslverr  = vif.mon_cb.Pslverr;
         xtn.Psel     = vif.mon_cb.Psel;
         xtn.Penable  = vif.mon_cb.Penable;
         xtn.IRQ      = vif.mon_cb.IRQ;

         // Sample data phase
         if (xtn.Pwrite)
            xtn.Pwdata = vif.mon_cb.Pwdata;
         else
            xtn.Prdata = vif.mon_cb.Prdata;


         // --------------------------------------------------
         // Register updates based on address decoding
         // --------------------------------------------------

         // LCR update
         if (xtn.Paddr == 32'hc &&
             xtn.Pwrite == 1'b1)
            xtn.lcr = xtn.Pwdata;

         // IER update
         if (xtn.Paddr == 32'h4 &&
             xtn.Pwrite == 1'b1)
            xtn.ier = xtn.Pwdata;

         // FCR update
         if (xtn.Paddr == 32'h8 &&
             xtn.Pwrite == 1'b1)
            xtn.fcr = xtn.Pwdata;

         // IIR read
         if (xtn.Paddr == 32'h8 &&
             xtn.Pwrite == 1'b0) begin : iir_block

            while (vif.mon_cb.IRQ !== 1)
               @(vif.mon_cb);

            xtn.iir = vif.mon_cb.Prdata;

         end : iir_block


         // MCR update
         if (xtn.Paddr == 32'h10 &&
             xtn.Pwrite == 1'b1)
            xtn.mcr = xtn.Pwdata;

         // LSR read
         if (xtn.Paddr == 32'h14 &&
             xtn.Pwrite == 1'b0)
            xtn.lsr = xtn.Prdata;


         // Divisor register 1 update
         if (xtn.Paddr == 32'h1c &&
             xtn.Pwrite == 1'b1) begin : divisor_lsb

            xtn.divisor[7:0] = xtn.Pwdata;
            xtn.dl_access    = 1'b1;

         end : divisor_lsb


         // Divisor register 2 update
         if (xtn.Paddr == 32'h20 &&
             xtn.Pwrite == 1'b1) begin : divisor_msb

            xtn.divisor[15:8] = xtn.Pwdata;
            xtn.dl_access     = 1'b1;

         end : divisor_msb


         // THR write
         if (xtn.Paddr == 32'h0 &&
             xtn.Pwrite == 1'b1) begin : thr_block

            xtn.data_in_thr = 1'b1;
            xtn.thr.push_back(xtn.Pwdata);

         end : thr_block


         // RBR read
         if (xtn.Paddr == 32'h0 &&
             xtn.Pwrite == 1'b0) begin : rbr_block

            xtn.data_in_rbr = 1'b1;
            xtn.rbr.push_back(xtn.Prdata);

         end : rbr_block

      end : transfer_capture


      // Send collected transaction to scoreboard
      monitor_port.write(xtn);

   endtask : collect_data


endclass : apb_monitor
