+++
title = "GridCraft"
+++

# GridCraft

GridCraft is an action menu based on StarCraft II Grid Hotkeys,
implemented as a [Hammerspoon](https://hammerspoon.org) extension.

It looks like this:

<img src='{{< static "screenshot.png" >}}' style="max-width: 20em;" alt="Screenshot of GridCraft" />

## What for?

This is just a regular app launcher that you invoke with a hotkey;
the only difference between it and something like
[Leader Key](https://github.com/mikker/LeaderKey.app)
is that the hotkeys are laid out in a grid to match your keyboard.

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

It has all [Phosphor](https://phosphoricons.com) icons built in and ready to use,
and it supports launching macOS applications/files/folders,
running any Lua code you want,
and nested submenus.

Take a look at the examples in the left menu to get started.

## Screen recording

Here is a screen recording of GridCraft in action.

<video muted playsinline controls
       style="max-width: 100%; height: auto; display: block; margin: 0 auto;"
       alt="Screen recording of GridCraft">
  <source src='{{< static "screenrecording.mp4" >}}' type="video/mp4">
</video>

## Colophon

* Made with <3 by [Micah](https://me.micahrl.com)
* Includes the excellent [Phosphor Icons](https://phosphoricons.com)
* Documentation site built with [Hugo](https://gohugo.io)
* Documentation site themed with Alex Shpak's [Hugo Book theme](https://github.com/alex-shpak/hugo-book)
* See the author's Hammerspoon configuration, including GridCraft layout,
  [on GitHub](https://github.com/mrled/dhd/blob/master/hbase/.hammerspoon/init.lua)


