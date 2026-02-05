#include <memory>
#include <thread>

#include <verilated.h>
#include <verilated_cov.h>

#include "Vfifo.h"

#define SIM_TIME 90
#define RESET_DELAY 5
#define HIGH 1
#define LOW 0

#define TEST_FULL_FLAG ctx->time() > 5 && ctx->time() < 20
#define TEST_EMPTY_FLAG
#define TEST_RW_OP
#define TEST_RO_OP
#define TEST_WO_OP

enum Test_Phase { FULL_TEST, EMPTY_TEST, RW_TEST, FINISH };

std::unique_ptr<VerilatedContext> init_ctx();
std::unique_ptr<Vfifo> init_fifo(VerilatedContext *ctx);

int main(int argc, char *argv[]) {
  std::size_t data = 0;
  Test_Phase tp = RW_TEST;
  int rw_counter = 0;

  Verilated::mkdir("logs");

  auto ctx = init_ctx();
  auto fifo = init_fifo(ctx.get());

  while (ctx->time() < SIM_TIME) {

    ctx->timeInc(1);
    fifo->clk = !fifo->clk;

    if (ctx->time() > RESET_DELAY) {

      fifo->rst_n = HIGH;

      switch (tp) {
      case FULL_TEST:
        fifo->wen = HIGH;
        fifo->ren = LOW;
        if (fifo->clk == HIGH)
          fifo->wdata = data++;
        if (fifo->full == HIGH) {
          tp = EMPTY_TEST;
        }
        break;
      case EMPTY_TEST:
        fifo->wen = LOW;
        fifo->ren = HIGH;
        if (fifo->empty == HIGH)
          tp = FINISH;
        break;
      case RW_TEST:
        if (rw_counter < 10) {
          fifo->wen = HIGH;
          fifo->ren = LOW;
          if (fifo->clk == HIGH)
            fifo->wdata = data++;
        } else if (rw_counter >= 10 && rw_counter < 20) {
          fifo->wen = HIGH;
          fifo->ren = HIGH;
          if (fifo->clk == HIGH)
            fifo->wdata = data++;
        } else if (rw_counter >= 20)
          tp = FULL_TEST;
        rw_counter++;
        break;
      case FINISH:
        break;
      default:
        break;
      }
    }

    fifo->eval();
  }

  fifo->final();

  ctx->statsPrintSummary();

  return 0;
}

std::unique_ptr<VerilatedContext> init_ctx() {
  auto ctx = std::make_unique<VerilatedContext>();
  ctx->debug(0);
  ctx->threads(std::thread::hardware_concurrency());
  ctx->traceEverOn(true);
  ctx->randReset(2);

  return ctx;
};

std::unique_ptr<Vfifo> init_fifo(VerilatedContext *ctx) {
  auto fifo = std::make_unique<Vfifo>(ctx, "TOP");
  fifo->rst_n = LOW;
  fifo->clk = LOW;
  fifo->wen = LOW;
  fifo->ren = LOW;
  fifo->wdata = 0x0;

  return fifo;
};
