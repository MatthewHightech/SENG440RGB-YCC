CC_HOST  = gcc
CC_ARM   = aarch64-linux-gnu-gcc
# -g is required so cg_annotate can map counts back to functions/lines.
CFLAGS   = -O2 -Wall -g
LDFLAGS  = -lm
VM_USER  = student
VM_PORT  = 2222

# ARM32 (armhf / armv7) needs -mfpu=neon for <arm_neon.h> intrinsics.
# AArch64 has NEON always-on, so no -mfpu flag there.
UNAME_M := $(shell uname -m 2>/dev/null)
ifneq (,$(filter armv7l armv6l arm,$(UNAME_M)))
  CFLAGS += -mfpu=neon
endif

# LARGE=1 builds 640x480 (IMAGE_SIZE_LARGE); default is 64x48.
LARGE ?= 0
ifeq ($(LARGE),1)
  CFLAGS += -DIMAGE_SIZE_LARGE
  IMAGE_ROWS = 640
  IMAGE_COLS = 480
  SAMPLE     = image_input_RGB_640_480_02.data
  TEST_IN    = testimages/input_640x480.ppm
  TEST_OUT   = testimages/output_640x480.ppm
else
  IMAGE_ROWS = 64
  IMAGE_COLS = 48
  SAMPLE     = image_input_RGB_64_48_03.data
  TEST_IN    = testimages/input.ppm
  TEST_OUT   = testimages/output.ppm
endif

SRCS     = CSC_main.c CSC_harness.c CSC_RGB_to_YCC.c CSC_YCC_to_RGB.c
TARGET   = csc_full_conversion
WALL_CSV = metrics/walltime.csv
IMG      ?=
LABEL    ?= baseline
ITERS    ?= 1000

.PHONY: all native native-profile arm deploy clean test bench measure \
        prepare-test-image cachegrind cachegrind-annotate

all: native

native: $(SRCS)
	$(CC_HOST) $(CFLAGS) -o $(TARGET) $(SRCS) $(LDFLAGS)

# Same as native; kept as an alias so "profile build" is explicit in docs.
native-profile: native

arm: $(SRCS)
	$(CC_ARM) $(CFLAGS) -o $(TARGET)_aarch64 $(SRCS) $(LDFLAGS)

deploy: arm
	scp -P $(VM_PORT) $(TARGET)_aarch64 $(VM_USER)@localhost:~/

test: native $(TEST_IN)
	./$(TARGET) $(TEST_IN) $(TEST_OUT) --label $(LABEL) --iters $(ITERS) \
		--metrics $(WALL_CSV)
	@echo "Open $(TEST_OUT) to inspect the round-trip result."

# Secondary metric: wall-time ONLY (no Valgrind). Accurate on host / ARM VM.
bench: native $(TEST_IN)
	@echo "=== Step 1/1: wall-time bench (no Cachegrind) ==="
	./$(TARGET) $(TEST_IN) $(TEST_OUT) --label $(LABEL) --iters $(ITERS) \
		--metrics $(WALL_CSV)
	@echo "Wall-time CSV: $(WALL_CSV)"

# Primary (Cachegrind Ir/misses) + secondary (wall-time) in one command.
# Wall-time runs FIRST outside Valgrind; Cachegrind runs SECOND.
measure: native-profile $(TEST_IN)
	@echo "=== Step 1/2: wall-time (no Cachegrind) ==="
	./$(TARGET) $(TEST_IN) $(TEST_OUT) --label $(LABEL) --iters $(ITERS) \
		--metrics $(WALL_CSV)
	@echo
	@echo "=== Step 2/2: Cachegrind (Ir + cache misses) ==="
	LABEL=$(LABEL) BINARY=./$(TARGET) INPUT=$(TEST_IN) OUTPUT=$(TEST_OUT) \
		ITERS=1 bash scripts/run_cachegrind.sh
	@echo
	@echo "Done. Secondary wall-time: $(WALL_CSV)"
	@echo "Primary Cachegrind:       metrics/cachegrind.csv"

# Primary project metrics: instruction count (Ir) + cache misses.
# Must be run where Valgrind is installed (Linux ARM VM recommended).
cachegrind: native-profile $(TEST_IN)
	LABEL=$(LABEL) BINARY=./$(TARGET) INPUT=$(TEST_IN) OUTPUT=$(TEST_OUT) \
		ITERS=1 bash scripts/run_cachegrind.sh

cachegrind-annotate:
	@latest=$$(ls -t metrics/cachegrind/*.out 2>/dev/null | head -1); \
	if [ -z "$$latest" ]; then \
		echo "No cachegrind .out files in metrics/cachegrind/"; \
		exit 1; \
	fi; \
	echo "Annotating $$latest"; \
	cg_annotate --auto=yes "$$latest" | less

prepare-test-image:
	@mkdir -p testimages
	@if [ -n "$(IMG)" ]; then \
		IMAGE_ROWS=$(IMAGE_ROWS) IMAGE_COLS=$(IMAGE_COLS) \
			python3 scripts/prepare_test_image.py "$(IMG)" "$(TEST_IN)"; \
	else \
		IMAGE_ROWS=$(IMAGE_ROWS) IMAGE_COLS=$(IMAGE_COLS) \
			python3 scripts/prepare_test_image.py "$(SAMPLE)" "$(TEST_IN)"; \
	fi

$(TEST_IN):
	@mkdir -p testimages
	IMAGE_ROWS=$(IMAGE_ROWS) IMAGE_COLS=$(IMAGE_COLS) \
		python3 scripts/prepare_test_image.py "$(SAMPLE)" "$(TEST_IN)"

clean:
	rm -f $(TARGET) $(TARGET)_aarch64 image_output_*.data image_echo_*.data
	rm -rf metrics/cachegrind
