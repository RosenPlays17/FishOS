#!/bin/sh

QEMU_ARGS='-m 32'

case "$1" in
  "disk")   QEMU_ARGS="${QEMU_ARGS} -hda $2" ;;
  *)        echo "Unknown image type $1"
            exit 2
esac

qemu-system-i386 $QEMU_ARGS
