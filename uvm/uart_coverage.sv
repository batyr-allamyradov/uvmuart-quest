`ifndef UART_COVERAGE_SV
`define UART_COVERAGE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_coverage extends uvm_subscriber#(uart_seq_item);
  `uvm_component_utils(uart_coverage)

  covergroup cg;
    option.per_instance = 1;
    DATA: coverpoint tr_data {
      bins low  = {[8'h00:8'h0F]};
      bins mid  = {[8'h10:8'hEF]};
      bins high = {[8'hF0:8'hFF]};
    }
    DBITS: coverpoint tr_dbits { bins b5={5}; bins b6={6}; bins b7={7}; bins b8={8}; }
    SBITS: coverpoint tr_sbits { bins s1={1}; bins s2={2}; }
    CROSS: cross DATA, DBITS, SBITS;
  endgroup

  byte tr_data; int tr_dbits; int tr_sbits;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    cg = new();
  endfunction

  function void write(uart_seq_item t);
    tr_data  = t.data;
    tr_dbits = t.data_bits;
    tr_sbits = t.stop_bits;
    cg.sample();
  endfunction
endclass

`endif
