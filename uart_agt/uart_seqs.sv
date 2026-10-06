class uart_base_seqs1 extends uvm_sequence #(uart_xtn);
  `uvm_object_utils(uart_base_seqs1)

  bit [7:0] LCR;

  function new(string name = "uart_base_seqs1");
    super.new(name);
  endfunction: new

  task body();
    if (!uvm_config_db #(bit [7:0])::get(null, get_full_name(), "lcr", LCR))
      `uvm_fatal(get_full_name(), "Cannot get LCR in sequence")
  endtask: body

endclass: uart_base_seqs1


//==============================================================
// UART HALF DUPLEX SEQUENCE
//==============================================================

class uart_half_duplex_sequence extends uart_base_seqs1;
  `uvm_object_utils(uart_half_duplex_sequence)

  function new(string name = "uart_half_duplex_sequence");
    super.new(name);
  endfunction: new

  task body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    start_item(req);
    req.randomize with {stop_bit == 1;};
    finish_item(req);
  endtask: body

endclass: uart_half_duplex_sequence


//==============================================================
// UART FULL DUPLEX SEQUENCE
//==============================================================

class uart_full_duplex_sequence extends uart_base_seqs1;
  `uvm_object_utils(uart_full_duplex_sequence)

  function new(string name = "uart_full_duplex_sequence");
    super.new(name);
  endfunction: new

  task body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    start_item(req);
    req.randomize with {stop_bit == 1;};
    finish_item(req);
  endtask: body

endclass: uart_full_duplex_sequence

//==============================================================
// UART LOOPBACK SEQUENCE
//==============================================================

class uart_loopback_sequence extends uart_base_seqs1;
  `uvm_object_utils(uart_loopback_sequence)

  function new(string name = "uart_loopback_sequence");
    super.new(name);
  endfunction: new

  task body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    start_item(req);
    req.randomize with {stop_bit == 1;};
    finish_item(req);
  endtask: body

endclass: uart_loopback_sequence


//==============================================================
// UART PARITY SEQUENCE
//==============================================================

class uart_sequence_parity extends uart_base_seqs1;
  `uvm_object_utils(uart_sequence_parity)

  function new(string name = "uart_sequence_parity");
    super.new(name);
  endfunction: new

  task body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    req.bad_parity = 1;
    start_item(req);
    req.randomize with {stop_bit == 1;};
    finish_item(req);
  endtask: body

endclass: uart_sequence_parity


//==============================================================
// UART BREAK INTERRUPT SEQUENCE
//==============================================================

class uart_sequence_break_interrupt extends uart_base_seqs1;
  `uvm_object_utils(uart_sequence_break_interrupt)

  function new(string name = "uart_sequence_break_interrupt");
    super.new(name);
  endfunction: new

  task body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    start_item(req);
    req.randomize with {tx == 0; stop_bit == 0;};
    finish_item(req);
  endtask: body

endclass: uart_sequence_break_interrupt


//==============================================================
// UART FRAMING ERROR SEQUENCE
//==============================================================

class uart_sequence_framing_error extends uart_base_seqs1;
  `uvm_object_utils(uart_sequence_framing_error)

  function new(string name = "uart_sequence_framing_error");
    super.new(name);
  endfunction: new

  task body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    repeat (4) begin
      start_item(req);
      req.randomize with {stop_bit == 0;};
      finish_item(req);
    end
  endtask: body

endclass: uart_sequence_framing_error


//==============================================================
// UART OVERRUN SEQUENCE
//==============================================================

class uart_sequence_overrun extends uart_base_seqs1;
  `uvm_object_utils(uart_sequence_overrun)

  function new(string name = "uart_sequence_overrun");
    super.new(name);
  endfunction: new

  task body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    repeat (18) begin
      start_item(req);
      req.randomize() with {stop_bit == 1;};
      finish_item(req);
    end
  endtask: body

endclass: uart_sequence_overrun


//==============================================================
// UART THR EMPTY SEQUENCE
//==============================================================

class uart_thr_empty_sequence extends uart_base_seqs1;
  `uvm_object_utils(uart_thr_empty_sequence)

  function new(string name = "uart_thr_empty_sequence");
    super.new(name);
  endfunction: new

  task body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    start_item(req);
    req.randomize with {tx == 0; stop_bit == 0;};
    finish_item(req);
  endtask: body

endclass: uart_thr_empty_sequence


//==============================================================
// UART TIMEOUT SEQUENCE
//==============================================================

class uart_sequence_timeout extends uart_base_seqs1;
  `uvm_object_utils(uart_sequence_timeout)

  function new(string name = "uart_sequence_timeout");
    super.new(name);
  endfunction: new

  task body();
    super.body();

    req = uart_xtn::type_id::create("req");
    req.LCR = LCR;
    repeat (4) begin
      start_item(req);
      req.randomize() with {stop_bit == 1;};
      finish_item(req);
    end
  endtask: body

endclass: uart_sequence_timeout

