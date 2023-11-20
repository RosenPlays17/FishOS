export TARGET = i686-elf
export BUILD_DIR = $(abspath build)
TOOLCHAIN_PREFIX = $(abspath toolchain/$(TARGET))
export PATH := $(TOOLCHAIN_PREFIX)/bin:$(PATH)
export CFLAGS = -std=c99 -g
export CC = $(TARGET)-gcc
export CXX = $(TARGET)-g++
export LD = $(TARGET)-gcc
export ASM = nasm
export ASMFLAGS = 
export LINKFLAGS = 
export LIBS = 
