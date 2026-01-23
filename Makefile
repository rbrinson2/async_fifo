

TOP ?= fifo
THREADS ?= 0

OBJ_DIR := ./obj_dir
SRC_DIR := ./src
TB_DIR := ./testbench
LOG_DIR := ./logs


# Find all the source code
SRC := $(shell find $(SRC_DIR) -name '*.sv')


VERILATOR_FLAGS := --trace --Wno-fatal --exe --cc --build
BUILD_FLAGS := --trace --Wno-fatal --exe --cc --build

.PHONY: all
all: build run

run: $(OBJ_DIR)/V$(TOP)
	$(OBJ_DIR)/V$(TOP) +trace
	gtkwave $(LOG_DIR)/$(TOP).vcd

build: $(OBJ_DIR)/V$(TOP)

$(OBJ_DIR)/V$(TOP): $(SRC) $(TB_DIR)/$(TOP)_tb.cpp 
	verilator -j $(THREADS) $(BUILD_FLAGS) $^


.PHONY: clean
clean:
	rm -r obj_dir/ logs/
