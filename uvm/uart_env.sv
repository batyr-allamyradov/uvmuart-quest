`ifndef UART_ENV_SV
`define UART_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)

  uart_agent      agent;
  uart_scoreboard scb;
  uart_coverage   cov;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = uart_agent::type_id::create("agent", this);
    scb   = uart_scoreboard::type_id::create("scb", this);
    cov   = uart_coverage::type_id::create("cov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    // expected items from driver, observed items from monitor
    agent.drv.item_ap.connect(scb.exp_fifo.analysis_export);
    agent.mon.ap_tx.connect(scb.obs_fifo.analysis_export);
    agent.drv.item_ap.connect(cov.analysis_export);
  endfunction
endclass

`endif
