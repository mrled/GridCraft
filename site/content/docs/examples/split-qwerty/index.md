+++
title = "Split QWERTY"
weight = 30
+++

Here's an example of a much larger grid,
a full-QWERTY layout for a split keyboard like an
[ErgoDox](https://www.ergodox.io/),
[Voyager](https://www.zsa.io/voyager),
[Advantage360](https://kinesis-ergo.com/keyboards/advantage360/),
etc

<img src="screenshot.png" alt="A screenshot of the 2x2 grid" />

Notes:

* The default view that contains the grid is 1024x768,
  picked arbitrarily because it's large enough for most grids but small enough for laptop screents.
  This grid is too big for it, so we have to set `gridMaxWidth` to wider.
* Actions set with `key=nil` and `empty=true` are totally blank spaces on the board,
  which let us make that middle space between the hands.

{{< importcode "example.lua" "lua" >}}
