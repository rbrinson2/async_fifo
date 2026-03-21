
TOP ?= fifo_tb

WORK_DIR ?= work

SRC_DIR := src
TB_DIR := testbench

SRC := $(shell find $(SRC_DIR) -name '*.vhdl')

GHDL_OPTIONS := --std=08 --ieee=standard --workdir=$(WORK_DIR)

.PHONY:all
all: $(TB_DIR)/$(TOP).vhdl $(SRC)
	ghdl -i $(GHDL_OPTIONS) $^
	ghdl  

.PHONY:clean
clean:
	ghdl --remove --workdir=$(WORK_DIR)
