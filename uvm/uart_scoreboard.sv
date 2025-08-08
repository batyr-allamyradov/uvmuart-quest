`ifndef UART_SCOREBOARD_SV
`define UART_SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_scoreboard extends uvm_component;
  `uvm_component_utils(uart_scoreboard)

  uvm_tlm_analysis_fifo#(uart_seq_item) exp_fifo;
  uvm_tlm_analysis_fifo#(uart_seq_item) obs_fifo;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    exp_fifo = new("exp_fifo", this);
    obs_fifo = new("obs_fifo", this);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      uart_seq_item exp, obs;
      exp_fifo.get(exp);
      obs_fifo.get(obs);
      if (exp.data !== obs.data)
        `uvm_error("UART_SCB", $sformatf("Mismatch exp=%0h obs=%0h", exp.data, obs.data))
      else
        `uvm_info("UART_SCB", $sformatf("Match data=%0h", exp.data), UVM_LOW)
    end
  endtask
endclass

`endif
