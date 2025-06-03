local parentDir = debug.getinfo(1, "S").source:match("@?(.*/)")

spoon.GridCraft.Grid.new(
-- The hokey to invoke this is ctrl-shift-f11
  { "ctrl", "shift" },
  "f11",
  {
    -- The table for the top row
    {
      -- Get the icon automatically from an application
      spoon.GridCraft.Action.new { key = "q", application = "Messages" },
      -- Get the icon automatically from a file/folder
      spoon.GridCraft.Action.new { key = "e", file = os.getenv("HOME") .. "/Desktop" },
      -- Use a built-in Phosphor icon
      spoon.GridCraft.Action.new {
        key = "r",
        application = "Visual Studio Code",
        description = "VS Code",
        icon = spoon.GridCraft.Icon.phosphor("code", "regular")
      },
    },
    -- The table for the middle row
    {
      spoon.GridCraft.Action.new {
        key = "s",
        application = "Signal",
        icon = spoon.GridCraft.Icon.fileContents(parentDir .. "/metroid.png")
      },
      -- Use an emoji
      spoon.GridCraft.Action.new {
        key = "d",
        file = os.getenv("HOME") .. "/Downloads",
        icon = [[<span class="icon">📁</span>]]
      },
      -- Use a single letter
      spoon.GridCraft.Action.new {
        key = "f",
        application = "Finder",
        icon = [[<span class="icon">F</span>]],
      },
    },
    -- The table for the bottom row
    {
      spoon.GridCraft.Action.new {
        key = "x",
        handler = function()
          hs.timer.doAfter(spoon.GridCraft.Constants.animationSeconds, function()
            hs.reload()
          end)
        end,
        description = "hs.reload",
        -- A string with an svg element
        icon = [[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256"><rect width="256" height="256" fill="none"/><polyline points="184 104 232 104 232 56" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/><path d="M188.4,192a88,88,0,1,1,1.83-126.23L232,104" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="16"/></svg>]]
      },
      spoon.GridCraft.Action.new {
        key = "c",
        empty = true
      },
      spoon.GridCraft.Action.new {
        key = "z",
        empty = true
      },
    }
  },
  -- This a title that is just nice for logging in the Hammerspoon console.
  "GridCraftExampleSimpleIcons"
)
