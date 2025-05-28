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
action(): An action to take when a shortcut key is pressed

Basic parameters:
  mods: (table) Modifier keys like {"cmd", "ctrl"} to trigger the action along with the key. Use {} for no modifiers
  key: (string) A key to trigger the action along with the modifiers, like "x" or "F11".
    Together, the mods and key are passed to hs.hotkey.bind() to create a regular Hammerspoon hotkey.
  action: (function) An action to take
  description: (string) A description for the action
  icon: (string) An <svg> or <img> tag to display as the icon for the action (optional)

Convenience parameters:
  empty: (boolean) If true, the action is set to a no-op function and the description is set to "No action"
    This is useful for creating empty slots in the grid.
    Overrides action, description, and icon.
  application: (string) The name of an application to switch to (mutually exclusive with action).
    Overrides action.
    If description/icon are not provided, set to app name/icon.

Note: if application is passed, the action is automatically set to hs.application.launchOrFocus(app)
Note: if application is passed and description is nil, application will be used for description
]]
M.action = function(arg)
  local action = {}

  action.mods = arg.mods or {}
  action.key = arg.key
  action.action = arg.action or function() end
  action.description = arg.description or ""
  action.icon = arg.icon or M.iconPhosphor("app-window", "regular")

  if arg.empty then
    action.action = function() end
    action.description = "No action"
    action.icon = M.emptyIcon()
    return action
  elseif arg.application then
    action.application = arg.application
    action.action = function() hs.application.launchOrFocus(action.application) end
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
modal(): Create a new modal hotkey

Parameters:
  mods: Modifier keys as could be4 passed to hs.hotkey.modal.new(), like {"cmd", "ctrl"} or {}
  key: A key to trigger the modal hotkey as could be passed to hs.hotkey.modal.new(), like "t"
  actionTable: (table) A table of rows, each of which is a table of actions.
    e.g. to represent the left half of a qwerty keyboard, you might use:
    Map keys from the keyGrid to action tables, like:
    {
      {
        GridCraft.action { key = "1", application = "1Password" },
        GridCraft.action { key = "2", application = "Day One" },
        GridCraft.action { key = "3", application = "Photos" },
        GridCraft.action { key = "4", empty = true },
        GridCraft.action { key = "5", empty = true },
      },
      {
        GridCraft.action { key = "q", empty = true },
        -- GridCraft.action { key = "q", application = "Messages"},
        GridCraft.action { key = "w", application = "Mattermost" },
        GridCraft.action { key = "e", application = "Visual Studio Code" },
        GridCraft.action { key = "r", application = "Bear" },
        GridCraft.action { key = "t", application = "Terminal" },
      },
    }
    Note that we are constrained to using array tables rather than key-value tobles
    so that the order is preserved.
  title: A message prefix to display when communicating to the user about this hot key
]]
M.modal = function(mods, key, actionTable, title)
  local modality = {}
  modality.triggerKey = hs.hotkey.modal.new(mods, key)
  modality.activeWebView = nil

  modality.alertStyle = {
    fillColor = {
      white = 0.45,
      alpha = 1,
    },
    strokeWidth = 10,
    fadeInDuration = 0,
    fadeOutDuration = 0,
  }

  print("modal: " .. title .. " " .. hs.inspect(mods) .. " " .. key)

  -- define explicit ways out: either press escape or the trigger key
  modality.triggerKey:bind({}, "escape", function() modality.triggerKey:exit() end)
  modality.triggerKey:bind(mods, key, function() modality.triggerKey:exit() end)

  for _, keyRow in pairs(actionTable) do
    for _, action in pairs(keyRow) do
      if action ~= nil and action.key ~= nil then
        if action.empty == true then
          -- do nothing
        else
          modality.triggerKey:bind({}, action.key, function()
            action.action()
            modality.triggerKey:exit()
          end)
        end
      end
    end
  end

  -- Create the web view here, and only show/hide it in the callback functions.
  -- This means it is rendered when new() is called, and show() displays it instantly.
  modality.activeWebView = WebView.webView(title, actionTable, 1024, 768)

  modality.triggerKey.exitWithMessage = function(self, message)
    hs.alert.show(title .. "\n\n" .. message, modality.alertStyle)
    self:exit()
  end

  modality.triggerKey.entered = function(self)
    modality.activeWebView:show()
  end

  modality.triggerKey.exited = function(self)
    modality.activeWebView:hide()
  end

  modality.start = function(self)
    self.triggerKey:enter()
  end
  modality.stop = function(self)
    self.triggerKey:exit()
  end

  return modality
end


return M
