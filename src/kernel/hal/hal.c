#include <h/hal/hal.h>
#include <h/i686/gdt.h>
#include <h/i686/idt.h>
#include <h/i686/isr.h>
#include <h/i686/irq.h>

void HAL_Initialize() {
  i686_GDT_Initialize();
  i686_IDT_Initialize();
  i686_ISR_Initialize();
  i686_IRQ_Initialize();
}
