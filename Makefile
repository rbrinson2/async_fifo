
TOP ?= fifo_tb

WORK_DIR ?= work

SRC_DIR := src
TB_DIR := testbench

SRC := $(shell find $(SRC_DIR) -name '*.vhdl')

GHDL_OPTIONS := --std=08 --ieee=standard --workdir=$(WORK_DIR)
RUN_WAVE := --wave=wave.ghw

.PHONY:all
all: $(TB_DIR)/$(TOP).vhdl $(SRC)
	@if [ ! -d "./work/" ]; then \
		echo "hello"; \
		mkdir work; \
	fi
	ghdl -i $(GHDL_OPTIONS) $^
	ghdl -m $(GHDL_OPTIONS) $(TOP)
	ghdl -r $(GHDL_OPTIONS) $(TOP) $(RUN_WAVE)
	gtkwave wave.ghw

.PHONY:clean
clean:
	rm -r work
	rm wave.ghw
