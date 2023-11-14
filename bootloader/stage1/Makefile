BUILD_DIR?=build/
ASM?=nasm
CC16?=/usr/bin/watcom/binl64/wcc
LD16?=/usr/bin/watcom/binl64/wlink

SOURCES_C=$(wildcard *.c)
SOURCES_ASM=$(wildcard *.asm)
OBJECTS_C=$(patsubst %.c, $(BUILD_DIR)/)

bootloader: $(BUILD_DIR)/stage1.bin

$(BUILD_DIR)/stage1.bin:
	$(ASM) boot.asm -f bin -o $(BUILD_DIR)/stage1.bin
