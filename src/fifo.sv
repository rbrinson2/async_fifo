

module fifo #(
    parameter FIFO_DATAWIDTH = 32,
    parameter FIFO_DEPTH = 16,
    parameter FIFO_PTR = $clog2(FIFO_DEPTH)
) (
    input logic clk,
    rst_n,

    // ---------- Inputs ---------- //
    // -- Write --
    input logic [FIFO_DATAWIDTH-1:0] wdata, 
    input logic wen,

    // -- Read --
    input logic ren,

    // -- Flags --
    
    // ---------- Outputs ---------- //
    // -- Write --
    output logic [FIFO_PTR-1:0] room_avail,
    // -- Read --
    output logic [FIFO_DATAWIDTH-1:0] rdata,
    output logic [FIFO_PTR-1:0] data_avail,

    // -- Flags --
    output logic full,
    output logic empty
);
  
  logic [FIFO_DATAWIDTH-1:0] mem [FIFO_DEPTH-1:0];
  logic [FIFO_PTR-1:0] wptr, rptr, dblnextptr, nextptr;

  // --------- Read and Write Logic --------- //
  always_ff @(posedge clk) begin
    if (wen) mem[wptr] <= wdata;
  end
  always_ff @(posedge clk) begin
    if (ren) rdata <= mem[rptr];
  end

  // --------- Pointer Logic --------- //
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      wptr <= 'b0;
    end else if (wen) begin
      if (!full || ren) wptr <= wptr + 1'b1;
    end
  end
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      rptr <= 'b0;
    end else if (ren) begin
      if (!empty) begin
        rptr <= rptr + 1'b1;
      end 
    end
  end

  // ---------- Calculate Fill ---------- //
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      room_avail <= FIFO_DEPTH - 1;
      data_avail <= 'b0;
    end else begin
      casez ({wen, ren, !full, !empty})
        4'b01?1 : begin
          room_avail <= room_avail + 1'b1;
          data_avail <= data_avail - 1'b1;
        end
        4'b101? : begin
          room_avail <= room_avail - 1'b1;
          data_avail <= data_avail + 1'b1;
        end
        4'b1110 : begin
          room_avail <= room_avail - 1'b1;
          data_avail <= data_avail + 1'b1;
        end
        default : begin
          room_avail <= room_avail;
          data_avail <= data_avail;
        end 
      endcase
    end
  end

  // ---------- Calculate Empty/Full ----------- //
  assign dblnextptr = wptr + 'd2;
  assign nextptr = rptr + 'd1;
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      full <= 'b0;
      empty <= 'b1;
    end else begin
      casez ({wen, ren, !full, !empty})
        4'b01?1 : begin
          full <= 1'b0;
          empty <= (nextptr == wptr);
        end
        4'b101? : begin
          full <= (dblnextptr == rptr);
          empty <= 1'b0;
        end
        4'b11?0 : begin
          full <= 1'b0;
          empty <= 1'b0;
        end
        4'b11?1 : begin
          full <= full;
          empty <= 1'b0;
        end
        default : begin
        end 
      endcase
    end
  end

  initial begin
    $dumpfile("logs/fifo.vcd");
    $dumpvars();
  end


endmodule
