--- === GridCraft.WebView ===
---
--- The web view that displays the grid.
--- Users won't interact with this module directly, but it is used by the GridCraft module.
--- We consider this an internal module and provide no stability guarantees between minor versions.

local Util = dofile(hs.spoons.resourcePath("Util.lua"))

local M = {}


--- GridCraft.WebView.css
--- Constant
--- The CSS for the web view
M.css = Util.fileContents(hs.spoons.resourcePath("WebView.css"))


--- GridCraft.WebView.js
--- Constant
--- The JavaScript for the web view
M.js = Util.fileContents(hs.spoons.resourcePath("WebView.js"))


local centeredWebView = function(content, config)
  -- Initial dimenmsions/position don't matter
  local wvRect = hs.geometry.rect(10, 10, 10, 10)
  local wv     = hs.webview.new(wvRect)
  wv:windowStyle({ "borderless", "nonactivating" })
  wv:transparent(true)
  wv:bringToFront(true)
  wv:closeOnEscape(true)
  wv:html(content)
  -- Resize and center the web view
  M.resizeCenter(wv, config)
  return wv
end


--- GridCraft.WebView.itemTableHtml(table) -> string
--- Function
--- Generates an HTML table from a list of items.
---
--- Parameters:
---  * actionTable - A table of rows, each of which is a table of actions.
---
--- Returns:
---  * string containing the HTML for the item table
M.itemTableHtml = function(actionTable)
  local tableHtml = ""

  for _, keyRow in pairs(actionTable) do
    local rowHtml = "<tr>"
    for _, action in pairs(keyRow) do
      local hotkeyLabel = ""
      if action.key ~= nil then
        hotkeyLabel = string.upper(action.key)
      end
      rowHtml = rowHtml .. string.format(
        [[
          <td id="%s" class="key %s">
            <a href="%s">
              %s
              <br/>
              <span class="hotkey">%s</span>
              <span class="description">%s</span>
            </a>
          </td>
          ]],
        action.keyId,
        table.concat(action.classes, " "),
        action.url or "",  -- href value
        action.icon,
        hotkeyLabel,       -- hotkey
        action.description -- visible description
      )
    end
    tableHtml = tableHtml .. rowHtml .. "</tr>"
  end
  return tableHtml
end

--- GridCraft.WebView.webViewHtml(string, string) -> string
--- Function
--- Generates the complete HTML for a web view, including the title, CSS, JS, and item table.
---
--- Parameters:
---  * title - The title of the web view
---  * itemTable - The HTML table generated from the actionTable
---  * config - A GridCraft.Configuration object containing the configuration for the grid
---
--- Returns:
---  * string containing the complete HTML for the web view
M.webViewHtml = function(title, itemTable, config)
  local webViewMenuMessageTemplate = [[
    <html>
      <head>
        <title>%s</title>
        <style>%s</style>
        <script id="js-code">%s</script>
        <script type="application/json" id="gridcraft-config">%s</script>
      </head>
      <body>
        <table>
        %s
        </table>
      </body>
    </html>
   ]]

  local result = string.format(
    webViewMenuMessageTemplate,
    title,
    M.css,
    M.js,
    config:toJSON(),
    itemTable
  )

  -- local tmpHtml = assert(io.open("/tmp/webview.html", "w"))
  -- tmpHtml:write(result)
  -- tmpHtml:close()

  return result
end


--- GridCraft.WebView.configuredScreen(config) -> hs.screen object
--- Function
--- Returns the screen that is configured for the web view.
---
--- Parameters:
--- * config - (table) A GridCraft.Configuration object containing the configuration for the grid
---
--- Returns:
--- * The configured screen object, or the primary screen if no specific configuration is set or if any screen is not found.
M.configuredScreen = function(config)
  -- Aside from a convenient variable, calling allScreens() will force the screen layout to refresh.
  local allScreens = hs.screen.allScreens()

  -- The primary screen is the fallback option
  local primary = hs.screen.primaryScreen()

  if config.displayScreen == "primary" then
    return primary
  elseif config.displayScreen == "main" then
    return hs.screen.mainScreen() or primary
  elseif config.displayScreen == "mouse" then
    return hs.mouse.getCurrentScreen() or primary
  elseif allScreens[config.displayScreen] then
    return allScreens[config.displayScreen] or primary
  end
  return primary
end


--- GridCraft.WebView.webView(string, table, number, number) -> hs.webview object
--- Constructor
--- Creates a new web view intended for modal messages.
---
--- Parameters:
---  * title - (string) The title of the web view
---  * items - (table) A list of rows, each of which is a table of actions.
---  * config - (table) A GridCraft.Configuration object
---
--- Returns:
---  * A hs.webview object
M.webView = function(title, items, config)
  local itemTable = M.itemTableHtml(items)
  local html = M.webViewHtml(title, itemTable, config)
  local wv = centeredWebView(html, config)
  return wv
end


--- GridCraft.WebView.resizeCenter(hs.webview.object, [number], [number]) -> hs.webview.object
--- Function
--- Resizes and centers a web view on the main screen.
---
--- Parameters:
---  * wv - The web view to resize and center
---  * config - (table) A GridCraft.Configuration object
---
--- Returns:
---  * The resized and centered web view
M.resizeCenter = function(wv, config)
  if wv == nil then
    return
  end
  local screen      = M.configuredScreen(config)

  -- A rect containing coordinates of the entire frame, including dock and menu
  local screenFrame = screen:fullFrame()

  -- Coordinates to center the web view in the main frame
  local wvLeftCoord = screenFrame.x + (screenFrame.w - config.gridMaxWidth) / 2
  local wvTopCoord  = screenFrame.y + (screenFrame.h - config.gridMaxHeight) / 2

  wv:frame(hs.geometry.rect(wvLeftCoord, wvTopCoord, config.gridMaxWidth, config.gridMaxHeight))

  return wv
end


return M
