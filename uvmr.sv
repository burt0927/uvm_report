// why you would want to seperate out stuff to logs

// default actions see uvm_report_object
// UVM_INFO     - UVM_DISPLAY
// UVM_WARNING  - UVM_DISPLAY
// UVM_ERROR    - UVM_DISPLAY | UVM_COUNT
// UVM_FATAL    - UVM_DISPLAY | UVM_EXIT

// uvm_verbosity
// UVM_NONE / UVM_LOW / UVM_MEDIUM / UVM_HIGH / UVM_FULL

// uvm action
// UVM_NO_ACTION / UVM_DISPLAY / UVM_LOG / UVM_COUNT / UVM_EXIT / UVM_CALL_HOOK / UVM_STOP

package dut_env;
`include "uvm_macros.svh"
    import uvm_pkg::*;
    
class dut_test extends uvm_test;
    `uvm_component_utils(dut_test)

    int f0, f1, f2, f3;
        
    function new(string name = "dut_test", uvm_component parent = null);
        super.new(name, parent);               
        f0 = $fopen("f0", "w");
        f1 = $fopen("f1", "w");
        f2 = $fopen("f2", "w");
        f3 = $fopen("f3", "w");
               
    endfunction
        
    function void build_phase(uvm_phase phase);

        // THIS WORKS AND ELEVATES UVM_INFO to UVM_ERROR
        // set_report_severity_override(UVM_INFO, UVM_ERROR);

    endfunction // build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this, "run phase");

        // WORKS NEEDED TO WRITE TO LOG
        // uvm_top.set_report_severity_action_hier(UVM_INFO, UVM_DISPLAY | UVM_LOG);

        uvm_top.set_report_severity_id_action_hier(UVM_INFO, "MESSAGE", UVM_DISPLAY | UVM_LOG);
        uvm_top.set_report_severity_id_file_hier(UVM_INFO, "MESSAGE", f3);

        uvm_top.set_report_id_action_hier("MESSAGE", UVM_LOG);
        uvm_top.set_report_id_file_hier("MESSAGE", f1);

        uvm_top.set_report_severity_id_action_hier(UVM_WARNING, "D2", UVM_DISPLAY | UVM_LOG);
        uvm_top.set_report_severity_id_action_hier(UVM_INFO, "D1", UVM_DISPLAY | UVM_LOG);
        
        uvm_top.set_report_id_action_hier("D2", UVM_DISPLAY | UVM_LOG);
        uvm_top.set_report_id_file_hier("D2", f0);
             
        // this does not seem to work?
        uvm_top.set_report_verbosity_level_hier(UVM_FULL);
        
        // this does not seem to work
        // set_report_id_verbosity("D4_DEBUG", UVM_HIGH);
        uvm_top.set_report_id_verbosity_hier("D4", UVM_MEDIUM);

        uvm_top.set_report_default_file_hier(f2);
        
        $fdisplay(f0, "hello f0");
        
        `uvm_info("D3", "HERE", UVM_MEDIUM)
        `uvm_info("D4", "HERE", UVM_HIGH)
        `uvm_info("D2", "HERE", UVM_LOW)
        `uvm_info("D1", "HERE", UVM_LOW)
        
        `uvm_warning("D2", "HERE")
        
        `uvm_info("MESSAGE", "NOW TRYING TO SET VERBOSITY TO UVM_HIGH", UVM_MEDIUM)
        `uvm_info("MESSAGE", "NOW PRINTING", UVM_MEDIUM)

        `uvm_warning("MESSAGE", "NOW PRINTING")
        `uvm_warning("MESSAGE", "NOW PRINTING")
       
        `uvm_info("D4", "HERE", UVM_FULL)

        #10;
                
        $fclose(f0);
        $fclose(f1);
        $fclose(f2);
        $fclose(f3);
              
        phase.drop_objection(this, "run phase");

    endtask // main_phase
  
  
endclass // uvm_report_object

endpackage // dut_env
    
module dut;
`include "uvm_macros.svh"
    import uvm_pkg::*;
    import dut_env::*;
            
  initial begin : abc
            
      run_test();
           
  end


    initial begin
        #1;
        `uvm_info("D3", "MOD", UVM_MEDIUM)
        `uvm_info("D4", "MOD", UVM_HIGH)
        `uvm_info("D2", "MOD", UVM_LOW)
        `uvm_info("D1", "MOD", UVM_LOW)
        
    end

    
    
    
endmodule // dut
