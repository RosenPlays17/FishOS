ASMFLAGS += -f elf
CFLAGS += -ffreestanding -nostdlib -I.
LIBS += -lgcc
LINKFLAGS += -T linker.ld -nostdlib

HEADERS_C = $(shell find . -type f -name "*.h")
HEADERS_ASM = $(shell find . -type f -name "*.inc")
SOURCES_C = $(shell find . -type f -name "*.c")
SOURCES_ASM = $(shell find . -type f -name "*.asm")
OBJECTS_C = $(patsubst %.c, $(BUILD_DIR)/stage2/c/%.obj, $(SOURCES_C))
OBJECTS_ASM = $(patsubst %.asm, $(BUILD_DIR)/stage2/asm/%.obj, $(SOURCES_ASM))

bootloader: always $(BUILD_DIR)/stage2.bin

$(BUILD_DIR)/stage2.bin: $(OBJECTS_ASM) $(OBJECTS_C)
	$(LD) $(LINKFLAGS) -Wl,-Map=$(BUILD_DIR)/stage2.map -o $@ $^ $(LIBS)

$(BUILD_DIR)/stage2/c/%.obj: %.c $(HEADERS_C)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/stage2/asm/%.obj: %.asm $(HEADERS_ASM)
	$(ASM) $(ASMFLAGS) -o $@ $<

always:
	mkdir -p $(BUILD_DIR)/stage2/c
	mkdir -p $(BUILD_DIR)/stage2/asm
