CC_HOST  = gcc
CC_ARM   = aarch64-linux-gnu-gcc
CFLAGS   = -O2 -Wall
LDFLAGS  = -lm
VM_USER  = student
VM_PORT  = 2222

SRCS        = CSC_main.c CSC_RGB_to_YCC.c CSC_YCC_to_RGB.c
TARGET      = csc_rgb_to_ycc
PROFILE_DIR = profile_results

.PHONY: all native arm deploy fetch profile clean view

all: native

native: $(SRCS)
	$(CC_HOST) $(CFLAGS) -o $(TARGET) $(SRCS) $(LDFLAGS)

arm: $(SRCS)
	$(CC_ARM) $(CFLAGS) -o $(TARGET)_aarch64 $(SRCS) $(LDFLAGS)

deploy: arm
	scp -P $(VM_PORT) $(TARGET)_aarch64 $(VM_USER)@localhost:~/

profile: $(SRCS)
	mkdir -p $(PROFILE_DIR)
	@for routine in 1 2; do \
		for mode in 0 1 2; do \
			name="routine$${routine}_mode$${mode}"; \
			label="$$([ $$routine -eq 1 ] && echo float || echo int)_downsample$${mode}"; \
			echo "==> Profiling $$label..."; \
			$(CC_ARM) -pg -O2 -Wall \
				-DPROFILE_ONLY \
				-DRGB_to_YCC_ROUTINE=$$routine \
				-DCHROMINANCE_DOWNSAMPLING_MODE=$$mode \
				-o $(TARGET)_profile $(SRCS) $(LDFLAGS); \
			sshpass -p seng440 scp -o StrictHostKeyChecking=no -P $(VM_PORT) \
				$(TARGET)_profile image_input_RGB_64_48_03.data \
				$(VM_USER)@localhost:~/; \
			sshpass -p seng440 ssh -o StrictHostKeyChecking=no -p $(VM_PORT) \
				$(VM_USER)@localhost \
				"./$(TARGET)_profile && gprof ./$(TARGET)_profile gmon.out" \
				> $(PROFILE_DIR)/$$label.txt; \
			echo "    saved to $(PROFILE_DIR)/$$label.txt"; \
		done; \
	done
	@echo "Done. Results in $(PROFILE_DIR)/"
	rm -f $(TARGET)_profile

fetch:
	scp -P $(VM_PORT) $(VM_USER)@localhost:~/image_output_\*.data .
	scp -P $(VM_PORT) $(VM_USER)@localhost:~/image_echo_\*.data .

view:
	montage -size 48x64 -depth 8 \
		rgb:image_input_RGB_64_48_03.data \
		rgb:image_output_RGB_64_48_03.data \
		-tile 2x1 -geometry 480x640+4+0 \
		/tmp/csc_compare.png && display /tmp/csc_compare.png

clean:
	rm -f $(TARGET) $(TARGET)_aarch64 image_output_*.data image_echo_*.data
