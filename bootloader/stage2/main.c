#include "headers/stdint.h"
#include "headers/stdio.h"

void _cdecl cstart_(uint16_t bootDrive) {
  puts("Among Us in C\r\n");
  printf("Among Us %s %c %%\r\n", "in printf", 'e');
  printf("printf %d %i %x %p %o %hd %hi %hhu\r\n", 1234, 5678, 0xdead, 0xbeef, 012345, (short)27, (short)-42, (unsigned char)20);
  for(;;);
}
