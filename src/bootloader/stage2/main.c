#include "h/disk.h"
#include "h/fat.h"
#include "h/mbr.h"
#include "h/memdefs.h"
#include "h/memory.h"
#include "h/stdio.h"
#include <stdint.h>

uint8_t* KernelLoadBuffer = (uint8_t*)MEMORY_LOAD_KERNEL;
uint8_t* Kernel = (uint8_t*)MEMORY_KERNEL_ADDR;

typedef void (*KernelStart)();

void __attribute__((cdecl)) start(uint16_t bootDrive, void* partition) {
  clrscr();
  DISK disk;
  if (!DISK_Initialize(&disk, bootDrive)) {
    printf("Disk init error\n");
    goto end;
  }

  Partition part;
  MBR_DetectPartition(&part, &disk, partition);

  if (!FAT_Initialize(&part)) {
    printf("FAT init error\n");
    goto end;
  }

  // load kernel
  FAT_File* fd = FAT_Open(&part, "/boot/kernel.bin");
  uint32_t read;
  uint8_t* kernelBuffer = Kernel;
  while ((read = FAT_Read(&part, fd, MEMORY_LOAD_SIZE, KernelLoadBuffer))) {
    memcpy(kernelBuffer, KernelLoadBuffer, read);
    kernelBuffer += read;
  }
  FAT_Close(fd);

  printf("Loading Kernel...");

  // execute kernel
  KernelStart kernelStart = (KernelStart)Kernel;
  kernelStart();

end:
  for(;;);
}
