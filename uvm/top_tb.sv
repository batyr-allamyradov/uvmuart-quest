`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

// Includes
`include "uart_seq_item.sv"
`include "uart_sequencer.sv"
`include "uart_driver.sv"
`include "uart_monitor.sv"
`include "uart_agent.sv"
`include "uart_scoreboard.sv"
`include "uart_coverage.sv"
`include "uart_env.sv"
`include "sequences/basic_seq.sv"
`include "sequences/error_seq.sv"
`include "tests/base_test.sv"
`include "tests/smoke_test.sv"
`include "tests/random_test.sv"

module top_tb;
  logic clk; logic rst_n;

  // Clock
  initial begin
    clk = 0; forever #5 clk = ~clk; // 100MHz
  end

  // Reset
  initial begin
    rst_n = 0; repeat (10) @(posedge clk); rst_n = 1;
  end

  // Interface
  uart_if uif(.clk(clk), .rst_n(rst_n));

  // DUT
  dut_uart dut(
    .clk (clk),
    .rst_n(rst_n),
    .rx  (uif.rx),
    .tx  (uif.tx)
  );

  // UVM config and start
  initial begin
    uvm_config_db#(virtual uart_if)::set(null, "*", "vif", uif);
    if (!$value$plusargs("UVM_TESTNAME=%s", uvm_top.test_name)) begin
      uvm_top.test_name = "smoke_test";
    end
    run_test();
  end
endmodule
