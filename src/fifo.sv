

module fifo #(
    parameter integer DATAWIDTH  = 16,
    parameter integer ADDR_WIDTH = $clog2(DATAWIDTH)
) (
    input logic i_clk,
    i_rst_n,
    input logic [ADDR_WIDTH - 1 : 0] w_addr
);


  always_ff @(posedge i_clk) begin
    if (i_rst_n) begin

    end
  end



endmodule
