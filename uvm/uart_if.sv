interface uart_if(input logic clk, input logic rst_n);
  // UART lines from viewpoint of DUT pins
  logic rx; // input to DUT (driven by TB)
  logic tx; // output from DUT (observed by TB)

  // Driver/Monitor clocking blocks for cycle-accurate access
  clocking drv_cb @(posedge clk);
    default input #1step output #1step;
    output rx;
    input  tx;
  endclocking

  clocking mon_cb @(posedge clk);
    default input #1step output #1step;
    input rx;
    input tx;
  endclocking

endinterface
