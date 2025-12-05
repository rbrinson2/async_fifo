
#include <memory>
#include <verilated.h>

#include "Vfifo.h"

int main(int argc, char *argv[]) {

  Verilated::mkdir("logs");

  std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
  return 0;
}
