ASM=nasm
CC=gcc
CC16=/usr/bin/watcom/binl64/wcc
LD16=/usr/bin/watcom/binl64/wlink
BUILD_DIR=build

.PHONY: floppy_image kernel bootloader clean always

# Floppy image
floppy_image: $(BUILD_DIR)/main_floppy.img

$(BUILD_DIR)/main_floppy.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/main_floppy.img bs=512 count=2880
	mkfs.fat -F 12 -n "FOS" $(BUILD_DIR)/main_floppy.img
	dd if=$(BUILD_DIR)/stage1.bin of=$(BUILD_DIR)/main_floppy.img conv=notrunc
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/stage2.bin "::stage2.bin"
	mcopy -i $(BUILD_DIR)/main_floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"

# Bootloader
bootloader: $(BUILD_DIR)/stage1.bin $(BUILD_DIR)/stage2.bin

$(BUILD_DIR)/stage1.bin : always
	$(MAKE) -C bootloader/stage1 BUILD_DIR=$(abspath $(BUILD_DIR))

$(BUILD_DIR)/stage2.bin: always
	$(MAKE) -C bootloader/stage2 BUILD_DIR=$(abspath $(BUILD_DIR))

# Kernel
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(MAKE) -C kernel BUILD_DIR=$(abspath $(BUILD_DIR))

always:
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
