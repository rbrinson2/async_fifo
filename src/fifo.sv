

module fifo #(
    parameter integer DATAWIDTH  = 16
) (
    input logic i_clk,
    rst_n,

    // Writes
    input logic [DATAWIDTH-1:0] wdata, 
    input logic wen,
    output logic full,

    // Reads
    output logic [DATAWIDTH-1:0] rdata,
    output logic ren,
    output logic empty
);


  always_ff @(posedge i_clk) begin
    if (rst_n) begin

    end
  end



endmodule
