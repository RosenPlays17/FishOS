#include "headers/stdint.h"
#include "headers/stdio.h"
#include "headers/disk.h"
#include "headers/fat.h"

void far* g_data = (void far*)0x00500200;

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
          \r\n|_|   |_|___/_| |_|\\___/|____/  v0.1 \r\n\n");

  // browse files in root
  printf("\nFiles in root directory:\r\n");
  FAT_File far* fd = FAT_Open(&disk, "/");
  FAT_DirectoryEntry entry;
  while (FAT_ReadEntry(&disk, fd, &entry) && entry.Name[0] != NULL) {
    printf("  ");
    for (int i = 0; i < 11; i++) {
      putc(entry.Name[i]);
    }
    printf("\r\n");
  }
  FAT_Close(fd);

  // browse files in testdir
  printf("\nFiles in /testdir/:\r\n");
  FAT_File far* td = FAT_Open(&disk, "/testdir/");
  FAT_DirectoryEntry tentry;
  while (FAT_ReadEntry(&disk, td, &tentry) && tentry.Name[0] != NULL) {
    printf("  ");
    for (int i = 0; i < 11; i++) {
      putc(tentry.Name[i]);
    }
    printf("\r\n");
  }
  FAT_Close(td);

  printf("\nContents of /testdir/test.txt:\r\n");
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
