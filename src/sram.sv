


module sram 
#(
  parameter SRAM_DATAWIDTH = 32,
  parameter SRAM_DEPTH = 16,
  parameter SRAM_PTR = $clog2(SRAM_DEPTH)
)
(
  input logic w_clk, rd_clk,
  input logic [SRAM_PTR-1:0] wptr, rptr,
  input logic [SRAM_DATAWIDTH - 1:0] wdata,
  input logic wen,
  output logic [SRAM_DATAWIDTH - 1:0] rdata

);

  (* ram_style = "block" *)logic [SRAM_DATAWIDTH - 1:0] mem [0:SRAM_DEPTH-1];

  always_ff @(posedge w_clk) begin
    if (wen) mem[wptr] <= wdata;
  end

  always_ff @(posedge rd_clk) begin
    rdata <= mem[rptr];
  end
  
endmodule
