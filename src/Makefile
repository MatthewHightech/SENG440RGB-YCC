CC_HOST  = gcc
CC_ARM   = aarch64-linux-gnu-gcc
CFLAGS   = -O2 -Wall
LDFLAGS  = -lm
VM_USER  = student
VM_PORT  = 2222

SRCS   = CSC_main.c CSC_RGB_to_YCC.c CSC_YCC_to_RGB.c
TARGET = csc

.PHONY: all native arm deploy clean

all: native

native: $(SRCS)
	$(CC_HOST) $(CFLAGS) -o $(TARGET) $(SRCS) $(LDFLAGS)

arm: $(SRCS)
	$(CC_ARM) $(CFLAGS) -o $(TARGET)_aarch64 $(SRCS) $(LDFLAGS)

deploy: arm
	scp -P $(VM_PORT) $(TARGET)_aarch64 $(VM_USER)@localhost:~/

clean:
	rm -f $(TARGET) $(TARGET)_arm
