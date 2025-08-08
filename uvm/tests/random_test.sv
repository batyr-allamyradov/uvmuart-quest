`ifndef UART_RANDOM_TEST_SV
`define UART_RANDOM_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class random_test extends base_test;
  `uvm_component_utils(random_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    error_seq seq = error_seq::type_id::create("seq");
    seq.start(env.agent.sqr);
    phase.drop_objection(this);
  endtask
endclass

`endif
