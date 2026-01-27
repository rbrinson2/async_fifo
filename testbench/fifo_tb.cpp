#include <fstream>
#include <memory>
#include <sstream>
#include <string>
#include <thread>

#include <vector>
#include <verilated.h>

#include "Vfifo.h"

struct Action {
  int time;
  char op;
  long data;
};

std::vector<Action> parse_inp(std::ifstream &ifs) {
  std::vector<Action> avec;
  std::string timeStr, opStr, dataStr, line;
  std::getline(ifs, line);

  while (std::getline(ifs, line)) {
    std::istringstream iss(line);
    Action a;

    std::getline(iss, timeStr, ',');
    std::getline(iss, opStr, ',');
    std::getline(iss, dataStr);

    a.time = std::stoi(timeStr);
    a.op = opStr[0];
    a.data = dataStr.empty() ? 0 : std::stol(dataStr, 0, 16);

    avec.push_back(a);
  }

  return avec;
}

int main(int argc, char *argv[]) {
  std::ifstream inp("input.csv");
  std::string line;
  int act_idx = 0;

  std::vector<Action> actions = parse_inp(inp);

  const auto processor_count = std::thread::hardware_concurrency();

  Verilated::mkdir("logs");

  std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

  contextp->debug(0);
  contextp->threads(processor_count);
  contextp->traceEverOn(true);
  contextp->randReset(2);

  std::unique_ptr<Vfifo> fifo{new Vfifo{contextp.get(), "TOP"}};

  fifo->rst_n = 0;
  fifo->clk = 1;
  fifo->wen = 0;
  fifo->ren = 0;
  fifo->wdata = 0x1010'1010;

  while (contextp->time() < 300) {

    if (!actions.empty()) {
      Action a = actions.front();

      switch (a.op) {
      case 'W':
        fifo->wen = 1;
        fifo->ren = 0;
        break;
      case 'R':
        fifo->wen = 0;
        fifo->ren = 1;
        break;
      default:
        fifo->wen = 0;
        fifo->ren = 0;
      }

      fifo->wdata = a.data;

      if (contextp->time() == a.time)
        actions.erase(actions.begin());
    }

    contextp->timeInc(1);
    fifo->clk = !fifo->clk;

    if (contextp->time() > 5) {
      fifo->rst_n = 1;
    }

    fifo->eval();
  }

  fifo->final();

  inp.close();

  return 0;
}
