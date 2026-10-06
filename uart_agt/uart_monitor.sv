class uart_monitor extends uvm_monitor;
  `uvm_component_utils(uart_monitor)

  uart_agent_config m_cfg;
  virtual uart_if   vif;

  uart_xtn          r_xtn;
  bit [7:0]         LCR;

  uvm_analysis_port#(uart_xtn) monitor_port;

  function new(string name = "uart_monitor", uvm_component parent);
    super.new(name, parent);
    monitor_port = new("monitor_port", this);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(uart_agent_config)::get(this, "", "uart_agent_config", m_cfg))
      `uvm_fatal("CONFIG", "Cannot get config in uart_monitor")

    if (!uvm_config_db #(bit [7:0])::get(this, "*", "lcr", LCR))
      `uvm_fatal("UART_MON", "Cannot get LCR in monitor")

    r_xtn = uart_xtn::type_id::create("r_xtn");
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.vif;
  endfunction: connect_phase

  task run_phase(uvm_phase phase);
    bit rx_busy, tx_busy;

    fork
      // Monitor RX line
      forever begin
        if (rx_busy == 1'b0) begin
          rx_busy = 1'b1;
          collect_uart(vif.rx, r_xtn.rx, r_xtn.parity);
          rx_busy = 1'b0;
        end
        else begin
          @(posedge vif.baud_o);
        end
      end

      // Monitor TX line
      forever begin
        if (tx_busy == 1'b0) begin
          tx_busy = 1'b1;
          collect_uart(vif.tx, r_xtn.tx, r_xtn.parity);
          tx_busy = 1'b0;
        end
        else begin
          @(posedge vif.baud_o);
        end
      end
    join
  endtask: run_phase

  // Collect UART transaction from serial line
  task collect_uart(ref logic line, ref bit [7:0] data, ref bit parity);
    int bits;

    bits = LCR[1:0] + 5;  // Calculate number of data bits

    wait (line == 1'b1);
    @(posedge vif.baud_o);
    wait (line == 1'b0);  // Wait for start bit

    repeat (24) @(posedge vif.baud_o);

    // Collect data bits
    for (int i = 0; i < bits; i++) begin
      data[i] = line;
      repeat (16) @(posedge vif.baud_o);
    end

    // Collect parity bit if enabled
    if (LCR[3]) begin
      parity = line;
    end

    // Wait for stop bit
    repeat (16) @(posedge vif.baud_o);

    `uvm_info(get_type_name(), $sformatf("monitor data=%0b", data), UVM_LOW)
    monitor_port.write(r_xtn);
  endtask: collect_uart


endclass: uart_monitor

