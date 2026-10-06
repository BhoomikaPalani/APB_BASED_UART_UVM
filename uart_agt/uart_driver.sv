class uart_driver extends uvm_driver #(uart_xtn);
  `uvm_component_utils(uart_driver)

  uart_agent_config    m_cfg;
  bit [7:0]            LCR;
  virtual uart_if      vif;

  function new(string name = "uart_driver", uvm_component parent);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(uart_agent_config)::get(this, "", "uart_agent_config", m_cfg))
      `uvm_fatal("CONFIG", "Cannot get config in uart_driver")

    if (!uvm_config_db #(bit [7:0])::get(this, "*", "lcr", LCR))
      `uvm_fatal("UART_DRV", "Cannot get LCR in driver")
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.vif;
  endfunction: connect_phase

  task run_phase(uvm_phase phase);
    vif.tx = 1'b1;

    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info("UART_DRIVER", "PRINTING FROM UART SEQUENCE", UVM_LOW)
      req.print();
      send_to_dut(req);
      seq_item_port.item_done();
    end
  endtask: run_phase

  task send_tx(bit b);
    vif.tx <= b;
    repeat(16) @(posedge vif.baud_o);
  endtask: send_tx

//Send to dut task
  task send_to_dut(uart_xtn xtn);
    int bits;
//    bit parity;

    // Calculate number of data bits based on LCR settings
    bits = LCR[1:0] + 5;   // 00->5, 01->6, 10->7, 11->8

    repeat(16) @(posedge vif.baud_o);
    vif.tx <= 0;            // Start bit

    repeat(16) @(posedge vif.baud_o);  // Wait one bit period

    // Send data bits
    for (int i = 0; i < bits; i++) begin
      send_tx(xtn.tx[i]);
    end

    // Parity bit (if enabled)
    if (LCR[3]) begin
      send_tx(xtn.parity);
    end

    // Stop bit
    send_tx(xtn.stop_bit);

    // Additional wait for specific configurations
    if (LCR[2] == 1) begin
      if (LCR[1:0] == 2'b00) begin
        repeat(8) @(posedge vif.baud_o);
      end
    end
  endtask: send_to_dut

endclass: uart_driver
