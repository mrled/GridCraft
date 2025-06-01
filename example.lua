--[[
A simplified example of GridKeys usage with inline documentation.

This one makes a tiny 2x2 grid for the keys:

  E R
  D F
]]

local appsSubmenu = {
  -- The table for the top row
  {
    -- Regular applications passed with application pull the icon from the application
    spoon.GridCraft.Action.new { key = "e", application = "Terminal" },
    -- Applicaions will use their name as the description, or you can override it
    spoon.GridCraft.Action.new { key = "r", application = "Visual Studio Code", description = "VS Code" },
  },
  -- The table for the bottom row
  {
    -- Files (including folders) will also take their icon and description from the file
    spoon.GridCraft.Action.new { key = "d", file = os.getenv("HOME") .. "/Downloads" },
    spoon.GridCraft.Action.new { key = "f", application = "Finder" },
  },
}

local primaryMenu = {
  -- The table for the top row
  {
    -- The E key of the maiun menu invokes the submenu defined above
    spoon.GridCraft.Action.new {
      key = "e",
      submenu = appsSubmenu,
      description = "apps",
      -- To use a Phosphor icon, pass the icon name and weight.
      -- Phosphor icons are automatically colored the same color as the description text.
      icon = spoon.GridCraft.Icon.phosphor("app-store-logo", "regular")
    },
    spoon.GridCraft.Action.new {
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
    spoon.GridCraft.Action.new {
      key = "d",
      -- Reload the Hammerspoon configuration after delay to show the key selection animation.
      -- (Without the delay, the reload happens immediately, before the animationm runs.)
      handler = function()
        hs.timer.doAfter(spoon.GridCraft.Constants.animationSeconds, function()
          hs.reload()
        end)
      end,
      description = "hs.reload",
      -- The icon can a string with an <svg> or <img> tag, like this:
      icon = [[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256"><rect width="256" height="256" fill="none"/><polyline points="184 104 232 104 232 56" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/><path d="M188.4,192a88,88,0,1,1,1.83-126.23L232,104" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/></svg>]]
    },
    spoon.GridCraft.Action.new {
      key = "f",
      -- Run any Lua code you want
      handler = function()
        print("You can run any Lua code you want in a handler")
        -- Open the Hammerspoon console
      end,
      description = "Custom",
      icon = spoon.GridCraft.Icon.phosphor("terminal-window", "regular")
    },
  },
}

spoon.GridCraft.Grid.new(
-- The hokey to invoke this is ctrl-shift-f11
  { "ctrl", "shift" },
  "f11",
  -- The table of tables for the hotkey grid, defined above
  primaryMenu,
  -- This a title that is just nice for logging in the Hammerspoon console.
  "GridCraftExample"
)
