`ifndef UART_MONITOR_SV
`define UART_MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_monitor extends uvm_component;
  `uvm_component_utils(uart_monitor)

  virtual uart_if vif;
  uvm_analysis_port#(uart_seq_item) ap_tx; // observed from DUT

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap_tx = new("ap_tx", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "virtual interface not set")
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      uart_seq_item tr = uart_seq_item::type_id::create("tr");

      // Wait for start bit (line goes low)
      @(posedge vif.mon_cb);
      if (vif.mon_cb.tx === 1'b0) begin
        // sample in the middle of a bit
        int unsigned baud_div = 16; // default if unknown
        // Try to estimate baud_div by waiting for line to change again; for simplicity, use fixed 16
        // Sample start half bit then each bit time
        repeat (baud_div/2) @(vif.mon_cb);
        // Assume 8 data bits by default
        int unsigned bits = 8;
        tr.data = '0;
        for (int i=0; i<bits; i++) begin
          tr.data[i] = vif.mon_cb.tx;
          repeat (baud_div) @(vif.mon_cb);
        end
        // Stop bit skip
        repeat (baud_div) @(vif.mon_cb);
        ap_tx.write(tr);
      end
    end
  endtask
endclass

`endif
