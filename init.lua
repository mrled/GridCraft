--[[
  GridCraft: an action menu based on Starcraft 2 Grid Hotkeys
]]

if not hs then
  print("Hammerspoon not running, exiting...")
  return
end

local Util = dofile(hs.spoons.resourcePath("Util.lua"))
local WebView = dofile(hs.spoons.resourcePath("WebView.lua"))


local M = {}
M.__index = M
M.name = "GridCraft"
M.version = "0.1.0"
M.author = "Micah R Ledbetter <me@micahrl.com>"
M.homepage = "https://github.com/mrled/GridCraft"
M.license = "MIT - https://opensource.org/licenses/MIT"


--[[
hotkey(): A hotkey and its handler

Basic parameters:
  mods: (table) Modifier keys like {"cmd", "ctrl"} to trigger the action along with the key. Use {} for no modifiers
  key: (string) A key to trigger the action along with the modifiers, like "x" or "F11".
    Together, the mods and key are passed to hs.hotkey.bind() to create a regular Hammerspoon hotkey.
  handler: (function) Code to run when the key is pressed
  description: (string) A description for the action
  icon: (string) An <svg> or <img> tag to display as the icon for the action (optional)

Convenience parameters:
  empty: (boolean) If true, the handler is set to a no-op function and the description is set to "No action".
    This is useful for creating empty slots in the grid.
    Overrides handler, description, and icon.
  application: (string) The name of an application to switch to.
    Overrides handler.
    If description/icon are not provided, set to app name/icon.
  submenu: (table) A table of actions to create a submenu for this action.
    Overrides handler.
]]
M.action = function(arg)
  local action = {}

  action.mods = arg.mods or {}
  action.key = arg.key
  action.handler = arg.handler or function() end
  action.description = arg.description or ""
  action.icon = arg.icon or M.iconPhosphor("app-window", "regular")

  if arg.empty then
    action.handler = function() end
    action.description = "No action"
    action.icon = M.emptyIcon()
    return action
  elseif arg.application then
    action.application = arg.application
    action.handler = function() hs.application.launchOrFocus(action.application) end
    if not arg.description then
      action.description = action.application
    end
    if arg.icon == nil then
      -- Don't use hs.application.find() -- that only works for running apps!
      -- local app = hs.application.find(arg.application)
      local appPath = Util.findApplicationPath(arg.application)
      local appIcon = M.iconMacFile(appPath)
      if appIcon then
        action.icon = appIcon
      end
    end
  elseif arg.submenu then
    action.submenu = M.grid(
    -- The first two arguments are for a GLOBAL hotkey, so we set them to nil.
      nil,
      nil,
      arg.submenu,
      action.description
    )
    -- Can't set action here, have to do it from the parent modal
  end

  return action
end


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


--[[
grid(): Create a new grid of hotkeys

Parameters:
  mods: Modifier keys as could be4 passed to hs.hotkey.modal.new(), like {"cmd", "ctrl"} or {}
  key: A key to trigger the modal hotkey as could be passed to hs.hotkey.modal.new(), like "t"
  actionTable: (table) A table of rows, each of which is a table of actions.
    e.g. to represent the left half of a qwerty keyboard, you might use:
    {
      {
        GridCraft.handler { key = "1", application = "1Password" },
        GridCraft.handler { key = "2", application = "Day One" },
        GridCraft.handler { key = "3", application = "Photos" },
        GridCraft.handler { key = "4", empty = true },
        GridCraft.handler { key = "5", empty = true },
      },
      {
        GridCraft.handler { key = "q", application = "Messages"},
        GridCraft.handler { key = "w", application = "Mattermost" },
        GridCraft.handler { key = "e", application = "Visual Studio Code" },
        GridCraft.handler { key = "r", application = "Bear" },
        GridCraft.handler { key = "t", application = "Terminal" },
      },
    }
    Note that we are constrained to using array tables rather than key-value tobles
    so that the order is preserved.
  title: (string) (optional) A message prefix to display when communicating to the user about this hot key
]]
M.grid = function(mods, key, actionTable, title)
  local result = {}
  result.triggerKey = hs.hotkey.modal.new(mods, key)
  result.activeWebView = nil
  result.title = title or "GridCraft"

  print("GridCraft grid: " .. result.title .. " " .. hs.inspect(mods) .. " " .. hs.inspect(key))

  -- Press escape to close the grid
  result.triggerKey:bind({}, "escape", function() result.triggerKey:exit() end)
  -- If a trigger key was passed, press it to close the grid
  if key ~= nil then
    result.triggerKey:bind(mods, key, function() result.triggerKey:exit() end)
  end

  for _, keyRow in ipairs(actionTable) do
    for _, action in ipairs(keyRow) do
      if action ~= nil and action.key ~= nil then
        -- Bind the subkey to the action
        result.triggerKey:bind(action.mods, action.key, function()
          action.handler()
          result.triggerKey:exit()
        end)
        -- Set the action handler for the submenu.
        -- (We must do this here because we need modality in scope)
        if action.submenu then
          action.handler = function()
            -- Stop showing the parent
            result:stop()
            -- Stop the parent hotkey
            result.triggerKey:exit()
            -- Set the parent's hotkey to close the child submenu
            -- If the user hits the main hotkey, then enters a submenu, and then hits the main hotkey again,
            -- this will close both, rather than display the main menu on top of the submenu.
            action.submenu.triggerKey:bind(mods, key, function() action.submenu.triggerKey:exit() end)
            -- Show the submenu
            action.submenu:start()
          end
        end
      end
    end
  end

  -- Create the web view here, and only show/hide it in the callback functions.
  -- This means it is rendered when new() is called, and show() displays it instantly.
  result.activeWebView = WebView.webView(result.title, actionTable, 1024, 768)

  result.triggerKey.entered = function(self)
    WebView.resizeCenter(result.activeWebView, 1024, 768)
    result.activeWebView:show()
  end

  result.triggerKey.exited = function(self)
    result.activeWebView:hide()
  end

  result.start = function(self)
    self.triggerKey:enter()
  end
  result.stop = function(self)
    self.triggerKey:exit()
  end

  return result
end


return M
