# FishOS
FishOS is a great alternative to operating systems like Windows or MacOS. It is currently bootable from floppy disk and runs in 32-bit mode, has a bootloader and kernel which can print static text to the screen.

### Building
For building, you need the following packages: bison, flex, libgmp-static, libmpc, mpfr, texinfo, nasm, mtools, qemu-system-x86, python3, python-pyparted, python-sh and scons (these are the package names for Arch-based distros, packages for other distros will be added in the future).<br>
You also need custom versions of gcc and binutils. To build them, run ```scons toolchain```.<br>
After everything is installed you should be able tu use ```scons``` to build and ```scons run``` to run it in qemu.
