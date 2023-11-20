ASMFLAGS += -f elf
CFLAGS += -ffreestanding -nostdlib -I.
LIBS += -lgcc
LINKFLAGS += -T linker.ld -nostdlib

HEADERS_C = $(shell find . -type f -name "*.h")
HEADERS_ASM = $(shell find . -type f -name "*.inc")
SOURCES_C = $(shell find . -type f -name "*.c")
SOURCES_ASM = $(shell find . -type f -name "*.asm")
OBJECTS_C = $(patsubst %.c, $(BUILD_DIR)/kernel/c/%.obj, $(SOURCES_C))
OBJECTS_ASM = $(patsubst %.asm, $(BUILD_DIR)/kernel/asm/%.obj, $(SOURCES_ASM))

kernel: always $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: $(OBJECTS_ASM) $(OBJECTS_C)
	$(LD) $(LINKFLAGS) -Wl,-Map=$(BUILD_DIR)/kernel.map -o $@ $^ $(LIBS)

$(BUILD_DIR)/kernel/c/%.obj: %.c $(HEADERS_C)
	$(CC) $(CFLAGS) -c -o $@ $<

$(BUILD_DIR)/kernel/asm/%.obj: %.asm $(HEADERS_ASM)
	$(ASM) $(ASMFLAGS) -o $@ $<

always:
	mkdir -p $(BUILD_DIR)/kernel/c/arch/i686
	mkdir -p $(BUILD_DIR)/kernel/c/hal
	mkdir -p $(BUILD_DIR)/kernel/asm/arch/i686
