FC = gfortran
MODE ?= debug
BUILD := build/$(MODE)
.DEFAULT_GOAL := all
.PHONY: all clean release sanitize test
release:
	$(MAKE) MODE=release all
sanitize:
	$(MAKE) MODE=sanitize all
clean:
	rm -rf build
FFLAGS ?= -Wall -Wextra -Wimplicit-interface -ffree-line-length-none
ifeq ($(MODE),release)
FFLAGS += -O2
else
FFLAGS += -g -fcheck=all -fbacktrace
endif
FFLAGS += -J$(BUILD) -I$(BUILD)
ifeq ($(MODE),sanitize)
FFLAGS += -fsanitize=address,undefined -fno-omit-frame-pointer
endif

all: $(BUILD)/bvp.ex

$(BUILD)/bvp.ex: $(BUILD)/utility.o $(BUILD)/problemsetup.o $(BUILD)/dft.o $(BUILD)/bvp.o
	$(FC) $(FFLAGS) $(LDFLAGS) $^ -o $@

$(BUILD)/%.o: %.f90
	@mkdir -p $(BUILD)
	$(FC) $(FFLAGS) -c $< -o $@

$(BUILD)/problemsetup.o: $(BUILD)/utility.o

$(BUILD)/dft.o: $(BUILD)/utility.o

$(BUILD)/bvp.o: $(BUILD)/utility.o $(BUILD)/problemsetup.o $(BUILD)/dft.o
