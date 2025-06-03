--- === GridCraft.Icon ===
---
--- Icons etc

local Util = dofile(hs.spoons.resourcePath("Util.lua"))

local M = {}

--- GridCraft.Icon.phosphor(name, [weight]) -> string or nil
--- Function
--- Create an icon from a Phosphor icon name and weight
---
--- Parameters:
---  * name - The name of the Phosphor icon (e.g., "app-window")
---  * weight - The weight of the icon (e.g., "regular", "bold", "duotone"). Defaults to "regular".
M.phosphor = function(name, weight)
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

--- GridCraft.Icon.macFile(filePath) -> string or nil
--- Function
--- Create an icon from the icon of a macOS file (including folders, applications, etc)
---
--- Parameters:
---  * filePath - The path to the file or application for which to get the icon
M.macFile = function(filePath)
  if not filePath then
    hs.printf("⚠️ Icon.macFile: filePath is nil")
    return nil
  end

  local icon = hs.image.iconForFile(filePath)
  if not icon then
    hs.printf("⚠️ Icon.macFile: no icon found for '%s'", filePath)
    return nil
  end

  local pngData = icon:encodeAsURLString(false, "png")
  local imgElement = string.format(
    [[<img src="%s" alt="Icon" width="64" height="64">]],
    pngData
  )
  return imgElement
end

--- GridCraft.Icon.empty() -> string
--- Function
--- Create an empty icon, which is a transparent PNG image
---
--- Parameters:
---  * None
---
--- Returns:
---  * string containing an img tag with the transparent PNG data
M.empty = function()
  local transparentPng =
  "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAAA1BMVEUAAACnej3aAAAAAXRSTlMAQObYZgAAAApJREFUCNdjYAAAAAIAAeIhvDMAAAAASUVORK5CYII="
  return string.format(
    [[<img src="%s" alt="Empty" width="64" height="64">]],
    transparentPng
  )
end


return M
