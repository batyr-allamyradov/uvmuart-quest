`ifndef UART_BASIC_SEQ_SV
`define UART_BASIC_SEQ_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class basic_seq extends uvm_sequence#(uart_seq_item);
  `uvm_object_utils(basic_seq)

  function new(string name = "basic_seq"); super.new(name); endfunction

  task body();
    repeat (16) begin
      uart_seq_item tr = uart_seq_item::type_id::create("tr");
      if (!tr.randomize() with { baud_div inside {[32:128]}; parity_en == 0; data_bits == 8; stop_bits == 1; })
        `uvm_fatal(get_type_name(), "randomize failed")
      start_item(tr);
      finish_item(tr);
    end
  endtask
endclass

`endif
