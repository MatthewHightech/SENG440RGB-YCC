CC_HOST  = gcc
CC_ARM   = aarch64-linux-gnu-gcc
CFLAGS   = -O2 -Wall
LDFLAGS  = -lm
VM_USER  = student
VM_PORT  = 2222

SRCS     = CSC_main.c CSC_YCC_to_RGB.c ../rgb_to_ycc/CSC_RGB_to_YCC.c
TARGET   = csc_ycc_to_rgb
TEST_IN  = testimages/input.ppm
TEST_OUT = testimages/output.ppm
SAMPLE   = ../rgb_to_ycc/image_input_RGB_64_48_03.data
IMG      ?=

.PHONY: all native arm deploy clean test prepare-test-image

all: native

native: $(SRCS)
	$(CC_HOST) $(CFLAGS) -o $(TARGET) $(SRCS) $(LDFLAGS)

arm: $(SRCS)
	$(CC_ARM) $(CFLAGS) -o $(TARGET)_aarch64 $(SRCS) $(LDFLAGS)

deploy: arm
	scp -P $(VM_PORT) $(TARGET)_aarch64 $(VM_USER)@localhost:~/

test: native $(TEST_IN)
	./$(TARGET) $(TEST_IN) $(TEST_OUT)
	@echo "Open $(TEST_OUT) to inspect the round-trip result."

prepare-test-image:
	@mkdir -p testimages
	@if [ -n "$(IMG)" ]; then \
		python3 scripts/prepare_test_image.py "$(IMG)" "$(TEST_IN)"; \
	else \
		python3 scripts/prepare_test_image.py "$(SAMPLE)" "$(TEST_IN)"; \
	fi

$(TEST_IN):
	@mkdir -p testimages
	python3 scripts/prepare_test_image.py "$(SAMPLE)" "$(TEST_IN)"

clean:
	rm -f $(TARGET) $(TARGET)_aarch64 image_output_*.data image_echo_*.data
