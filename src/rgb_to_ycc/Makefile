CC_HOST  = gcc
CC_ARM   = aarch64-linux-gnu-gcc
CFLAGS   = -O2 -Wall
LDFLAGS  = -lm
VM_USER  = student
VM_PORT  = 2222

SRCS   = CSC_main.c CSC_RGB_to_YCC.c CSC_YCC_to_RGB.c
TARGET = csc_rgb_to_ycc

.PHONY: all native arm deploy clean view

all: native

native: $(SRCS)
	$(CC_HOST) $(CFLAGS) -o $(TARGET) $(SRCS) $(LDFLAGS)

arm: $(SRCS)
	$(CC_ARM) $(CFLAGS) -o $(TARGET)_aarch64 $(SRCS) $(LDFLAGS)

deploy: arm
	scp -P $(VM_PORT) $(TARGET)_aarch64 $(VM_USER)@localhost:~/

view:
	montage -size 48x64 -depth 8 \
		rgb:image_input_RGB_64_48_03.data \
		rgb:image_output_RGB_64_48_03.data \
		-tile 2x1 -geometry 480x640+4+0 \
		/tmp/csc_compare.png && display /tmp/csc_compare.png

clean:
	rm -f $(TARGET) $(TARGET)_aarch64 image_output_*.data image_echo_*.data
