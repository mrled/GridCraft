--- === GridCraft ===
---
--- An action menu based on Starcraft 2 Grid Hotkeys.
---
--- <https://github.com/mrled/GridCraft>

local Action = dofile(hs.spoons.resourcePath("Action.lua"))
local Constants = dofile(hs.spoons.resourcePath("Constants.lua"))
local Examples = dofile(hs.spoons.resourcePath("Examples.lua"))
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

M.action = Action.action
M.grid = Grid.grid
M.iconPhosphor = Icon.iconPhosphor
M.iconMacFile = Icon.iconMacFile
M.emptyIcon = Icon.emptyIcon
M.examples = Examples
M.animationSeconds = Constants.animationSeconds

return M
