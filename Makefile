

TOP ?= fifo
THREADS ?= 0

OBJ_DIR := ./obj_dir
SRC_DIR := ./src
TB_DIR := ./testbench
LOG_DIR := ./logs


# Find all the source code
SRC := $(shell find $(SRC_DIR) -name '*.sv')

# Get the module names from the source code files
MODS := $(basename $(notdir $(SRC)))

# Create a list of libraries
LIBS := $(MODS:%=lib%.a)

# Create a list of objects and also prepend obj directory
OBJS := $(MODS:%=%.o)
OBJS_LIST := $(foreach obj, $(OBJS), $(OBJ_DIR)/$(obj))

VERILATOR_FLAGS := --trace --Wno-fatal --exe --cc --build

.PHONY: all
all: build run

run: $(OBJ_DIR)/V$(TOP)
	$(OBJ_DIR)/V$(TOP) +trace
	gtkwave $(LOG_DIR)/$(TOP).vcd

build: $(OBJ_DIR)/V$(TOP) 

# Build the final executable
$(OBJ_DIR)/V$(TOP): $(TB_DIR)/$(TOP)_tb.cpp $(OBJS_LIST)
	verilator -j $(THREADS) $(VERILATOR_FLAGS) $(OBJS) -LDFLAGS "$(LIBS)" $(SRC_DIR)/$(TOP).sv $<

# Build all the libraries
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.sv
	verilator -j $(THREADS) --Wno-fatal --lib-create $(basename $(notdir $<)) -I$(SRC_DIR) --cc --build $<



.PHONY: clean
clean:
	rm -r obj_dir/ logs/
