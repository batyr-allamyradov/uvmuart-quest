`ifndef UART_SMOKE_TEST_SV
`define UART_SMOKE_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class smoke_test extends base_test;
  `uvm_component_utils(smoke_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    basic_seq seq = basic_seq::type_id::create("seq");
    seq.start(env.agent.sqr);
    phase.drop_objection(this);
  endtask
endclass

`endif
