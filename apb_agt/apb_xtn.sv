class apb_xtn extends uvm_sequence_item;

   `uvm_object_utils(apb_xtn)

   //Declare all the signals
        bit              Presetn;
   rand bit [31:0]       Paddr;
        bit              Psel;
   rand bit              Pwrite;
        bit              Penable;
   rand bit [31:0]       Pwdata;
        bit [31:0]       Prdata;
        bit              Pready;
        bit              Pslverr;
        bit              IRQ;
        bit [7:0]        rbr[$];
        bit [7:0]        thr[$];
        bit [7:0]        ier;
        bit [7:0]        iir;
        bit [7:0]        fcr;
        bit [7:0]        lcr;
        bit [7:0]        lsr;
        bit [7:0]        mcr;
        bit [25:0]       divisor;
        bit              dl_access;
        bit              data_in_thr;
        bit              data_in_rbr;


   function new(string name = "apb_xtn");
      super.new(name);
   endfunction : new

   function void do_print(uvm_printer printer);

      super.do_print(printer);

      printer.print_field("Presetn", Presetn, 1, UVM_DEC);
      printer.print_field("Paddr", Paddr, 8, UVM_DEC);
      printer.print_field("Psel", Psel, 1, UVM_DEC);
      printer.print_field("Pwrite", Pwrite, 1, UVM_DEC);
      printer.print_field("Penable", Penable, 1, UVM_DEC);
      printer.print_field("Pwdata", Pwdata, 8, UVM_BIN);
      printer.print_field("Prdata", Prdata, 8, UVM_BIN);
      printer.print_field("Pready", Pready, 1, UVM_DEC);
      printer.print_field("Pslverr", Pslverr, 1, UVM_DEC);
      printer.print_field("rbr_size", rbr.size(), 8, UVM_DEC);
      printer.print_field("IRQ", IRQ, 1, UVM_DEC);

      foreach (rbr[i]) printer.print_field($sformatf("rbr[%0d]", i), rbr[i], $bits(bit), UVM_DEC);
      foreach (thr[i]) printer.print_field($sformatf("thr[%0d]", i), thr[i], $bits(bit[7:0]), UVM_DEC);

      printer.print_field("ier", ier, 8, UVM_BIN);
      printer.print_field("iir", iir, 8, UVM_BIN);
      printer.print_field("fcr", fcr, 8, UVM_BIN);
      printer.print_field("lcr", lcr, 8, UVM_BIN);
      printer.print_field("lsr", lsr, 8, UVM_BIN);
      printer.print_field("mcr", mcr, 8, UVM_BIN);
      printer.print_field("divisor", divisor, 26, UVM_DEC);
      printer.print_field("dl_access", dl_access, 1, UVM_DEC);
      printer.print_field("data_in_thr", data_in_thr, 1, UVM_DEC);
      printer.print_field("data_in_rbr", data_in_rbr, 1, UVM_DEC);

   endfunction : do_print

endclass : apb_xtn
