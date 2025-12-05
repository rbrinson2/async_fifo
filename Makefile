

TOP ?= top
THREADS ?= 0

OBJ_DIR := ./obj_dir
SRC_DIR := ./src
TB_DIR := ./testbench


# Find all the source code
SRC := $(shell find $(SRC_DIR) -name '*.sv')

# Get the module names from the source code files
MODS := $(basename $(notdir $(SRC)))

# Create a list of libraries
LIBS := $(MODS:%=lib%.a)

# Create a list of objects and also prepend obj directory
OBJS := $(MODS:%=%.o)
OBJS_LIST := $(foreach obj, $(OBJS), $(OBJ_DIR)/$(obj))

.PHONY: all
all: build

build: $(OBJ_DIR)/V$(TOP) 

$(OBJ_DIR)/V$(TOP): $(OBJS_LIST)
	verilator -j $(THREADS) --exe --binary $(OBJS) -LDFLAGS "$(LIBS)" $(SRC_DIR)/$(TOP).sv $(TB_DIR)/$(TOP)_tb.cpp


$(OBJ_DIR)/%.o: $(SRC_DIR)/%.sv
	verilator -j $(THREADS) --lib-create $(basename $(notdir $<)) -I$(SRC_DIR) --cc --build $<



.PHONY: clean
clean:
	rm -r obj_dir/
