#include "headers/stdint.h"
#include "headers/stdio.h"
#include "headers/disk.h"
#include "headers/fat.h"

void _cdecl cstart_(uint16_t bootDrive) {
  DISK disk;
  if (!DISK_Initialize(&disk, bootDrive)) {
    printf("Disk init error\r\n");
    goto end;
  }
  if (!FAT_Initialize(&disk)) {
    printf("FAT init error\r\n");
    goto end;
  }

  printf("\r\n _____ _     _      ___  ____     \
          \r\n|  ___(_)___| |__  / _ \\/ ___|   \
          \r\n| |_  | / __| '_ \\| | | \\___ \\ \
          \r\n|  _| | \\__ \\ | | | |_| |___) | \
          \r\n|_|   |_|___/_| |_|\\___/|____/   \r\n");

  // browse files in root
  printf("\n\nFiles in root directory:\r\n");
  FAT_File far* fd = FAT_Open(&disk, "/");
  FAT_DirectoryEntry entry;
  while (FAT_ReadEntry(&disk, fd, &entry)) {
    printf("  ");
    for (int i = 0; i < 11; i++) {
      putc(entry.Name[i]);
    }
    printf("\r\n");
  }
  FAT_Close(fd);

end:
  for(;;);
}
