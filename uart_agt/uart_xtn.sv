class uart_xtn extends uvm_sequence_item;
  `uvm_object_utils(uart_xtn)

  // UART data fields
  rand bit [7:0] tx;
  bit [7:0]      rx;
  bit            parity;
  rand bit       stop_bit;
  bit            bad_parity;

  // Line Control Register
  bit [7:0] LCR;

  int bits;

  function new(string name = "uart_xtn");
    super.new(name);
  endfunction: new

  function void do_print(uvm_printer printer);
    super.do_print(printer);

    printer.print_field("tx", this.tx, 8, UVM_BIN);
    printer.print_field("rx", this.rx, 8, UVM_BIN);
  endfunction: do_print

  function void post_randomize();
    bits = LCR[1:0] + 5;  // Calculate data bits from LCR

    if (bad_parity == 0) begin
      // Generate correct parity
      if (LCR[3]) begin
        parity = 0;
        for (int i = 0; i < bits; i++) begin
          parity ^= tx[i];
        end
      end
    end
    else begin
      // Generate bad parity for error injection
      parity = ~parity;
    end
  endfunction: post_randomize

endclass: uart_xtn
