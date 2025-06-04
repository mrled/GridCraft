+++
title = "FAQ"
weight = 70
+++

## How can I control what monitor displays the grid when it's invoked?

See [GridCraft.Configuration.displayScreen]({{< ref "docs/api/gridcraft.configuration" >}}#displayscreen).

We recommend enabling "Displays have separate spaces" in macOS.
To do so:
System Settings.app -> "Desktop and Dock" in left side bar -> "Mission Control" section -> "Displays have separate Spaces".
Unfortunately this requires logging out and back in.

Without this setting enabled, sometimes where the grid opens can be unpredictable.

## What hotkey should I use to invoke GridCraft?

This is totally up to you.

Try a keyboard with programmable keys running [QMK](https://qmk.fm/) or [ZMK](https://zmk.dev/)
and put an F-key that you don't use for something else somewhere easy to reach.
You can just hit one button, without even holding down a modifier key.

For users stuck on laptop keyboards (my condolences),
I hear that [Karabiner Elements](https://karabiner-elements.pqrs.org/)
is popular.

Check out [Configuration In The Wild]({{< ref "in-the-wild" >}})
to see what other users have for their hotkey.

## What's up with Lua "tables" and "tables of tables"?

This is pretty basic Lua knowledge, but the terminology was new to me so I wrote it down here.

Lua has a data structure called "tables" which can array-like lists or object-like key-value associations.

```lua
-- array-like:
{ 1, 2, 3, "etc" }

-- object-like:
{ key="value", key2="value2", key3="etc..." }
```

"Tables of tables" are just nested tables.
The way we lay out our key grids are nested array-like tables:

```lua
{
  -- The table for the top row
  {
    spoon.GridCraft.Action.new { key = "e", application = "Terminal" },
    spoon.GridCraft.Action.new { key = "r", application = "Visual Studio Code", description = "VS Code" },
  },
  -- The table for the bottom row
  {
    spoon.GridCraft.Action.new { key = "d", file = os.getenv("HOME") .. "/Downloads" },
    spoon.GridCraft.Action.new { key = "f", application = "Finder" },
  },
},
```
