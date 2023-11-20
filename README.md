# FishOS
FishOS is a great alternative to operating systems like Windows or MacOS. It is currently bootable from floppy disk and runs in 32-bit mode, has a bootloader and kernel which can print static text to the screen.

### Building
For compiling FishOS you need [nasm](https://github.com/netwide-assembler/nasm), [mtools](https://www.gnu.org/software/mtools/) and custom versions of [gcc](https://ftp.gnu.org/gnu/gcc/?C=M;O=D) and [binutils](https://ftp.gnu.org/gnu/binutils/?C=M;O=A). To build, just run 'make' in the project root and a floppy image should appear in the build directory.
#### Configure gcc and binutils
I installed gcc and binutils into the 'toolchain' folder in the project root, if you put them somewhere else please specify your TOOLCHAIN\_PREFIX in config.mk. You can configure both of them using 'configure' with your args in their respective source directories.<br>
Gcc should be configured with '--target=i686 --prefix=\<your install dir\> --disable-nls --enable-languages=c,c++ --without-headers'. After that you can run 'make all-gcc', 'make all-target-libgcc', 'make install-gcc' and 'make install-target-libgcc' after each other to compile and install gcc and libgcc.<br>
Binutils should be configured with '--target=i686-elf --prefix=\<your install dir\> --with-sysroot --disable-nls --disable-werror'. After that you can run 'make' and 'make install' to compile and install binutils.<br><br>
Note: when using make to compile, you can add the '-j \<cores\>' flag to specify the number of cores the build process should use, which will propably decrease compile times by a lot.
