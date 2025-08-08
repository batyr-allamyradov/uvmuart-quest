`ifndef UART_ERROR_SEQ_SV
`define UART_ERROR_SEQ_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class error_seq extends uvm_sequence#(uart_seq_item);
  `uvm_object_utils(error_seq)

  function new(string name = "error_seq"); super.new(name); endfunction

  task body();
    // deliberately stress different formats
    foreach (int idx[10]) begin
      uart_seq_item tr = uart_seq_item::type_id::create($sformatf("tr_%0d", idx));
      if (!tr.randomize() with { data_bits inside {[5:8]}; stop_bits inside {1,2}; parity_en dist {0:=7, 1:=3}; baud_div inside {[16:256]}; })
        `uvm_fatal(get_type_name(), "randomize failed")
      start_item(tr);
      finish_item(tr);
    end
  endtask
endclass

`endif
