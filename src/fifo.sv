

module fifo #(
    parameter FIFO_DATAWIDTH = 16,
    parameter FIFO_DEPTH = 32,
    parameter FIFO_PTR = $clog2(FIFO_DEPTH)
) (
    input logic clk,
    rst_n,

    // ---------- Inputs ---------- \\
    // -- Write --
    input logic [FIFO_DATAWIDTH-1:0] wdata, 
    input logic wen,

    // -- Read --
    input logic ren,

    // -- Flags --
    
    // ---------- Outputs ---------- \\
    // -- Write --
    output logic [FIFO_PTR:0] room_avail,
    // -- Read --
    output logic [FIFO_DATAWIDTH-1:0] rdata,
    output logic [FIFO_PTR:0] data_avail,

    // -- Flags --
    output logic full,
    output logic empty
);

  localparam logic [FIFO_PTR:0] DEPTH = FIFO_DEPTH[FIFO_PTR:0];

  logic [FIFO_DATAWIDTH-1:0] mem [FIFO_DEPTH-1:0];

  logic [FIFO_PTR:0] wptr, wptr_next;
  logic [FIFO_PTR:0] rptr, rptr_next;
  logic [FIFO_PTR:0] num_entries, num_entries_next;
  logic [FIFO_PTR:0] room_avail_next;
  logic full_next, empty_next;

  always_ff @(*) begin : writePointerLogic
    wptr_next = wptr;

    if (wen) begin
      if (wptr == DEPTH) wptr_next = 'b0;
      else wptr_next += 1'b1;
    end

  end : writePointerLogic

  always_ff @(*) begin : readPointerLogic

    rptr_next = rptr;
    if (ren) begin
      if (rptr == DEPTH) rptr_next = 'b0;
      else rptr_next += 1'b1;
    end

  end : readPointerLogic

  always_ff @(*) begin : numEntriesCalculation

    num_entries_next = num_entries;

    if (wen && ren) num_entries_next = num_entries;
    else if (wen) num_entries_next = num_entries + 1'b1;
    else if (ren) num_entries_next = num_entries - 1'b1;

  end : numEntriesCalculation

  assign full_next = (num_entries_next == DEPTH);
  assign empty_next = (num_entries_next == 'b0);
  assign data_avail = num_entries;
  assign room_avail_next = (DEPTH - num_entries_next);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      wptr <= 'd0;
      rptr <= 'd0;
      num_entries <= 'd0;
      full <= 1'b0;
      empty <= 1'b0;
      room_avail <= DEPTH;
    end

    else begin
      wptr <= wptr_next;
      rptr <= rptr_next;
      num_entries <= num_entries_next;
      full <= full_next;
      empty <= empty_next;
      room_avail <= room_avail_next;
    end
  end


  initial begin
    $dumpfile("logs/fifo.vcd");
    $dumpvars();
  end


endmodule
