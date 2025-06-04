+++
title = "GridCraft"
+++

# GridCraft

GridCraft is an action menu based on StarCraft II Grid Hotkeys,
implemented as a [Hammerspoon](https://hammerspoon.org) extension.

It looks like this:

<img src='{{< static "screenshot.png" >}}' style="max-width: 20em;" alt="Screenshot of GridCraft" />

## Installation speedrun

1. First you'll need to install and run [Hammerspoon](https://hammerspoon.org)
2. Then download [GridCraft](https://github.com/mrled/GridCraft/releases) itself from GitHub
3. Extract the zip file and double-click `GridCraft.spoon` to install
4. Configure Hammerspoon; here's a tiny configuration to get started.
    Drop this into `~/.hammerspoon/init.lua`:
    ```lua
    hs.loadSpoon("GridCraft")
    spoon.GridCraft.Grid.new(
      { "ctrl", "shift" },
      "f11",
      {
        {
          spoon.GridCraft.Action.new { key = "e", application = "Terminal" },
          spoon.GridCraft.Action.new { key = "r", application = "Visual Studio Code", description = "VS Code" },
        },
        {
          spoon.GridCraft.Action.new { key = "d", file = os.getenv("HOME") .. "/Downloads" },
          spoon.GridCraft.Action.new { key = "f", application = "Finder" },
        },
      },
      "GridCraftExample"
    )
    ```

With that configuration, pressing ctrl-shift-f11 will launch a tiny 2x2 grid of applications.

Want more?

* See the configuration examples on the left for examples of using different actions, customizing icons, and writing your own action functions
* See the optional [configuration object](http://localhost:1313/GridCraft/docs/api/gridcraft.configuration/)
  for how to customize things like where the grid shows up and the selection animations

## What for?

It's a launcher, but instead of using mnemonic keys as apps like
[Leader Key](https://github.com/mikker/LeaderKey.app) do,
you can lay the hotkeys out spacially in a grid to match your keyboard.

It supports more than just apps ---
Hammerspoon allows you to write custom handlers that run shell scripts, invoke key presses, or do anything else you can do in Lua.
You can also define nested submenus for more commands.

And it comes with icons.
Applications and files use their macOS icons by default.
Any action can specify a custom icon:
all [Phosphor](https://phosphoricons.com) icons are built in and ready to use,
or you can use any image on the filesystem, or any emoji or letter.

## Why a spacial layout?

The idea is that instead of trying to use mnemonic hot keys
like `F` for Finder and `X` for Firefox and `C` for Fantastical and `M` for Find My,
you can instead lay out the applications spacially and remember them by their place.

I first saw this in StarCraft II,
but it was later brought to WarCraft III.
(Maybe some players first encountered this layout in DoTA?)
As I discovered in StarCraft, grid hotkeys are really fast,
because they place the action keys right where your fingers already are in QWERTY.
And just like in StarCraft, this lets you invoke commonly used actions with your left hand ---
even if a mnemonic hotkey would sit on the right side of the keyboard.

(Are you a Dvorak or Colemak weirdo? Don't worry, the grid definition is entirely up to you.)

## Screen recording

Here is a screen recording of GridCraft in action.

<video muted playsinline controls
       style="max-width: 100%; height: auto; display: block; margin: 0 auto;"
       alt="Screen recording of GridCraft">
  <source src='{{< static "screenrecording.mp4" >}}' type="video/mp4">
</video>
