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

import src/util

type
  TMultiboot_header = object
  PMultiboot_header = ptr TMultiboot_header
  
proc kmain(mb_header: PMultiboot_header, magic: int) {.exportc.} =
  if magic != 0x2BADB002:
    discard

  var vram = cast[PVIDMem](0xB8000)
  screenClear(vram, Yellow)
  var x = len(vram[])
  var outOfBound = vram[x]

  let attr = makeColor(Yellow, DarkGrey)
  writeString(vram, "nim-kernel", attr, (25, 9))
  writeString(vram, "contoh implementasi nim pada kernel", attr, (25, 10))
  rainbow(vram, "masih dalam tahap mengheheh", (x:25, y: 11))
