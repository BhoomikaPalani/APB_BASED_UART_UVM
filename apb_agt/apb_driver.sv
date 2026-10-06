class apb_driver extends uvm_driver #(apb_xtn);

   `uvm_component_utils(apb_driver)

   // class members
   apb_agent_config      m_cfg;
   virtual apb_if.DRV_MP vif;


   // constructor
   function new(string name = "apb_driver",uvm_component parent);
      super.new(name, parent);
   endfunction: new


   // build_phase
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      if (!uvm_config_db#(apb_agent_config)::get(this,"","apb_agent_config",m_cfg))
         `uvm_fatal("CONFIG","Cannot get config")
   endfunction: build_phase


   // connect_phase
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      vif = m_cfg.vif;
   endfunction: connect_phase


   // run_phase
   task run_phase(uvm_phase phase);

      @(vif.drv_cb);
      vif.drv_cb.Presetn <= 1'b0;

      @(vif.drv_cb);
      vif.drv_cb.Presetn <= 1'b1;

      forever begin
         seq_item_port.get_next_item(req);
         send_to_dut(req);
         seq_item_port.item_done();
      end

   endtask: run_phase


   // send_to_dut task for driving the signals
   task send_to_dut(apb_xtn xtn);

      @(vif.drv_cb);

      vif.drv_cb.Paddr   <= xtn.Paddr;
      vif.drv_cb.Pwdata  <= xtn.Pwdata;
      vif.drv_cb.Pwrite  <= xtn.Pwrite;
      vif.drv_cb.Psel    <= 1'b1;
      vif.drv_cb.Penable <= 1'b0;

      @(vif.drv_cb);
      vif.drv_cb.Penable <= 1'b1;

      @(vif.drv_cb);

      while (!vif.drv_cb.Pready)  //waiting for slave to be ready
         @(vif.drv_cb);

      if (xtn.Paddr == 32'h8 &&
          xtn.Pwrite == 0) begin

         while (vif.drv_cb.IRQ === 0)  //Waiting for interrupt request
            @(vif.drv_cb);

         xtn.iir = vif.drv_cb.Prdata;
         seq_item_port.put_response(xtn);  //Putting response

      end

      vif.drv_cb.Psel    <= 1'b0;
      vif.drv_cb.Penable <= 1'b0;

   endtask: send_to_dut


endclass: apb_driver
