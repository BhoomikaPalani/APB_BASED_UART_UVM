module tb_top;

  import uvm_pkg::*;
  import apb_uart_pkg::*;
  `include "uvm_macros.svh"

  // Clock and reset generation
  bit clk1;       // 100 MHz clock for APB and UART RTL
  bit clk2;       // 50 MHz clock for UART VIP
  bit PRESETn;    // Active low reset

  // Generate 100 MHz clock (10ns period)
  always #5 clk1 = ~clk1;

  // Generate 50 MHz clock (20ns period)
  always #10 clk2 = ~clk2;

  // Reset sequence
  initial begin
    clk1 = 0;
    clk2 = 0;
    PRESETn = 0;  // Assert reset
    #100;
    PRESETn = 1;  // De-assert reset after 100ns
  end

  // Interface instances
  apb_if in0(clk1);   // APB interface for DUT
  uart_if in1();      // UART interface for VIP

  // UART VIP baud rate generator
  // -----------------------------
  localparam int clk_freq   = 50000000;  // VIP clock frequency (50 MHz)
  localparam int BAUD_RATE  = 115200;    // Target baud rate
  localparam int SAMPLE     = 16;        // Oversampling factor

  // Calculate baud rate divisor
  localparam int DIVISOR = clk_freq / (BAUD_RATE * SAMPLE);

  int baud_cnt;

  // Generate baud tick for UART VIP
  always_ff @(posedge clk2 or negedge PRESETn) begin
    if (!PRESETn) begin
      baud_cnt      <= 0;
      in1.baud_o    <= 1'b0;
    end
    else if (baud_cnt == DIVISOR - 1) begin
      baud_cnt      <= 0;
      in1.baud_o    <= 1'b1;  // Generate one-cycle baud tick
    end
    else begin
      baud_cnt      <= baud_cnt + 1;
      in1.baud_o    <= 1'b0;
    end
  end

  // DUT instantiation
  // Connect APB interface to DUT and UART interface for serial communication
  uart_16550 dut1 (
    .PCLK    (clk1),
    .PRESETn (in0.Presetn),
    .PADDR   (in0.Paddr),
    .PWDATA  (in0.Pwdata),
    .PRDATA  (in0.Prdata),
    .PWRITE  (in0.Pwrite),
    .PENABLE (in0.Penable),
    .PSEL    (in0.Psel),
    .PREADY  (in0.Pready),
    .PSLVERR (in0.Pslverr),
    .IRQ     (in0.IRQ),
    .TXD     (in1.rx),   // DUT transmit to VIP receive
    .RXD     (in1.tx)    // VIP transmit to DUT receive
  );

  // UVM test initialization
  initial begin
    `ifdef VCS
      $fsdbDumpvars(0, tb_top);  // Enable waveform dumping for VCS
    `endif

    // Set virtual interfaces in UVM config DB
    uvm_config_db #(virtual apb_if)::set(null, "*", "avif", in0);
    uvm_config_db #(virtual uart_if)::set(null, "*", "uvif", in1);

    // Start UVM test
    run_test();
  end

endmodule: tb_top
