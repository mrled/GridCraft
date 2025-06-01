local appsSubmenu = {
  {
    spoon.GridCraft.Action.new { key = "e", application = "Slack" },
    spoon.GridCraft.Action.new { key = "r", application = "Mattermost" },
  },
  {
    spoon.GridCraft.Action.new { key = "d", application = "Discord" },
    spoon.GridCraft.Action.new { key = "f", application = "Messages" },
  },
}

local mainMenu    = {
  {
    spoon.GridCraft.Action.new { key = "e", application = "Terminal" },
    spoon.GridCraft.Action.new { key = "r", application = "Visual Studio Code", description = "VS Code" },
  },
  {
    spoon.GridCraft.Action.new {
      key = "d",
      submenu = appsSubmenu,
      description = "chat",
      -- To use a Phosphor icon, pass the icon name and weight.
      -- Phosphor icons are automatically colored the same color as the description text.
      icon = spoon.GridCraft.Icon.phosphor("chat", "regular")
    },
    spoon.GridCraft.Action.new { key = "f", application = "Finder" },
  },
}

spoon.GridCraft.Grid.new(
  { "ctrl", "shift" },
  "f11",
  mainMenu,
  "SimpleSubmenuExample"
)
