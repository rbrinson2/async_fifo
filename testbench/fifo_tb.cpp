
#include <memory>
#include <verilated.h>

#include "Vfifo.h"

int main(int argc, char *argv[]) {

  Verilated::mkdir("logs");

  std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

  contextp->debug(0);
  contextp->threads(1);
  contextp->traceEverOn(true);
  contextp->randReset(2);

  std::unique_ptr<Vfifo> fifo(new Vfifo(contextp.get(), "TOP"));

  fifo->rst_n = !0;
  fifo->clk = 1;
  fifo->wen = 0;
  fifo->ren = 0;
  fifo->wdata = 0x0000;

  while (contextp->time() < 100) {
    contextp->timeInc(1);
    fifo->clk = !fifo->clk;
    fifo->eval();
  }

  fifo->final();

  return 0;
}
