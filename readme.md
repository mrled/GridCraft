# GridCraft

An action menu based on StarCraft II Grid Hotkeys

See a video demo, example configurations, and full documentation at <https://pages.micahrl.com/GridCraft>.

It looks like this:

<img src="./site/static/screenshot.png" alt="Screenshot of GridCraft in action" style="max-width: 20em;" />

## Installing a release

1. Download `GridCraft.spoon.zip` from the [releases page](https://github.com/mrled/GridCraft/releases)
2. Extract the zipfile
3. Double-click `GridCraft.spoon` in the Finder

Then configure it in your Hammerspoon `init.lua`.
Here's a tiny simple 2x2 hotkey grid to get you started:

```lua
hs.loadSpoon("GridCraft")

-- 2x2 hotkey grid using the keys:
--    E R
--    D F
spoon.GridCraft.Grid.new(
-- The hokey to invoke this is ctrl-shift-f11
  { "ctrl", "shift" },
  "f11",
  {
    -- The table for the top row
    {
      -- Regular applications passed with application pull the icon from the application
      spoon.GridCraft.Action.new { key = "e", application = "Terminal" },
      spoon.GridCraft.Action.new {
        key = "r",
        -- You can make custom actions by passing any Lua function to the action parameter,
        -- even one you define yourself!
        -- This one reloads the Hammerspoon configuration after delay to show the key selection animation.
        -- (Without the delay, the reload happens immediately, before the animationm runs.)
        handler = function()
          hs.timer.doAfter(spoon.GridCraft.Constants.animationSeconds, function()
            hs.reload()
          end)
        end,
        description = "Lock screen",
        -- Use any Phosphor icon
        icon = spoon.GridCraft.Icon.phosphor("arrows-clockwise", "regular")
      },
    },
    -- The table for the bottom row
    {
      -- Files (including folders) will also take their icon and description from the file
      spoon.GridCraft.Action.new { key = "d", file = os.getenv("HOME") .. "/Downloads" },
      -- Applicaions (and files) will use their name as the description, or you can override it
      spoon.GridCraft.Action.new { key = "f", application = "Visual Studio Code", description = "VS Code" },
    },
  },
  -- This a title that is just nice for logging in the Hammerspoon console.
  "GridCraftExample"
)
```

From there, you can:

* Add more keys: perhaps all of QWERTY, or right hand keys, or just home row, whatever feels right
* Add [submenus](https://pages.micahrl.com/GridCraft/docs/examples/simple-submenu/) for more actions with the same keys
* See [what other users are doing](https://pages.micahrl.com/GridCraft/docs/examples/in-the-wild/)

## Development

See [development.md](./development.md) for notes on working with the source code.

Issues and PRs are welcome!
