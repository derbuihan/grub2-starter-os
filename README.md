# MyOS

This is a sample project for building an operating system that boots from Grub2.

# Setup

This project is developed using Ubuntu 22.04.

## Install Cross Compiler

To install the cross compiler, execute the following commands. Please be sure to update gcc and binutils to the latest version.

<details>
<summary>Click to expand</summary>

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

</details>

Be sure to add `~/opt/cross/bin` to the `PATH` environment variable.

Reference: https://wiki.osdev.org/GCC_Cross-Compiler

## Install QEMU

```bash
sudo apt install qemu-system-x86
```

## Setup Grub2

Install the tools required to build ISO images.

```bash
sudo apt install xorriso mtools
```

# Build

To create an ISO image, use the following command-

```bash
./build.sh
```

This will create `myos.iso`.

# Run

Use the following command to run the OS:

```bash
qemu-system-x86_64 -cdrom ./myos.iso
```

To execute the kernel directly, use this command:

```bash
qemu-system-x86_64 -kernel ./bin/myos.bin
```

# Real Hardware

To write the ISO image to a USB memory stick, use the following command:

```bash
sudo dd if=./myos.iso of=/dev/sdb
```

Then, boot using the USB memory stick.

# References

https://wiki.osdev.org/Bare_Bones#Booting_the_Operating_System
