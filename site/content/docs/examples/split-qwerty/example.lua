local ergoDoxGrid = {
  {
    -- Left hand top row
    spoon.GridCraft.Action.new { key = "q", application = "Safari" },
    spoon.GridCraft.Action.new { key = "w", application = "Mail" },
    spoon.GridCraft.Action.new { key = "e", application = "Messages" },
    spoon.GridCraft.Action.new { key = "r", application = "Photos" },
    spoon.GridCraft.Action.new { key = "t", application = "FaceTime" },

    -- Spacer
    spoon.GridCraft.Action.new { key = nil, empty = true },
    spoon.GridCraft.Action.new { key = nil, empty = true },

    -- Right hand top row
    spoon.GridCraft.Action.new { key = "y", application = "Calendar" },
    spoon.GridCraft.Action.new { key = "u", application = "Contacts" },
    spoon.GridCraft.Action.new { key = "i", application = "Maps" },
    spoon.GridCraft.Action.new { key = "o", application = "Notes" },
    spoon.GridCraft.Action.new { key = "p", application = "Reminders" },
  },
  {
    -- Left hand middle row
    spoon.GridCraft.Action.new { key = "a", application = "Calculator" },
    spoon.GridCraft.Action.new { key = "s", application = "Dictionary" },
    spoon.GridCraft.Action.new { key = "d", application = "Chess" },
    spoon.GridCraft.Action.new { key = "f", application = "TextEdit" },
    spoon.GridCraft.Action.new { key = "g", application = "Preview" },

    -- Spacer
    spoon.GridCraft.Action.new { key = nil, empty = true },
    spoon.GridCraft.Action.new { key = nil, empty = true },

    -- Right hand middle row
    spoon.GridCraft.Action.new { key = "h", application = "System Settings" },
    spoon.GridCraft.Action.new { key = "j", application = "Activity Monitor" },
    spoon.GridCraft.Action.new { key = "k", application = "Console" },
    spoon.GridCraft.Action.new { key = "l", application = "Terminal" },
    spoon.GridCraft.Action.new { key = ";", application = "Disk Utility" },
  },
  {
    -- Left hand bottom row
    spoon.GridCraft.Action.new { key = "z", application = "Font Book" },
    spoon.GridCraft.Action.new { key = "x", application = "Music" },
    spoon.GridCraft.Action.new { key = "c", application = "System Information" },
    spoon.GridCraft.Action.new { key = "v", application = "Migration Assistant" },
    spoon.GridCraft.Action.new { key = "b", application = "News" },

    -- Spacer
    spoon.GridCraft.Action.new { key = nil, empty = true },
    spoon.GridCraft.Action.new { key = nil, empty = true },

    -- Right hand bottom row
    spoon.GridCraft.Action.new { key = "n", application = "Stocks" },
    spoon.GridCraft.Action.new { key = "m", application = "Home" },
    spoon.GridCraft.Action.new { key = ",", application = "Clock" },
    spoon.GridCraft.Action.new { key = ".", application = "Finder" },
    spoon.GridCraft.Action.new { key = "/", application = "App Store" },
  },
}

local ergoDoxConfig = spoon.GridCraft.Configuration.new()
ergoDoxConfig.gridMaxWidth = 2048

spoon.GridCraft.Grid.new(
-- The hokey to invoke this is ctrl-shift-f11
  { "ctrl", "shift" },
  "f11",
  ergoDoxGrid,
  "GridCraftErgoDoxQwertyExample",
  ergoDoxConfig
)
