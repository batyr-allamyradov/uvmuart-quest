`ifndef UART_SEQUENCER_SV
`define UART_SEQUENCER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_sequencer extends uvm_sequencer#(uart_seq_item);
  `uvm_component_utils(uart_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

`endif
