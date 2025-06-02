# GridCraft

An action menu based on StarCraft II Grid Hotkeys

See a video demo and full documentation at <https://pages.micahrl.com/GridCraft>.

It looks like this:

<img src="./site/static/screenshot.png" alt="Screenshot of GridCraft in action" style="max-width: 20em;" />

## Installing

### Installing a release

1. Download `GridCraft.spoon.zip` from the [releases page](https://github.com/mrled/GridCraft/releases)
2. Extract the zipfile
3. Double-click `GridCraft.spoon` in the Finder

### Installing from source

Build the spoon and install it from the command-line:

```sh
make dist/GridCraft.spoon
mkdir -p ~/.hammerspoon/Spoons
cp -r dist/GridCraft.spoon ~/.hammerspoon/Spoons/
```

(You can also double-click the `GridCraft.spoon` directory in the Finder and it should install it for you.)

### Installing in development

For development, you may want to use the repo directly:

```sh
cd /path/to/GridCraft
make phosphor
cd ~/.hammerspoon/Spoons
ln -s /path/to/GridCraft/spoon GridCraft.spoon
```

## Configuring

See examples in:

* [`example.lua` in this repo](./example.lua)
* The examples section of [the documentation site](https://pages.micahrl.com/GridCraft)

See [`example.lua`](./example.lua) for an example `~/.hammerspoon/init.lua` config.

## Other configuration examples and recommendations

- [Micah's `init.lua`](https://github.com/mrled/dhd/blob/master/hbase/.hammerspoon/init.lua)
- Try a keyboard with programmable keys running [QMK](https://qmk.fm/) or [ZMK](https://zmk.dev/)
  and put an F-key somewhere easy to reach.
  You can just hit one button, without even holding down a modifier key.

## FAQ

### What's up with Lua "tables"?

Lua has a data structure called "tables" which can array-like, as we have them here.

```lua
{ 1, 2, 3, "etc" }
```

They can also be associative key=value tables, but we don't need to know about those to configure GridCraft.

We need tables of tables --- Lua's version of nested arrays ---
in order to represent a grid of rows of hotkeys.

### How can I use an image on the filesystem?

You can encode an image file as base64 and include it inline, like this:
`"data:image/svg+xml;base64," .. Util.base64("/path/to/your-icon.png")`

### How can I control what monitor display the grid when it's invoked?

Enabled "Displays have separate spaces" in macOS:
System Settings.app -> "Desktop and Dock" in left side bar -> "Mission Control" section -> "Displays have separate Spaces".

Unfortunately this requires logging out and back in.
