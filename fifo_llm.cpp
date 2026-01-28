#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>

// The generated Verilator wrapper for the top module `fifo`.
// This file is automatically created when you run `make all`.
#ifdef VPI
extern "C" {
void vpi_register_cb(void);
}
#endif

#include "obj_dir/Vfifo.h"

int main(int argc, char **argv) {
  Verilated::commandArgs(argc, argv);
  Vfifo *top = new Vfifo;
  Verilated::traceEverOn(true);
  VerilatedVcdC *tfp = nullptr;
#ifdef TRACE
  tfp = new VerilatedVcdC();
  top->trace(tfp, 99);
  tfp->open("fifo_llm.vcd");
#endif

  // Helper lambda to step the clock.
  auto tick = [&]() {
    top->clk ^= 1;
    top->eval();
#ifdef TRACE
    tfp->dump(Verilated::time());
#endif
    Verilated::timeInc(5); // assume 10ns period, half cycle 5ns
  };

  // Reset sequence.
  top->rst_n = 0;
  top->clk = 0;
  top->wdata = 0;
  top->wen = 0;
  top->ren = 0;
  for (int i = 0; i < 2; i++)
    tick();
  top->rst_n = 1;
  for (int i = 0; i < 2; i++)
    tick();

  // Utility to write a word.
  auto write_word = [&](uint32_t data) {
    top->wdata = data;
    top->wen = 1;
    top->ren = 0;
    tick();
    top->wen = 0;
    tick();
  };

  // Utility to read a word.
  auto read_word = [&]() -> uint32_t {
    top->wen = 0;
    top->ren = 1;
    tick();
    uint32_t out = top->rdata;
    top->ren = 0;
    tick();
    return out;
  };

  // Test empty flag after reset.
  if (!top->empty) {
    std::cerr << "FIFO not empty after reset" << std::endl;
    exit(1);
  }

  // Write until full.
  int count = 0;
  while (!top->full) {
    write_word(count++);
  }
  if (!top->full) {
    std::cerr << "FIFO not full after filling" << std::endl;
    exit(1);
  }

  // Attempt one more write; should be ignored.
  top->wdata = 0xdeadbeef;
  top->wen = 1;
  top->ren = 0;
  tick();
  top->wen = 0;
  tick();
  if (top->full == 0) {
    Verilated::fatal(1, "Full flag cleared unexpectedly after ignored write");
  }

  // Read all entries.
  count = 0;
  while (!top->empty) {
    uint32_t val = read_word();
    if (val != static_cast<uint32_t>(count++)) {
      Verilated::fatal(1, "Data mismatch: expected %u got %u", count - 1, val);
    }
  }

  // FIFO should be empty now.
  if (!top->empty) {
    Verilated::fatal(1, "FIFO not empty after draining");
  }

  // Simultaneous read/write test: write and read in same cycle.
  top->wdata = 42;
  top->wen = 1;
  top->ren = 1;
  tick();
  uint32_t out = top->rdata;
  if (out != 42) {
    Verilated::fatal(1, "Simultaneous read/write failed: got %u", out);
  }
  top->wen = 0;
  top->ren = 0;
  tick();

  // Clean up.
#ifdef TRACE
  tfp->close();
  delete tfp;
#endif
  delete top;
  Verilated::final();
  return 0;
}
