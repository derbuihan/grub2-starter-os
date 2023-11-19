# MyOS

This is a sample project for an operating system booting from Grub2.

# Setup

This project is developed on Ubuntu 22.04.

## Install Cross Compiler

Run the following commands to install the cross compiler.
You should rewrite gcc and binutils to the latest version.

```bash
# Install dependencies

sudo apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo  libisl-dev

# Download source code

mkdir ~/src
cd ~/src
wget https://ftp.gnu.org/gnu/binutils/binutils-2.41.tar.gz
tar -xvf binutils-2.41.tar.gz

wget https://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.gz
tar -xvf gcc-13.2.0.tar.gz

# Set up environment variables

export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

# Compile binutils

cd $HOME/src
 
mkdir build-binutils
cd build-binutils
../binutils-2.41/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install

# Compile GCC

cd $HOME/src
 
# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
which -- $TARGET-as || echo $TARGET-as is not in the PATH
 
mkdir build-gcc
cd build-gcc
../gcc-13.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
```

`~/opt/cross/bin` should be added to the `PATH` environment variable.

Reference: https://wiki.osdev.org/GCC_Cross-Compiler

## Install QEMU

```bash
sudo apt install qemu-system-x86
```

## Setup grub2 

Install tools for building ISO images

```bash
sudo apt install xorriso mtools
```

# Build

Create an ISO image

```bash
./build.sh
```

`myos.iso` will be created.

# Run

Run the OS with the following command.

```bash
qemu-system-x86_64 -cdrom ./myos.iso
```

Run the kernel directly.

```bash
qemu-system-x86_64 -kernel ./bin/myos.bin
```

# Real Hardware

Write the ISO image to a USB memory.

```bash
sudo dd if=./myos.iso of=/dev/sdb
```

Boot from the USB memory.

# References

https://wiki.osdev.org/Bare_Bones#Booting_the_Operating_System
