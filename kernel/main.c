#include <stdint.h>
#include "headers/stdio.h"
#include "headers/memory.h"

extern uint8_t __bss_start;
extern uint8_t __end;

void __attribute__((section(".entry"))) start(uint16_t bootDrive) {
  memset(&__bss_start, 0, (&__end) - (&__bss_start));
  clrscr();
  printf("\n _____ _     _      ___  ____     \
          \n|  ___(_)___| |__  / _ \\/ ___|   \
          \n| |_  | / __| '_ \\| | | \\___ \\ \
          \n|  _| | \\__ \\ | | | |_| |___) | \
          \n|_|   |_|___/_| |_|\\___/|____/  v0.1\n\n");

  printf("\n   ___   \
          \n _/   \\ \
          \n/ |  ,--,\
          \n| |  `--'\
          \n\\_|    |\
          \n  |_||_|");

end:
  for(;;);
}
