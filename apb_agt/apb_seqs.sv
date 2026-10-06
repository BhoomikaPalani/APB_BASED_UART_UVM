//==============================================================
// APB BASE SEQUENCE
//==============================================================

class base_seqs extends uvm_sequence #(apb_xtn);

  `uvm_object_utils(base_seqs)

  bit [7:0] LCR;

  function new(string name = "base_seqs");
    super.new(name);
  endfunction

  task body();

    if (!uvm_config_db#(bit [7:0])::get(null, get_full_name(), "lcr", LCR))
      `uvm_fatal(get_full_name(), "Cannot get LCR in sequence")

  endtask

endclass


//==============================================================
// APB HALF DUPLEX SEQUENCE
//==============================================================

class apb_agent_half_duplex_sequence extends base_seqs;

  `uvm_object_utils(apb_agent_half_duplex_sequence)

  function new(string name = "apb_agent_half_duplex_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    // Divisor MSB
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 0; });
    finish_item(req);

    // Divisor LSB
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 54; });
    finish_item(req);

    // LCR Configuration
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == LCR; });
    finish_item(req);

    // FIFO Enable
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 32'h6; });
    finish_item(req);

    // Interrupt Enable
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 32'h01; });
    finish_item(req);

  endtask

endclass


//==============================================================
// APB FULL DUPLEX SEQUENCE
//==============================================================

class apb_agent_fullduplex_sequence extends base_seqs;

  `uvm_object_utils(apb_agent_fullduplex_sequence)

  function new(string name = "apb_agent_fullduplex_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 0; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 54; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == LCR; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 32'h6; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 32'h01; });
    finish_item(req);

    // Send Data via THR
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h00; Pwrite == 1; Pwdata inside {[1:255]}; });
    finish_item(req);

  endtask

endclass


//==============================================================
// APB LOOPBACK SEQUENCE
//==============================================================

