spoon.GridCraft.Grid.new(
-- The hokey to invoke this is ctrl-shift-f11
  { "ctrl", "shift" },
  "f11",
  {
    -- The table for the top row
    {
      -- Regular applications passed with application pull the icon from the application
      spoon.GridCraft.Action.new { key = "e", application = "Terminal" },
      -- Applicaions will use their name as the description, or you can override it
      spoon.GridCraft.Action.new { key = "d", application = "Visual Studio Code", description = "VS Code" },
    },
    -- The table for the bottom row
    {
      -- Files (including folders) will also take their icon and description from the file
      spoon.GridCraft.Action.new { key = "d", file = os.getenv("HOME") .. "/Downloads" },
      spoon.GridCraft.Action.new { key = "f", application = "Finder" },
    },
  },
  -- This a title that is just nice for logging in the Hammerspoon console.
  "GridCraftExample"
)
