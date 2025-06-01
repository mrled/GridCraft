--- === GridCraft.Action ===
---
--- Hotkeys and their handless.

local Grid = dofile(hs.spoons.resourcePath("Grid.lua"))
local Icon = dofile(hs.spoons.resourcePath("Icon.lua"))
local Util = dofile(hs.spoons.resourcePath("Util.lua"))


local M = {}

--- GridCraft.Action.action(table) -> table
--- Constructor
--- Create a new action for a grid
---
--- Parameters:
---  * arg - A table containing the parameters for the action.
---    * Basic parameters:
---      * mods: (table) Modifier keys like `{"cmd", "ctrl"}` to trigger the action along with the key. Use `{}` for no modifiers
---      * key: (string) A key to trigger the action along with the modifiers, like "x" or "F11".
---      * handler: (function) Code to run when the key is pressed
---      * description: (string) A description for the action
---      * icon: (string) An svg or img tag to display as the icon for the action (optional)
---   * Convenience parameters:
---     * empty: (boolean) If true, the handler is set to a no-op function and the description is set to "No action".
---      * This is useful for creating empty slots in the grid.
---      * Overrides handler, description, and icon.
---     * application: (string) The name of an application to switch to.
---      * Overrides handler.
---      * If description/icon are not provided, set to app name/icon.
---     * submenu: (table) A table of actions to create a submenu for this action.
---      * Overrides handler.
---
--- Notes:
---  * Together, the mods and key are passed to `hs.hotkey.bind()` to create a regular Hammerspoon hotkey.
M.action = function(arg)
  local action = {}

  action.mods = arg.mods or {}
  action.key = arg.key
  action.handler = arg.handler or function() end
  action.description = arg.description or ""
  action.icon = arg.icon or Icon.iconPhosphor("app-window", "regular")

  if arg.empty then
    action.handler = function() end
    action.description = "No action"
    action.icon = Icon.emptyIcon()
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
      local appIcon = Icon.iconMacFile(appPath)
      if appIcon then
        action.icon = appIcon
      end
    end
  elseif arg.file then
    action.file = arg.file
    action.handler = function() hs.execute(string.format("open '%s'", action.file)) end
    if not arg.description then
      action.description = Util.getBasename(action.file)
    end
    if arg.icon == nil then
      local fileIcon = Icon.iconMacFile(action.file)
      if fileIcon then
        action.icon = fileIcon
      end
    end
  elseif arg.submenu then
    action.submenu = Grid.grid(
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

return M
