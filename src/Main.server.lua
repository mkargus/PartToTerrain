--[[

Part to Terrain
Developed by mkargus ⬡

Free: https://www.roblox.com/library/261634767/Part-to-Terrain
Dev (Paid): https://www.roblox.com/library/4685764627/Part-to-Terrain-DEV

Open sourced on Github:
https://github.com/mkargus/PartToTerrain

Part to Terrain's code is available under the
GNU General Public License v3.0 license:
https://github.com/mkargus/PartToTerrain/blob/main/LICENSE.txt

]]

if not plugin then
  error('Part to Terrain has to be ran as a plugin.')
end

local Plugin = script.Parent
local Roact = require(Plugin.Packages.Roact)

local StudioTheme = require(Plugin.Context.StudioTheme)
local PluginApp = require(Plugin.Components.PluginApp)
local Tooltip = require(Plugin.Components.Tooltip)

local app = Roact.createElement(StudioTheme.Provider, nil, {
  Roact.createElement(Tooltip.Provider, nil, {
    Roact.createElement(PluginApp, {
      plugin = plugin
    })
  })
})

local tree = Roact.mount(app, nil, 'PartToTerrain')

plugin.Unloading:Connect(function()
  Roact.unmount(tree)
end)
