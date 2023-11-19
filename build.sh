#!/bin/bash

mkdir -p build bin isodir/boot/grub

export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

make all
