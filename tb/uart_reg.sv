class reg_lcr extends uvm_reg;

	`uvm_object_utils(reg_lcr)

	uvm_reg_field reserved;
	rand uvm_reg_field Break;
	rand uvm_reg_field stick_parity;
	rand uvm_reg_field even_parity;
	rand uvm_reg_field parity;
	rand uvm_reg_field stop_bit;
	rand uvm_reg_field word_length;

	function new(string name="reg_lcr");
		super.new(name,8,UVM_NO_COVERAGE);
	endfunction

	virtual function void build();

		//Create object for each bits 
		reserved=uvm_reg_field::type_id::create("reserved");
		Break=uvm_reg_field::type_id::create("Break");
		stick_parity=uvm_reg_field::type_id::create("stick_parity");
		even_parity=uvm_reg_field::type_id::create("even_parity");
		parity=uvm_reg_field::type_id::create("parity");
		stop_bit=uvm_reg_field::type_id::create("stop_bit");
		word_length=uvm_reg_field::type_id::create("word_length");

		//configuration

		//parent for reg_field 
		//size of field
		 //lsb position of field 
		//access
		 //volatile(fc)
		 //rst val 
		//bit has_rst_sens 
		//supports randomization 
		//bit accessable

		word_length.configure(this,2,0,"RW",0,0,0,1,0);
		stop_bit.configure(this,1,2,"RW",0,0,0,1,0);
		parity.configure(this,1,3,"RW",0,0,0,1,0);
		even_parity.configure(this,1,4,"RW",0,0,0,1,0);

		stick_parity.configure(this,1,5,"RW",0,0,0,1,0);
		Break.configure(this,1,6,"RW",0,0,0,1,0);
		reserved.configure(this,1,7,"RW",0,0,0,1,0);
		
	endfunction

endclass


		


		

	
