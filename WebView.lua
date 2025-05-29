--[[
   A centered web view for displaying HTML content.
]]

local Util = dofile(hs.spoons.resourcePath("Util.lua"))

local M = {}

--[[
  CSS for the view
]]
M.css = Util.fileContents(hs.spoons.resourcePath("WebView.css"))

--[[
  JavaScript for the view
]]
M.js = Util.fileContents(hs.spoons.resourcePath("WebView.js"))

local centeredWebView = function(content, width, height)
  -- Initial dimenmsions/position don't matter
  local wvRect = hs.geometry.rect(10, 10, 10, 10)
  local wv     = hs.webview.new(wvRect)
  wv:windowStyle({ "borderless", "nonactivating" })
  wv:transparent(true)
  wv:bringToFront(true)
  wv:closeOnEscape(true)
  wv:html(content)
  -- Resize and center the web view
  M.resizeCenter(wv, width, height)
  return wv
end

--[[
  Generate an HTML table from a list of items
]]
local itemTableHtml = function(actionTable)
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
          <td id="%s" class="key">
            <a href="%s">
              %s
              <br/>
              <span class="hotkey">%s</span>
              <span class="description">%s</span>
            </a>
          </td>
          ]],
        action.keyId,
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


--[[
  HTML for the entire web view
]]
local webViewHtml = function(title, itemTable)
  local webViewMenuMessageTemplate = [[
    <html>
      <head>
        <title>%s</title>
        <style>%s</style>
        <script>%s</script>
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
    itemTable
  )

  -- local tmpHtml = assert(io.open("/tmp/webview.html", "w"))
  -- tmpHtml:write(result)
  -- tmpHtml:close()

  return result
end


--[[
   Create a new web view intended for modal messages.

   Works like hs.alert, but with complete control over the layout in HTML.
]]
M.webView = function(title, items, width, height)
  local itemTable = itemTableHtml(items)
  local html = webViewHtml(title, itemTable)
  local wv = centeredWebView(html, width or 1024, height or 768)
  return wv
end


--[[
  Resize and center a web view
]]
M.resizeCenter = function(wv, width, height)
  if wv == nil then
    return
  end

  -- Force the screen to refresh, to ensure that reloading the config
  -- will pick up any changes to screen layout since the first load.
  hs.screen.allScreens()

  -- The screen with the currently focused window
  local mainScreen  = hs.screen.mainScreen()

  -- A rect containing coordinates of the entire frame, including dock and menu
  local mainFrame   = mainScreen:fullFrame()

  -- Coordinates to center the web view in the main frame
  local wvLeftCoord = mainFrame.x + (mainFrame.w - width) / 2
  local wvTopCoord  = mainFrame.y + (mainFrame.h - height) / 2

  wv:frame(hs.geometry.rect(wvLeftCoord, wvTopCoord, width, height))
end


return M
