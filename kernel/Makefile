BUILD_DIR?=build/
ASM?=nasm

all: kernel

kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin:
	$(ASM) main.asm -f bin -o $(BUILD_DIR)/kernel.bin
