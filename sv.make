

TOP ?= fifo
THREADS ?= 0

OBJ_DIR := ./obj_dir
SRC_DIR := ./src
TB_DIR := ./testbench
LOG_DIR := ./logs


# Find all the source code
SRC := $(shell find $(SRC_DIR) -name '*.sv')
SRC := $(filter-out $(TOP).sv, $(SRC))


VERILATOR_FLAGS := --trace --Wno-fatal --exe --cc --build
CONTROL_FLAGS := +librescan +libext+.v+.sv+.vh+.svh -y $(SRC_DIR)

.PHONY: all
all: build run

run: $(OBJ_DIR)/V$(TOP)
	$(OBJ_DIR)/V$(TOP) +trace
	gtkwave $(LOG_DIR)/$(TOP).vcd

build: $(OBJ_DIR)/V$(TOP)

$(OBJ_DIR)/V$(TOP): $(TB_DIR)/$(TOP)_tb.cpp $(SRC_DIR)/$(TOP).sv 
	verilator -j $(THREADS) $(VERILATOR_FLAGS) $(CONTROL_FLAGS) $^


.PHONY: clean
clean:
	rm -r obj_dir/ logs/
