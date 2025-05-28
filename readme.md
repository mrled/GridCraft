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
This one makes a small 3x3 grid for the keys:

```text
W E R
S D F
X C V
```

It looks like this:

<img src="./screenshot.png" alt="Screenshot of GridKeys in action" />

```lua
hs.loadSpoon("GridCraft")

spoon.GridCraft.modal(
  -- The hokey to invoke this is ctrl-shift-f11
  { "ctrl", "shift" },
  "f11",
  -- Now we have a table of tables to represent the grid.
  -- (Lua has a data structure called "tables" which can array-like, as we have them here.
  -- They can also be associative key=value tables, but we don't need to know about those to configure GridCraft.)
  -- Our 3x3 grid has 3 rows, and each row has 3 keys
  {
    -- The table for the top row
    {
      -- Regular applications passed with application pull the icon from the application
      spoon.GridCraft.action { key = "w", application = "Terminal" },
      spoon.GridCraft.action { key = "e", application = "ChatGPT" },
      -- Here's a more complicated action
      spoon.GridCraft.action {
        key = "r",
        -- You can make custom actions by passing any Lua function to the action parameter,
        -- even one you define yourself!
        -- Here we use one that is built in to Hammerspoon that will lock the screen.
        action = hs.caffeinate.lockScreen,
        description = "Lock screen",
        -- To use a Phosphor icon, pass the icon name and weight.
        -- Phosphor icons are automatically colored the same color as the description text.
        icon = spoon.GridCraft.iconPhosphor("lock", "regular")
      },
    },
    -- The table for the middle row
    {
      spoon.GridCraft.action { key = "s", application = "1Password" },
      spoon.GridCraft.action { key = "d", application = "OmniFocus" },
      spoon.GridCraft.action { key = "f", application = "Finder" },
    },
    -- The table for the bottom row
    {
      spoon.GridCraft.action { key = "x", application = "Firefox" },
      -- By default it displays the application name, override that with description
      spoon.GridCraft.action { key = "c", application = "Visual Studio Code", description = "VS Code" },
      spoon.GridCraft.action {
        key = "v",
        action = hs.reload,
        description = "hs.reload",
        -- The icon can be anything that returns a <svg> or <img> tag.
        -- This one is using a raw Phosphor icon to show how it works.
        -- (In lua, strings starting with [[ and ending with ]] can include single and double quotes,
        -- as well as newlines, so they are convenient for HTML/SVG elements.)
        icon = [[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256"><rect width="256" height="256" fill="none"/><polyline points="184 104 232 104 232 56" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/><path d="M188.4,192a88,88,0,1,1,1.83-126.23L232,104" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/></svg>]]
        -- In fact, you can also use a Uniocode string for an "icon" instead inside a span element with the "icon" class.
        -- E.g. a letter:
        -- icon = [[<span class="icon">C</span>]]
        -- Or an emoji:
        -- icon = [[<span class="icon">💬</span>]]
      },
    },
  },
  -- This a title that is just nice for logging in the Hammerspoon console.
  "GridKeys Example"
)
```

## Other configuration examples

- [Micah's `init.lua`](https://github.com/mrled/dhd/blob/master/hbase/.hammerspoon/init.lua)

## Notes

- You can encode an image file as base64 and include it inline, like this:
  `"data:image/svg+xml;base64," .. Util.base64("/path/to/your-icon.png")`

## Recommendations

Get a keyboard with programmable keys running [QMK](https://qmk.fm/) or [ZMK](https://zmk.dev/)
and put an F-key somewhere easy to reach.
