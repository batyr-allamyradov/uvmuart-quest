`ifndef UART_BASE_TEST_SV
`define UART_BASE_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  uart_env        env;
  uart_agent_cfg  acfg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = uart_env::type_id::create("env", this);
    acfg = uart_agent_cfg::type_id::create("acfg");

    virtual uart_if vif;
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "vif not provided")
    acfg.vif = vif;

    uvm_config_db#(uart_agent_cfg)::set(this, "env.agent", "cfg", acfg);
  endfunction
endclass

`endif
