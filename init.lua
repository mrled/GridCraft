--[[
  GridCraft: an action menu based on Starcraft 2 Grid Hotkeys
]]

local Action = dofile(hs.spoons.resourcePath("Action.lua"))
local Grid = dofile(hs.spoons.resourcePath("Grid.lua"))
local Icon = dofile(hs.spoons.resourcePath("Icon.lua"))


local M = {}
M.__index = M

-- Spoon Metadata
M.name = "GridCraft"
M.version = "0.1.0"
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

return M
