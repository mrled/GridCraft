--- === GridCraft.Util ===
---
--- Generic utility functions

local M = {}


--- GridCraft.Util.getApplicationIconDataUri(string, hs.application) -> string or nil
--- Deprecated
--- Get an application icon as a data: URI
---
--- Parameters:
---  * appName - The name of the application (used for logging)
---  * application - The hs.application object of the application
---
--- Returns:
---  * A string containing a data URI with base64-encoded PNG data of the application icon, or nil if the icon cannot be retrieved
---
--- Notes:
---  * We don't use this internally so it will be removed in the future.
M.getApplicationIconDataUri = function(appName, application)
  print("getApplicationIconDataUri: " .. appName)
  if application == nil then
    return nil
  end
  print(application)
  local appPath = application:path()
  if appPath == nil then
    return nil
  end
  local icon = hs.image.iconForFile(application:path())
  if icon then
    local pngData = icon:encodeAsURLString(false, "png") -- base64-encoded PNG
    return pngData
  end
end


--- GridCraft.Util.fileContents(string) -> string or nil
--- Function
--- Get the contents of a file at a given path
---
--- Parameters:
---  * fullPath - The full path to the file
M.fileContents = function(fullPath)
  local file = io.open(fullPath, "r")
  if file then
    local contents = file:read("*a")
    file:close()
    return contents
  else
    return nil
  end
end


--- GridCraft.Util.base64(string) -> string
--- Function
--- Encode a string in base64 format
---
--- Parameters:
---  * data - The string to encode
M.base64 = function(data)
  local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  return ((data:gsub('.', function(x)
    local r, b = '', x:byte()
    for i = 8, 1, -1 do
      r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')
    end
    return r
  end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if #x < 6 then return '' end
    local c = 0
    for i = 1, 6 do
      c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0)
    end
    return b:sub(c + 1, c + 1)
  end) .. ({ '', '==', '=' })[#data % 3 + 1])
end


--- GridCraft.Util.findApplicationPath(string) -> string or nil
--- Function
--- Find an application path by its name
---
--- Parameters:
---  * appName - The name of the application to find
M.findApplicationPath = function(appName)
  -- If the app name is a fully qualified path, return it directly
  if appName:lower():match("^/") then
    return appName
  end

  -- If the app name doesn't end with ".app", append it
  if not appName:lower():match("%.app$") then
    appName = appName .. ".app"
  end

  -- Check if the app name is a special case
  local specials = {
    ["Finder.app"] = "/System/Library/CoreServices/Finder.app",
  }
  if specials[appName] then
    return specials[appName]
  end

  -- Find the app in common application directories
  local appDirs = {
    "/Applications",
    "/Applications/Utilities",
    "/System/Applications",
    "/System/Applications/Utilities",
    "/System/Library/CoreServices",
    os.getenv("HOME") .. "/Applications",
    os.getenv("HOME") .. "/Applications/Chrome Apps.localized",
  }
  for _, dir in ipairs(appDirs) do
    local appPath = dir .. "/" .. appName
    if hs.fs.attributes(appPath) then
      return appPath
    end
  end

  -- If the app is not found, return nil
  return nil
end


--- GridCraft.Util.getBasename(string) -> string
--- Function
--- Get the last component of a file path, or "/" if the path is the root directory
---
--- Parameters:
---  * path - The file path to get the basename from
M.getBasename = function(path)
  if not path or path == "" then
    return ""
  elseif path == "/" then
    return "/"
  end
  -- Remove trailing slashes
  path = path:gsub("[/\\]+$", "")
  return path:match("([^/\\]+)$") or "/"
end

return M
