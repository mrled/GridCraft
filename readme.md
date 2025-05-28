# GridCraft

An action menu based on Starcraft 2 Grid Hotkeys

## Installing

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
ln -s /path/to/GridCraft GridCraft.spoon
```

## Configuring

Here's a simplified example.
This one makes a tiny 2x2 grid for the keys:

```text
E R
D F
```

It looks like this:

<img src="./screenshot.png" alt="Screenshot of GridKeys in action" />

```lua
hs.loadSpoon("GridCraft")

local appsSubmenu = {
  {
    -- The table for the top row
    {
      -- Regular applications passed with application pull the icon from the application
      spoon.GridCraft.action { key = "e", application = "Terminal" },
      spoon.GridCraft.action { key = "r", application = "Firefox" },
    },
    -- The table for the bottom row
    {
      -- Applicaions will use their name as the description, or you can override it
      spoon.GridCraft.action { key = "d", application = "Visual Studio Code", description = "VS Code" },
      spoon.GridCraft.action { key = "f", application = "Finder" },
    },
  }
}

local primaryMenu = {
  -- The table for the top row
  {
    -- The E key of the maiun menu invokes the submenu defined above
    spoon.GridCraft.action {
      key = "e",
      submenu = appsSubmenu,
      description = "apps",
      -- To use a Phosphor icon, pass the icon name and weight.
      -- Phosphor icons are automatically colored the same color as the description text.
      icon = spoon.GridCraft.iconPhosphor("app-store-logo", "regular")
    },
    spoon.GridCraft.action {
      key = "r",
      -- You can make custom actions by passing any Lua function to the action parameter,
      -- even one you define yourself!
      -- Here we use one that is built in to Hammerspoon that will lock the screen.
      handler = hs.caffeinate.lockScreen,
      description = "Lock screen",
      -- You can also use a string for an icon, including single characters and emoji,
      -- as long as its wrapped in a span with the icon class:
      icon = [[<span class="icon">🔒</span>]]
    },
  },
  -- The table for the bottom row
  {
    spoon.GridCraft.action {
      key = "d",
      -- Reload the Hammerspoon configuration
      handler = hs.reload,
      description = "hs.reload",
      -- The icon can a string with an <svg> or <img> tag, like this:
      icon = [[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256"><rect width="256" height="256" fill="none"/><polyline points="184 104 232 104 232 56" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/><path d="M188.4,192a88,88,0,1,1,1.83-126.23L232,104" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/></svg>]]
    },
    spoon.GridCraft.action {
      key = "f",
      -- Run any Lua code you want
      handler = function()
        print("You can run any Lua code you want in a function")
      end,
      description = "Console",
      icon = spoon.GridCraft.iconPhosphor("terminal-window", "regular")
    },
  },
}

spoon.GridCraft.grid(
  -- The hokey to invoke this is ctrl-shift-f11
  { "ctrl", "shift" },
  "f11",
  -- The table of tables for the hotkey grid, defined above
  primaryMenu,
  -- This a title that is just nice for logging in the Hammerspoon console.
  "GridKeys Example"
)
```

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
