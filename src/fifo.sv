

module fifo #(
    parameter FIFO_DATAWIDTH = 'd16,
    parameter FIFO_DEPTH = 'd32,
    parameter FIFO_PTR = $clog2(FIFO_DEPTH)
) (
    input logic clk,
    rst_n,

    // ---------- Inputs ---------- \\
    // -- Write --
    input logic [FIFO_DATAWIDTH-1:0] wdata, 
    input logic wen,

    // -- Read --
    output logic ren,

    // -- Flags --
    
    // ---------- Outputs ---------- \\
    // -- Write --
    output logic [FIFO_PTR - 1:0] room_avail,
    // -- Read --
    output logic [FIFO_DATAWIDTH-1:0] rdata,
    output logic [FIFO_PTR - 1:0] data_avail,

    // -- Flags --
    output logic full,
    output logic empty
);

  logic [FIFO_DATAWIDTH-1:0] mem [FIFO_DEPTH-1:0];
  logic [FIFO_PTR - 1:0] wptr, wptr_next, rptr, rptr_next;
  logic [FIFO_PTR - 1:0] num_avail_next, num_avail;
  logic full_next, empty_next;

  always_ff @(*) begin : writePointerLogic
    wptr_next = wptr;

    if (wen) begin
      if (wptr == FIFO_DEPTH - 1) wptr_next = 'b0;
      else wptr_next += 1'b1;
    end

  end : writePointerLogic

  always_ff @(*) begin : readPointerLogic

    rptr_next = rptr;
    if (ren) begin
      if (rptr == FIFO_DEPTH - 1) rptr_next = 'b0;
      else rptr_next += 1'b1;
    end

  end : readPointerLogic

  always_ff @(*) begin : numEntriesCalculation

    num_avail_next = num_avail;

    if (wen && ren) num_avail_next = num_avail;
    else if (wen) num_avail_next = num_avail + 1'b1;
    else if (ren) num_avail_next = num_avail - 1'b1;

  end : numEntriesCalculation

  assign full_next = (num_avail_next == logic'(FIFO_DEPTH - 1));
  assign empty_next = (num_avail_next == 'b0);

  always_ff @(posedge clk or negedge rst_n) begin


  end



endmodule
