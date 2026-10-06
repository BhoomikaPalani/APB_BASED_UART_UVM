class uart_reg_block extends uvm_reg_block;

	`uvm_object_utils(uart_reg_block)

	reg_lcr lcr_h;

	function new(string name="uart_reg_block");
		super.new(name,UVM_NO_COVERAGE);
	endfunction

	virtual function void build();
		lcr_h=reg_lcr::type_id::create("lcr_h");
		lcr_h.build();
		lcr_h.configure(this);

		default_map=create_map("default_map",0,4,UVM_LITTLE_ENDIAN);
		default_map.add_reg(lcr_h,'h0C,"RW")
		lcr_h.add_hdl_path_slice("LCR",0,7);

		add_hdl_path("top.dut1.control","RTL");

	endfunction

endclass
