#include "h/hal.h"
#include "../arch/i686/h/gdt.h"
#include "../arch/i686/h/idt.h"
#include "../arch/i686/h/isr.h"
#include "../arch/i686/h/irq.h"

void HAL_Initialize() {
  i686_GDT_Initialize();
  i686_IDT_Initialize();
  i686_ISR_Initialize();
  i686_IRQ_Initialize();
}
