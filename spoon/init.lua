--- === GridCraft ===
---
--- An action menu based on StarCraft II Grid Hotkeys.
---
--- <https://github.com/mrled/GridCraft>
---
--- This is the main module for GridCraft.
--- All functionality is contained in the submodules.
---
--- Example:
--- ```lua
--- spoon.GridCraft.Grid.new(
---   { "ctrl", "shift" },
---   "f11",
---   {
---     {
---       spoon.GridCraft.Action.new { key = "e", application = "Terminal", icon = spoon.GridCraft.Icon.phosphor("terminal-window", "regular") },
---       spoon.GridCraft.Action.new { key = "d", application = "Visual Studio Code", description = "VS Code" },
---     },
---     {
---       spoon.GridCraft.Action.new { key = "d", file = os.getenv("HOME") .. "/Downloads" },
---       spoon.GridCraft.Action.new { key = "f", application = "Finder" },
---     },
---   },
---   "GridCraftExample"
--- )
--- ```
--- For more complete examples, see:
--- * `../example.lua`
--- * The documentation at <https://pages.micahrl.com/GridCraft>

local Action = dofile(hs.spoons.resourcePath("Action.lua"))
local Configuration = dofile(hs.spoons.resourcePath("Configuration.lua"))
local Grid = dofile(hs.spoons.resourcePath("Grid.lua"))
local Icon = dofile(hs.spoons.resourcePath("Icon.lua"))


local M = {}
M.__index = M

-- Read version from version.txt file
local function readVersion()
    local defaultVersion = "devel"
    local versionPath = hs.spoons.resourcePath("version.txt")

    local file = io.open(versionPath, "r")
    if not file then return defaultVersion end
    local content = file:read("*all")
    file:close()

    -- Trim all whitespace and take first line
    local trimmed = content:match("^%s*(.-)%s*$")
    local firstLine = trimmed:match("([^\r\n]*)")

    if not firstLine then
        return defaultVersion
    end
    return firstLine
end

-- Spoon Metadata
M.name = "GridCraft"
M.version = readVersion()
M.author = "Micah R Ledbetter <me@micahrl.com>"
M.homepage = "https://github.com/mrled/GridCraft"
M.license = "MIT - https://opensource.org/licenses/MIT"

M.Action = Action
M.Configuration = Configuration
M.Grid = Grid
M.Icon = Icon

return M
