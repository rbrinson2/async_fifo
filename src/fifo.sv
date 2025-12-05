

module fifo (
    input  logic clk,
    rst,
    output logic out
);


  always_ff @(clk) begin : blockName
    if (rst) out <= 'b0;
    else out <= ~out;
  end

endmodule
