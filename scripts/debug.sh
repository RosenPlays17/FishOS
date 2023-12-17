#!/bin/sh

QEMU_ARGS="-S -gdb stdio -m 32"

case "$1" in
  "disk")   QEMU_ARGS="${QEMU_ARGS} -hda $2" ;;
  *)        echo "Unknown image type $1"
            exit 2
esac

cat > .gdb_script.gdb << EOF
  b *0x7c00
  set disassembly-flavor intel
  layout asm
  target remote | qemu-system-i386 $QEMU_ARGS
  tui reg general
EOF

gdb -x .gdb_script
rm -f .gdb_script
