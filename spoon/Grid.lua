--- === GridCraft.Grid ===
---
--- A grid of hotkeys.


local Configuration = dofile(hs.spoons.resourcePath("Configuration.lua"))
local WebView = dofile(hs.spoons.resourcePath("WebView.lua"))


local M = {}


--- GridCraft.Grid.new(table, string, table, string) -> table
--- Constructor
--- Create a new grid of hotkeys
---
--- Parameters:
---  * mods: Modifier keys as could be4 passed to `hs.hotkey.modal.new()`, like `{"cmd", "ctrl"}` or `{}`
---  * key: A key to trigger the modal hotkey as could be passed to `hs.hotkey.modal.new()`, like `t`
---  * actionTable: (table) A table of rows, each of which is a table of actions.
---       e.g. to represent the left half of a qwerty keyboard, you might use:
---       ```lua
---       {
---         {
---           GridCraft.handler { key = "1", application = "1Password" },
---           GridCraft.handler { key = "2", application = "Day One" },
---           GridCraft.handler { key = "3", application = "Photos" },
---           GridCraft.handler { key = "4", empty = true },
---           GridCraft.handler { key = "5", empty = true },
---         },
---         {
---           GridCraft.handler { key = "q", application = "Messages"},
---           GridCraft.handler { key = "w", application = "Mattermost" },
---           GridCraft.handler { key = "e", application = "Visual Studio Code" },
---           GridCraft.handler { key = "r", application = "Bear" },
---           GridCraft.handler { key = "t", application = "Terminal" },
---         },
---       }
---       ```
---       Note that we are constrained to using array tables rather than key-value tobles
---       so that the order is preserved.
---  * title: (string) (optional) A message prefix to display when communicating to the user about this hot key
---  * config: (GridCraft.Configuration) (optional) A configuration object for the grid.
---
--- Returns:
---   * A GridCraft grid of hotkeys
M.new = function(mods, key, actionTable, title, config)
  local result = {}
  result.triggerKey = hs.hotkey.modal.new(mods, key)
  result.activeWebView = nil
  result.title = title or "GridCraft"
  result.config = config or Configuration.new()

  print(string.format("GridCraft grid: '%s' %s-%s, configuration: \n%s", result.title, hs.inspect(mods), hs.inspect(key),
    hs.inspect(result.config)))

  -- Press escape to close the grid
  result.triggerKey:bind({}, "escape", function() result.triggerKey:exit() end)
  -- If a trigger key was passed, press it to close the grid
  if key ~= nil then
    result.triggerKey:bind(mods, key, function() result.triggerKey:exit() end)
  end

  -- Give each key an identifier based on its position in the grid.
  -- We have to do this in a separate loop before we process the actionTable (below),
  -- because we need the keyId to be set before we pass the actionTable to the web view.
  for rowIdx, keyRow in ipairs(actionTable) do
    for colIdx, action in ipairs(keyRow) do
      action.keyId = string.format("%sx%s", rowIdx, colIdx)
    end
  end

  --- GridCraft.Grid:applyConfiguration()
  --- Method
  --- Apply the configuration to the grid.
  ---
  --- Notes:
  ---  * This is run when the grid is created and when setConfiguration() is called,
  ---    and makes sure that the configuration is applied to the web view, all submenus, etc.
  function result:applyConfiguration()
    -- Create the web view here, and only show/hide it in the callback functions.
    -- This means it is rendered when new() is called, and show() displays it instantly.
    self.activeWebView = WebView.webView(self.title, actionTable, self.config)

    -- Define a reference for the current grid to be used inside self.triggerKey.* methods.
    -- In those methods, 'self' will refer to the triggerKey, not the grid,
    -- so we need to capture the grid in a local variable.
    local thisGrid = self

    -- Show the grid when the user hits the hotkey
    -- function result.triggerKey:entered()
    self.triggerKey.entered = function(self)
      -- Always resize the web view to ensure it runs on the active screen
      WebView.resizeCenter(result.activeWebView, thisGrid.config)
      thisGrid.activeWebView:show()
    end

    -- Dismiss the grid when the user hits one of the grid keys (or one of the close keys)
    -- function result.triggerKey:exited()
    function self.triggerKey.exited(self)
      -- Wait for a short time before hiding the web view so we can see the selected animation
      hs.timer.doAfter(thisGrid.config:animationSeconds(), function()
        thisGrid.activeWebView:hide()
      end)
    end

    -- Start the grid, and enter the modal key (which enables all the keys in the grid)
    -- function result:start()
    function result.start(self)
      self.triggerKey:enter()
    end

    -- Dismiss the grid, optionally selecting a key
    -- If a key is selected, tell the webview which one, so it can animate the selection.
    function result.stop(self, selectedKeyId)
      -- function result:stop(selectedKeyId)
      if selectedKeyId then
        print("Stopping GridCraft with selected key: " .. selectedKeyId)
        self.activeWebView:evaluateJavaScript(
          string.format([[toggleSelected("%s")]], selectedKeyId)
        )
      else
        print("Stopping GridCraft without selecting a key")
      end
      self.triggerKey:exit()
    end

    -- Indicate a selected key by its ID
    -- Tell the web view to animate the selection of the key.
    -- function result:indicateSelectedKey(selectedKeyId)
    function result.indicateSelectedKey(self, selectedKeyId)
      if not selectedKeyId then
        print(result.title .. ": No selected key ID provided to indicateSelectedKey")
        return
      end
      print(result.title .. ": Indicating selected key: " .. selectedKeyId)
      self.activeWebView:evaluateJavaScript(
        string.format([[toggleSelected("%s")]], selectedKeyId)
      )
    end

    -- Process all the actions in the action table
    for _, keyRow in ipairs(actionTable) do
      for _, action in ipairs(keyRow) do
        if action ~= nil and action.key ~= nil then
          -- Bind the subkey to the action
          result.triggerKey:bind(action.mods, action.key, function()
            result:indicateSelectedKey(action.keyId)
            action.handler()
            result.triggerKey:exit()
          end)
          -- Set the action handler for the submenu.
          -- (We must do this here because we need modality in scope)
          if action.submenu then
            action.handler = function()
              hs.timer.doAfter(thisGrid.config:animationSeconds(), function()
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
              end)
            end
          end
        end
      end
    end

    return self
  end

  result:applyConfiguration()


  --- GridCraft.Grid:setConfig(config)
  --- Method
  --- Set the configuration for the grid.
  ---
  --- Parameters:
  ---  * config - A GridCraft.Configuration object containing the configuration for the grid
  ---
  --- Returns:
  --- * The grid object itself, for chaining
  ---
  --- Notes:
  --- * Mutates the existing grid object, so that all references in closures will get the new values.
  --- * Sets the configuration on all submenus as well.
  --- * Use this method instead of changing the .config field directly.
  function result:setConfiguration(newConfig)
    -- Set the new configuration on the grid itself
    self.config:replace(newConfig)
    self:applyConfiguration()

    -- -- Set the new configuration on all submenus
    -- for _, keyRow in ipairs(actionTable) do
    --   for _, action in ipairs(keyRow) do
    --     if action.submenu then
    --       action.submenu:setConfiguration(result.config)
    --       action.submenu:applyConfiguration()
    --     end
    --   end
    -- end

    return self
  end

  return result
end


return M
