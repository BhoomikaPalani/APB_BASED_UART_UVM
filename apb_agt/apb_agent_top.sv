class apb_agent_top extends uvm_env;

   `uvm_component_utils(apb_agent_top)

   // Environment configuration handle
   env_config        m_tb_cfg;

   // Array of APB agents
   apb_agent         agnth[];


   function new(string name = "apb_agent_top",uvm_component parent);
      super.new(name, parent);
   endfunction : new


   // --------------------------------------------------
   // Build phase
   // Creates required number of APB agents
   // and passes individual agent configuration
   // --------------------------------------------------
   function void build_phase(uvm_phase phase);

      super.build_phase(phase);

      // Get environment configuration
      if (!uvm_config_db#(env_config)::get(this, "", "env_config",m_tb_cfg))
         `uvm_fatal("config","cannot get env_config")

      // Allocate agent array
      this.agnth = new[this.m_tb_cfg.has_no_of_agent];

      // Create each agent instance
      foreach (agnth[i]) begin

         agnth[i] = apb_agent::type_id::create($sformatf("agnth[%0d]", i),this);

         // Pass agent-specific configuration
         uvm_config_db#(apb_agent_config)::set(this,$sformatf("agnth[%0d]*", i),"apb_agent_config",m_tb_cfg.m_cfg[i]);

      end

   endfunction : build_phase


endclass : apb_agent_top
