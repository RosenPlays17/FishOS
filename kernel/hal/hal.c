#include <h/hal/hal.h>
#include <h/i686/gdt.h>
#include <h/i686/idt.h>

void HAL_Initialize() {
  i686_GDT_Initialize();
  i686_IDT_Initialize();
}
