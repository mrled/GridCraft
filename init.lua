--[[
  GridCraft: an action menu based on Starcraft 2 Grid Hotkeys
]]

local Action = dofile(hs.spoons.resourcePath("Action.lua"))
local Constants = dofile(hs.spoons.resourcePath("Constants.lua"))
local Grid = dofile(hs.spoons.resourcePath("Grid.lua"))
local Icon = dofile(hs.spoons.resourcePath("Icon.lua"))


local M = {}
M.__index = M

-- Spoon Metadata
M.name = "GridCraft"
-- Try to read version from version.txt file, fallback to default
local function readVersion()
  local versionPath = hs.spoons.resourcePath("version.txt")
  local file = io.open(versionPath, "r")
  if file then
    local version = file:read("*line")
    file:close()
    if version and version ~= "" then
      return version
    end
  end
  return "0.1.0-devel"
end
M.version = readVersion()
M.author = "Micah R Ledbetter <me@micahrl.com>"
M.homepage = "https://github.com/mrled/GridCraft"
M.license = "MIT - https://opensource.org/licenses/MIT"

-- Exported functionality
M.action = Action.action
M.grid = Grid.grid
M.iconPhosphor = Icon.iconPhosphor
M.iconMacFile = Icon.iconMacFile
M.emptyIcon = Icon.emptyIcon
M.exampleConfigFile = hs.spoons.resourcePath("example.lua")

-- Exported constants
M.animationSeconds = Constants.animationSeconds

return M
