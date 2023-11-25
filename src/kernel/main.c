#include <h/hal/hal.h>
#include <h/i686/irq.h>
#include <h/memory.h>
#include <h/stdio.h>
#include <stdint.h>

extern uint8_t __bss_start;
extern uint8_t __end;
extern void _init();

void timer(Registers* regs) {
  printf(".");
}

void __attribute__((section(".entry"))) start(uint16_t bootDrive) {
  memset(&__bss_start, 0, (&__end) - (&__bss_start));
  _init(); // call global constructors
  HAL_Initialize();
  clrscr();

  printc("\n _____ _     _      ___  ____     \
          \n|  ___(_)___| |__  / _ \\/ ___|   \
          \n| |_  | / __| '_ \\| | | \\___ \\ \
          \n|  _| | \\__ \\ | | | |_| |___) | \
          \n|_|   |_|___/_| |_|\\___/|____/  v0.1\n\n", 0x09);

  amogus(0x0C);
  
  // i686_IRQ_RegisterHandler(0, timer);
end:
  for(;;);
}
