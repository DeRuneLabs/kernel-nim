# MIT License

# Copyright (c) 2024 DeRuneLabs

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import nake
import os

const
  CC = "i686-elf-gcc"
  asmC = "i686-elf-as"

task "clean", "remove build file":
  removeFile("boot.o")
  removeFile("main.bin")
  removeFile("nimcache")
  echo "kelar"

task "build", "build kernel":
  echo "compile"
  direShell "nim c -d:release --nimcache:nimcache --gcc.exe:$1 main.nim" % CC
  echo "linking"
  direShell CC, "-T linker.ld -o main.bin -ffreestanding -O2 -nostdlib boot.o nimcache/@mmain.nim.c.o nimcache/stdlib_system.nim.c.o nimcache/@mioutils.nim.c.o -lgcc"

task "run", "run kernel":
  if not existsFile("main.bin"):
    runTask("build")
  direShell "qemu-system-i86 -kernel main.bin"
