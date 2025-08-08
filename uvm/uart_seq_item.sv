`ifndef UART_SEQ_ITEM_SV
`define UART_SEQ_ITEM_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_seq_item extends uvm_sequence_item;
  rand bit [7:0] data;
  rand bit       parity_en;
  rand bit       parity_odd; // 1 = odd, 0 = even
  rand int unsigned data_bits; // 5..8
  rand int unsigned stop_bits; // 1 or 2
  rand int unsigned baud_div;  // clocks per bit

  constraint c_ranges {
    data_bits inside {[5:8]};
    stop_bits inside {1,2};
    baud_div inside {[8:1024]};
  }

  `uvm_object_utils_begin(uart_seq_item)
    `uvm_field_int(data,       UVM_ALL_ON)
    `uvm_field_int(parity_en,  UVM_ALL_ON)
    `uvm_field_int(parity_odd, UVM_ALL_ON)
    `uvm_field_int(data_bits,  UVM_ALL_ON)
    `uvm_field_int(stop_bits,  UVM_ALL_ON)
    `uvm_field_int(baud_div,   UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "uart_seq_item");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("data=%0h db=%0d sb=%0d parity=%0d(%s) baud_div=%0d",
      data, data_bits, stop_bits, parity_en, (parity_odd?"odd":"even"), baud_div);
  endfunction
endclass

`endif
