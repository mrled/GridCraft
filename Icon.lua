--[[
  The Icon module
]]

local Util = dofile(hs.spoons.resourcePath("Util.lua"))

local M = {}

--[[
  Create an icon from a Phosphor icon name

  Returns an <svg> tag with the icon
]]
M.iconPhosphor = function(name, weight)
  if not weight then
    weight = "regular"
  end
  local iconPath = string.format("phosphor/assets/%s/%s.svg", weight, name)
  local iconData = Util.fileContents(hs.spoons.resourcePath(iconPath))
  if not iconData then
    print(
      string.format(
        "No Phosphor icon found for %s (%s) - you may need to run `npm install` in the phosphor directory",
        name,
        weight
      )
    )
    return nil
  end
  return iconData
end

--[[
  Create an icon from the icon of a macOS file (including folders, applications, etc)

  Returns an <img> tag with a data URI for the icon
]]
M.iconMacFile = function(filePath)
  local icon = hs.image.iconForFile(filePath)
  local pngData = icon:encodeAsURLString(false, "png") -- base64-encoded PNG
  local imgElement = string.format(
    [[<img src="%s" alt="Icon" width="64" height="64">]],
    pngData
  )
  return imgElement
end

--[[
  Return an empty icon
]]
M.emptyIcon = function()
  local transparentPng =
  "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAAA1BMVEUAAACnej3aAAAAAXRSTlMAQObYZgAAAApJREFUCNdjYAAAAAIAAeIhvDMAAAAASUVORK5CYII="
  return string.format(
    [[<img src="%s" alt="Empty" width="64" height="64">]],
    transparentPng
  )
end


return M
