


module top (
    input  logic clk,
    rst,
    output logic out
);


  wire out_wire;


  fifo #() fifo (
      .clk(clk),
      .rst(rst),
      .out(out_wire)
  );


endmodule
