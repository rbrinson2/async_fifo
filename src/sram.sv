


module sram 
#(
  parameter SRAM_DATAWIDTH = 32,
  parameter SRAM_DEPTH = 16,
  parameter SRAM_PTR = $clog2(SRAM_DEPTH)
)
(
  input logic w_clk, wen, rd_clk, ren,
  input logic [SRAM_PTR:0] s_wptr, s_rptr,
  input logic [SRAM_DATAWIDTH - 1:0] wdata,
  output logic [SRAM_DATAWIDTH - 1:0] rdata
);


  logic [SRAM_DATAWIDTH - 1:0] mem [SRAM_DEPTH - 1:0];

  initial begin
    for (integer i = 0; i < SRAM_DEPTH; i++) begin
      mem[i] = 'b0;
    end
  end

  always @(posedge w_clk) begin
    if (wen) mem[s_wptr] = wdata;
  end

  always @(rd_clk) begin
    if (ren) rdata = mem[s_rptr];
  end
  
endmodule
