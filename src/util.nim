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

type
  PVIDMem* = ptr array[0..65_00, TEntry]
  TVGAColor* = enum
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGrey = 7,
    DarkGrey = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightMagenta = 13,
    Yellow = 14,
    White = 15
  
  TPos* = tuple[x: int, y: int]
  TAttribute* = distinct uint8
  TEntry* = distinct uint16

const
  VGAWidth* = 80
  VGAHeight* = 25

proc makeColor*(bg: TVGAColor, fg: TVGAColor): TAttribute =
  return (ord(fg).uint8 or (ord(bg).uint8 shl 4)).TAttribute

proc makeEntry*(c: char, color: TAttribute): TEntry =
  let c16 = ord(c).uint16
  let color16 = color.uint16
  return (c16 or (color16 shl 8)).TEntry

proc writeChar*(vram: PVIDMem, entry: TEntry, pos: TPos) = 
  let index = (80 * pos.y) + pos.x
  vram[index] = entry

proc rainbow*(vram: PVIDMem, text: string, pos: TPos) =
  var colorBG = DarkGrey
  var colorFG = Blue
  proc nextColor(color: TVGAColor, skip: set[TVGAColor]): TVGAColor =
    if color == White:
      result = Black
    else:
      result = (ord(color) + 1).TVGAColor
    if result in skip:
      result = nextColor(result, skip)

  for i in 0 .. text.len - 1:
    colorFG = nextColor(colorFG, {Black, Cyan, DarkGrey, Magenta, Red, Blue, LightBlue, LightMagenta})
    let attr = makeColor(colorBG, colorFG)
    vram.writeChar(makeEntry(text[i], attr), (pos.x+i, pos.y))

proc writeString*(vram: PVIDMem, text: string, color: TAttribute, pos: TPos) =
  for i in 0 .. text.len - 1:
    vram.writeChar(makeEntry(text[i], color), (pos.x+i, pos.y))

proc screenClear*(video_mem: PVIDMem, color: TVGAColor) =
  let attr = makeColor(color, color)
  let space = makeEntry(' ', attr)
  var i = 0
  while i <=% VGAWidth*VGAHeight:
    video_mem[i] = space
    inc(i)
