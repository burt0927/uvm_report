// uvm_verbosity list:
// UVM_NONE
// UVM_LOW
// UVM_MEDIUM
// UVM_HIGH
// UVM_FULL
// UVM_DEBUG

// uvm action list:
// UVM_NO_ACTION
// UVM_DISPLAY
// UVM_LOG
// UVM_COUNT
// UVM_EXIT
// UVM_CALL_HOOK
// UVM_STOP

// default actions per verbosity see uvm_report_object:
// UVM_INFO     - UVM_DISPLAY
// UVM_WARNING  - UVM_DISPLAY
// UVM_ERROR    - UVM_DISPLAY | UVM_COUNT
// UVM_FATAL    - UVM_DISPLAY | UVM_EXIT

// A FILE descriptor can be associated with with reports of the given severity, id, or severity-id pair. A FILE associated with a particular severity-id pair takes precedence over a FILE associated with id, which take precedence over an a FILE associated with a severity, which takes precedence over the default FILE descriptor.

package dut_env;
`include "uvm_macros.svh"
    import uvm_pkg::*;

class comp extends uvm_component;
    `uvm_component_utils(comp)

    function void preport();
        `uvm_info("COMP", "UVM_LOW MESSAGE", UVM_LOW)
        `uvm_info("COMP", "UVM_MEDIUM MESSAGE", UVM_MEDIUM)
        `uvm_info("COMP", "UVM_HIGH MESSAGE", UVM_HIGH)
        `uvm_info("ANNOYING", "UVM_LOW MESSAGE", UVM_LOW)
        `uvm_info("DEBUG", "DBG UVM_HIGH MESSAGE", UVM_HIGH)
        `uvm_info("TXN", "TXN UVM_MEDIUM MESSAGE", UVM_MEDIUM)
        `uvm_warning("REMINDER", "UVM_WARNING MESSAGE")      
    endfunction
    
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass
   
class dut_test extends uvm_test;
    `uvm_component_utils(dut_test)

    // file handles
    int c0_txn, c0_txn_global;
    
    // uvm components
    comp comp1_h;
    comp comp0_h;
        
    function new(string name = "dut_test", uvm_component parent = null);
        super.new(name, parent);               
        c0_txn = $fopen("c0_txn", "w");
        c0_txn_global = $fopen("c0_txn_global", "w");
               
    endfunction
        
    function void build_phase(uvm_phase phase);

        comp1_h = comp::type_id::create("comp1_h", this);
        comp0_h = comp::type_id::create("comp0_h", this);
                

    endfunction // build_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this, "run phase");

        // default calls
        `uvm_info("NOTE", "EXAMPLE 01 : default calls", UVM_MEDIUM)       
        comp0_h.preport();
        comp1_h.preport();
        #1;  

        // if you just want to see more of a specific component
        `uvm_info("NOTE", "EXAMPLE 02 : comp0_h verbosity override to UVM_HIGH", UVM_MEDIUM)
        comp0_h.set_report_verbosity_level(UVM_HIGH);
        comp0_h.preport();
        #1;

        // override a severity from warning to error
        `uvm_info("NOTE", "EXAMPLE 03 : comp0_h severity override UVM_WARNING to UVM_ERROR", UVM_MEDIUM)
        comp0_h.set_report_severity_override(UVM_WARNING, UVM_ERROR);
        comp0_h.preport();
        #1;
                               
        // restory severity
        `uvm_info("NOTE", "EXAMPLE 04 : comp0_h severity override reset UVM_WARNING", UVM_MEDIUM)
        comp0_h.set_report_severity_override(UVM_WARNING, UVM_WARNING);
        comp0_h.preport();
        #1;
       
        // if you want to banish all messages of a certain id
        `uvm_info("NOTE", "EXAMPLE 05 : comp0_h banish all ANNOYING ids", UVM_MEDIUM)
        comp0_h.set_report_severity_id_action(UVM_LOW, "ANNOYING", UVM_NO_ACTION);
        comp0_h.preport();
        #1;

        // if you want to break out certain types of messages to a log file
        `uvm_info("NOTE", "EXAMPLE 06 : comp0_h TXN to file only", UVM_MEDIUM)
        comp0_h.set_report_id_action("TXN", UVM_LOG);
        comp0_h.set_report_id_file_hier("TXN", c0_txn);
        comp0_h.preport();
        #1;
                
        // if you want to have TXN data in the log as well as in the file
        `uvm_info("NOTE", "EXAMPLE 07 : comp0_h TXN to file and display", UVM_MEDIUM)
        comp0_h.set_report_id_action("TXN", UVM_DISPLAY | UVM_LOG);
        comp0_h.set_report_id_file_hier("TXN", c0_txn);
        comp0_h.preport();
        #1;
                
        // if you want to have TXN data in a log only - done globally
        `uvm_info("NOTE", "EXAMPLE 08 : uvm_top TXN to file only with global uvm_top", UVM_MEDIUM)
        uvm_top.set_report_id_action_hier("TXN", UVM_LOG);
        uvm_top.set_report_id_file_hier("TXN", c0_txn_global);
        comp0_h.preport();
        comp1_h.preport();
        #1;

        phase.drop_objection(this, "run phase");

    endtask // main_phase
  
  
endclass // uvm_report_object

endpackage // dut_env
    
module dut;
`include "uvm_macros.svh"
    import uvm_pkg::*;
    import dut_env::*;
            
  initial begin            
      run_test();           
  end   
    
endmodule // dut
