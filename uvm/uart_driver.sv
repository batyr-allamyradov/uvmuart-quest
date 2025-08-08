`ifndef UART_DRIVER_SV
`define UART_DRIVER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_driver extends uvm_driver#(uart_seq_item);
  `uvm_component_utils(uart_driver)

  virtual uart_if vif;
  uvm_analysis_port#(uart_seq_item) item_ap; // expected stream

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_ap = new("item_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "virtual interface not set")
  endfunction

  task run_phase(uvm_phase phase);
    // idle level is '1'
    vif.drv_cb.rx <= 1'b1;
    forever begin
      uart_seq_item tr;
      seq_item_port.get_next_item(tr);
      drive_item(tr);
      item_ap.write(tr);
      seq_item_port.item_done();
    end
  endtask

  task bit_delay(int unsigned baud_div);
    // Wait given number of clock cycles (one bit time)
    repeat (baud_div) @(vif.drv_cb);
  endtask

  function bit parity_calc(bit [7:0] data, int unsigned data_bits, bit parity_odd);
    bit p = ^data[data_bits-1:0];
    return parity_odd ? ~p : p; // for odd invert even parity
  endfunction

  task drive_item(uart_seq_item tr);
    // Start bit
    vif.drv_cb.rx <= 1'b0; bit_delay(tr.baud_div);
    // Data bits LSB first
    foreach (tr.data[i]) begin
      if (i==tr.data_bits) break;
      vif.drv_cb.rx <= tr.data[i];
      bit_delay(tr.baud_div);
    end
    // Parity
    if (tr.parity_en) begin
      vif.drv_cb.rx <= parity_calc(tr.data, tr.data_bits, tr.parity_odd);
      bit_delay(tr.baud_div);
    end
    // Stop bits
    repeat (tr.stop_bits) begin
      vif.drv_cb.rx <= 1'b1;
      bit_delay(tr.baud_div);
    end
    // Back to idle
    vif.drv_cb.rx <= 1'b1;
  endtask
endclass

`endif
