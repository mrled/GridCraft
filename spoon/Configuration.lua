--- === GridCraft.Configuration ===
---
--- Configuration parameters for a GridCraft grid.

local M = {}


--- GridCraft.Configuration.new() -> table
--- Constructor
--- Create a new configuration object for a GridCraft grid.
---
--- Returns:
--- * A GridCraft.Configuration object
M.new = function()
    local config = {}

    -- Only valid keys are copied with update()
    local validKeys = {
        "animationMs",
        "gridMaxWidth",
        "gridMaxHeight",
    }

    --- GridCraft.Configuration.animationMs
    --- Field
    --- Time for key-seledction animation in ms, default is 150ms.
    config.animationMs = 150

    --- GridCraft.Configuration:animationSeconds() -> number
    --- Method
    --- Time for key-selection animation in seconds (derived from animationMs)
    function config:animationSeconds()
        return self.animationMs / 1000
    end

    --- GridCraft.Configuration.gridMaxWidth
    --- Field
    --- The max width for the grid in px, default is 1024
    config.gridMaxWidth = 1024

    --- GridCraft.Configuration.gridMaxHeight
    --- Field
    --- The max height for the grid in px, default is 768
    config.gridMaxHeight = 768

    --- GridCraft.Configuration:toJSON() -> string
    --- Method
    --- Return the configuration as a JSON string.
    function config:toJSON()
        return hs.json.encode({
            animationMs = self.animationMs,
            animationSeconds = self:animationSeconds(),
            gridMaxWidth = self.gridMaxWidth,
            gridMaxHeight = self.gridMaxHeight,
        })
    end

    --- GridCraft.Configuration:replace() -> GridCraft.Configuration
    --- Method
    --- Replace ALL values of the configuration with values from the upddate object
    ---
    --- Parameters:
    ---  * updateConfig - A table containing new configuration values.
    ---
    --- Returns:
    --- * The configuration object itself, for chaining.
    ---
    --- Notes:
    --- * If a key is missing in the updateConfig, the value in the existing configuration will be set to nil.
    function config:replace(updateConfig)
        for _, key in ipairs(validKeys) do
            config[key] = updateConfig[key]
        end
        return self
    end

    --- GridCraft.Configuration.displayScreen
    --- Field
    --- The screen on which the grid should be displayed.
    --- Allowed values:
    ---
    ---   * A string screen name; obtain this from `hs.screen.allScreens()`
    ---   * The string `primary` to use what macOS considers the primary screen
    ---   * The string `main` to use the screen with the currently focused window
    ---   * The string `mouse` to use the screen containing the mouse cursor
    --- If this value is nil or the configured screen is not found, the primary screen will be used.
    config.displayScreen = nil

    return config
end

return M
