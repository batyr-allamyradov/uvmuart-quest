module dut_uart(
  input  logic clk,
  input  logic rst_n,
  input  logic rx,
  output logic tx
);
  // Extremely simple DUT: loopback rx to tx (for demo only)
  assign tx = rx;
endmodule