class apb_agent_loopback_sequence extends base_seqs;

  `uvm_object_utils(apb_agent_loopback_sequence)

  function new(string name = "apb_agent_loopback_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 0; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 54; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == LCR; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 32'h6; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 32'h01; });
    finish_item(req);

    // Enable Loopback
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h10; Pwrite == 1; Pwdata == 8'b00010000; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h00; Pwrite == 1; Pwdata inside {[1:255]}; });
    finish_item(req);

  endtask

endclass


//==============================================================
// APB PARITY ERROR SEQUENCE
//==============================================================

class apb_parity_sequence extends base_seqs;

  `uvm_object_utils(apb_parity_sequence)

  function new(string name = "apb_parity_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 0; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 54; });
    finish_item(req);

    // Enable Parity
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == 8'b00001000; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 8'b00000101; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 8'b00000110; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h00; Pwrite == 1; Pwdata inside {[1:255]}; });
    finish_item(req);

  endtask

endclass

//==============================================================
// APB BREAK ERROR SEQUENCE
//==============================================================

class apb_break_error_sequence extends base_seqs;

  `uvm_object_utils(apb_break_error_sequence)

  function new(string name = "apb_break_error_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    // Divisor MSB
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 32'h1; });
    finish_item(req);

    // Divisor LSB
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 54; });
    finish_item(req);

    // LCR Configuration
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == LCR; });
    finish_item(req);

    // FIFO Enable
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 32'h6; });
    finish_item(req);

    // Interrupt Enable
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 8'b00000101; });
    finish_item(req);

    // Send Data
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h00; Pwrite == 1; Pwdata inside {[1:255]}; });
    finish_item(req);

  endtask

endclass


//==============================================================
// APB FRAMING ERROR SEQUENCE
//==============================================================

class apb_framing_error_sequence extends base_seqs;

  `uvm_object_utils(apb_framing_error_sequence)

  function new(string name = "apb_framing_error_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 32'h1; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 32'h54; });
    finish_item(req);

    // Framing Error LCR Setup
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == 8'b01000011; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 32'h6; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 8'b00000100; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h00; Pwrite == 1; Pwdata inside {[1:255]}; });
    finish_item(req);

  endtask

endclass



//==============================================================
// APB OVERRUN ERROR SEQUENCE
//==============================================================

class apb_overrun_error_sequence extends base_seqs;

  `uvm_object_utils(apb_overrun_error_sequence)

  function new(string name = "apb_overrun_error_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    // DIV1 MSB
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 0; });
    finish_item(req);

    // DIV2 LSB
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 54; });
    finish_item(req);

    // NORMAL_MODE_LCR
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == LCR; });
    finish_item(req);

    // FCR
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 8'b11000110; });
    finish_item(req);

    // IER
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 8'b00000100; });
    finish_item(req);

   repeat (17) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 1; });
      finish_item(req);
    end

    // Read IIR
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 0; });
    finish_item(req);

    get_response(req);

    if (req.iir[3:0] == 4) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 0; });
      finish_item(req);
    end

    if (req.iir[3:0] == 4'h6) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h14; Pwrite == 0; });
      finish_item(req);
    end

    endtask

endclass

//==============================================================
// APB THR EMPTY SEQUENCE
//==============================================================

class thr0_empty_sequence extends base_seqs;

  `uvm_object_utils(thr0_empty_sequence)

  function new(string name = "thr0_empty_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    // DIV1 MSB
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 0; });
    finish_item(req);

    // DIV2 LSB
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 54; });
    finish_item(req);

    // NORMAL_MODE_LCR
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == LCR; });
    finish_item(req);

    // FCR
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 8'b11000110; });
    finish_item(req);

    // IER
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 8'b00000010; });
    finish_item(req);

    // Read IIR
    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 0; });
    finish_item(req);

    get_response(req);

    if (req.iir[3:0] == 4) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 0; });
      finish_item(req);
    end

    if (req.iir[3:0] == 4'h6) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h14; Pwrite == 0; });
      finish_item(req);
    end

  endtask

endclass



//==============================================================
// APB TIMEOUT ERROR SEQUENCE
//==============================================================

class apb_timeout_error_sequence extends base_seqs;

  `uvm_object_utils(apb_timeout_error_sequence)

  function new(string name = "apb_timeout_error_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 0; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 54; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == LCR; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 8'b00000110; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 8'b00000100; });
    finish_item(req);

    // Fill THR
  /*  repeat (17) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 1; });
      finish_item(req);
    end*/

    // Read IIR
   /* start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 0; });
    finish_item(req);

    get_response(req);

    if (req.iir[3:0] == 4) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 0; });
      finish_item(req);
    end

    if (req.iir[3:0] == 4'h6) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h14; Pwrite == 0; });
      finish_item(req);
    end*/

  endtask

endclass


//==============================================================
// APB MULTIPLE CHARACTER 0 SEQUENCE
//==============================================================

class multiple_character0_sequence extends base_seqs;

  `uvm_object_utils(multiple_character0_sequence)

  function new(string name = "multiple_character0_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 0; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 54; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == 8'b01000011; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 32'h6; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 32'h01; });
    finish_item(req);

    repeat (10) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 1; Pwdata inside {[1:255]}; });
      finish_item(req);
    end

    repeat (10) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h08; Pwrite == 0; });
      finish_item(req);
      get_response(req);
    end

    if (req.iir[3:0] == 4) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 0; });
      finish_item(req);
    end

    if (req.iir[3:0] == 4'h6) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h14; Pwrite == 0; });
      finish_item(req);
    end

  endtask

endclass


//==============================================================
// APB MULTIPLE CHARACTER 1 SEQUENCE
//==============================================================

class multiple_character1_sequence extends base_seqs;

  `uvm_object_utils(multiple_character1_sequence)

  function new(string name = "multiple_character1_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h20; Pwrite == 1; Pwdata == 0; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h1c; Pwrite == 1; Pwdata == 27; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h0c; Pwrite == 1; Pwdata == 8'b01000011; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 1; Pwdata == 32'h6; });
    finish_item(req);

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h04; Pwrite == 1; Pwdata == 32'h01; });
    finish_item(req);

    repeat (10) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 1; Pwdata inside {[1:255]}; });
      finish_item(req);
    end

    repeat (10) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h08; Pwrite == 0; });
      finish_item(req);
      get_response(req);
    end

    if (req.iir[3:0] == 4) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 0; });
      finish_item(req);
    end

    if (req.iir[3:0] == 4'h6) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h14; Pwrite == 0; });
      finish_item(req);
    end

  endtask

endclass


//==============================================================
// APB READ SEQUENCE
//==============================================================

class apb_read_sequence extends base_seqs;

  `uvm_object_utils(apb_read_sequence)

  function new(string name = "apb_read_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();

    req = apb_xtn::type_id::create("req");

    start_item(req);
    assert(req.randomize() with { Paddr == 32'h08; Pwrite == 0; });
    finish_item(req);
    get_response(req);

    if (req.iir[3:0] == 4) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 0; });
      finish_item(req);
    end

    if (req.iir[3:0] == 4'h6) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h14; Pwrite == 0; });
      finish_item(req);
    end

    if (req.iir[3:0] == 4'h8) begin
      start_item(req);
      assert(req.randomize() with { Paddr == 32'h00; Pwrite == 0; });
      finish_item(req);
    end

  endtask

endclass


