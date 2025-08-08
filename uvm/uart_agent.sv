`ifndef UART_AGENT_SV
`define UART_AGENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_agent_cfg extends uvm_object;
  `uvm_object_utils(uart_agent_cfg)
  bit is_active = UVM_ACTIVE;
  virtual uart_if vif;
  function new(string name = "uart_agent_cfg"); super.new(name); endfunction
endclass

class uart_agent extends uvm_agent;
  `uvm_component_utils(uart_agent)

  uart_agent_cfg cfg;
  uart_sequencer  sqr;
  uart_driver     drv;
  uart_monitor    mon;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(uart_agent_cfg)::get(this, "", "cfg", cfg)) begin
      cfg = uart_agent_cfg::type_id::create("cfg");
      void'(uvm_config_db#(virtual uart_if)::get(this, "", "vif", cfg.vif));
    end

    mon = uart_monitor::type_id::create("mon", this);
    uvm_config_db#(virtual uart_if)::set(this, "mon", "vif", cfg.vif);

    if (cfg.is_active == UVM_ACTIVE) begin
      sqr = uart_sequencer::type_id::create("sqr", this);
      drv = uart_driver::type_id::create("drv", this);
      uvm_config_db#(virtual uart_if)::set(this, "drv", "vif", cfg.vif);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if (cfg.is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end
  endfunction
endclass

`endif
