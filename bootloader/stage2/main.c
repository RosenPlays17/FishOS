#include <stdint.h>
#include <stddef.h>
#include "headers/disk.h"
#include "headers/fat.h"
#include "headers/stdio.h"

void __attribute__((cdecl)) start(uint16_t bootDrive) {
  clrscr();
  printf("\n _____ _     _      ___  ____     \
          \n|  ___(_)___| |__  / _ \\/ ___|   \
          \n| |_  | / __| '_ \\| | | \\___ \\ \
          \n|  _| | \\__ \\ | | | |_| |___) | \
          \n|_|   |_|___/_| |_|\\___/|____/  v0.1\n\n");

  DISK disk;
  if (!DISK_Initialize(&disk, bootDrive)) {
    printf("Disk init error\n");
    goto end;
  }
  if (!FAT_Initialize(&disk)) {
    printf("FAT init error\n");
    goto end;
  }

  FAT_File* fd = FAT_Open(&disk, "/");
  FAT_DirectoryEntry entry;

  // browse files in root
  printf("\nFiles in root directory:\n");
  while (FAT_ReadEntry(&disk, fd, &entry) && entry.Name[0] != NULL) {
    printf("  ");
    for (int i = 0; i < 11; i++) {
      putc(entry.Name[i]);
    }
    printf("\n");
  }
  FAT_Close(fd);

  // browse files in testdir
  printf("\nFiles in /testdir/:\n");
  fd = FAT_Open(&disk, "/testdir/");
  while (FAT_ReadEntry(&disk, fd, &entry) && entry.Name[0] != NULL) {
    printf("  ");
    for (int i = 0; i < 11; i++) {
      putc(entry.Name[i]);
    }
    printf("\n");
  }
  FAT_Close(fd);

  printf("\nContents of /testdir/test.txt:\n");
  char buffer[100];
  uint32_t read;
  fd = FAT_Open(&disk, "/testdir/test.txt");
  while ((read = FAT_Read(&disk, fd, sizeof(buffer), buffer)))
  {
    for (uint32_t i = 0; i < read; i++)
    {
      if (buffer[i] == '\n')
        putc('\r');
      putc(buffer[i]);
    }
  }
  FAT_Close(fd);

end:
  for(;;);
}
