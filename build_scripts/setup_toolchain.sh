#!/bin/bash

BINUTILS_VERSION="${BINUTILS_VERSION:-2.41}"
GCC_VERSION="${GCC_VERSION:-13.2.0}"

BINUTILS_URL="https://ftp.gnu.org/gnu/binutils/binutils-${BINUTILS_VERSION}.tar.xz"
GCC_URL="https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz"

TARGET=i686-elf

# ---------------------------

set -e

if [ ! -d toolchain ]; then
  mkdir toolchain
fi

TOOLCHAINS_DIR=$(realpath toolchain)

if [ -z "$TOOLCHAINS_DIR" ]; then
    echo "Missing arg: toolchains directory"
    exit 1
fi

pushd "$TOOLCHAINS_DIR"
TOOLCHAIN_PREFIX="$TOOLCHAINS_DIR/$TARGET"

# Download and build binutils
BINUTILS_SRC="binutils-${BINUTILS_VERSION}"
BINUTILS_BUILD="binutils-build-${BINUTILS_VERSION}"

wget ${BINUTILS_URL}
tar -xf binutils-${BINUTILS_VERSION}.tar.xz

mkdir -p ${BINUTILS_BUILD}
pushd ${BINUTILS_BUILD}
../binutils-${BINUTILS_VERSION}/configure \
    --prefix="${TOOLCHAIN_PREFIX}"	\
    --target=${TARGET}				\
    --with-sysroot					\
    --disable-nls					\
    --disable-werror
make -j8 
make install
popd

# Download and build GCC
GCC_SRC="gcc-${GCC_VERSION}"
GCC_BUILD="gcc-build-${GCC_VERSION}"

wget ${GCC_URL}
tar -xf gcc-${GCC_VERSION}.tar.xz
mkdir -p ${GCC_BUILD}
pushd ${GCC_BUILD}
../gcc-${GCC_VERSION}/configure     \
    --prefix="${TOOLCHAIN_PREFIX}" 	\
    --target=${TARGET}				\
    --disable-nls					\
    --enable-languages=c,c++		\
    --without-headers
make -j8 all-gcc all-target-libgcc
make install-gcc install-target-libgcc
popd
