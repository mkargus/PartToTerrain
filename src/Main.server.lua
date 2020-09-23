-- Made By Fastcar48
if not plugin then
  error('Part to Terrain has to be ran as a plugin.')
end

-- Services
local Marketplace = game:GetService('MarketplaceService')
local Run = game:GetService('RunService')

local mouse = plugin:GetMouse()

local sp = script.Parent
local Roact = require(sp.Libs.Roact)
local Store = require(sp.Components.Store)
local App = require(sp.Components.App)
local Constants = require(sp.Util.Constants)
local Localization = require(sp.Util.Localization)
local OutlineManager = require(sp.Util.OutlineManager)
local TerrainConverter = require(sp.Util.TerrainConverter)

local outline = OutlineManager.new()

-- Settings
for _, settings in pairs(Constants.SETTINGS) do
  if plugin:GetSetting(settings.id) == nil then
    plugin:SetSetting(settings.id, settings.defaultValue)
  end
end

local isEnabled = false

local button = plugin:CreateToolbar('Fasty48'):CreateButton(
  Constants.IS_DEV_CHANNEL and Localization('Plugin.NameDev') or Localization('Plugin.Name'),
  Localization('Plugin.Desc'),
  Constants.PLUGIN_BUTTON_ICON
)

local ui = plugin:CreateDockWidgetPluginGui('PartToTerrain', Constants.DOCK_WIDGET_INFO)
ui.Title = Localization('Plugin.NameVersion', { Constants.VERSION })
ui.Name = 'PartToTerrain'

------------------------
-- Functions
------------------------
local function activate(bool)
  isEnabled = bool
  button:SetActive(bool)
  ui.Enabled = bool
  if bool then
    plugin:Activate(true)
  else
    plugin:Deactivate()
    outline:Set(nil)
  end
end

local function CheckForUpdates()
  if Run:IsEdit() and plugin:GetSetting('CheckUpdates') then
    local checkerId = Constants.IS_DEV_CHANNEL and Constants.DEV_UPDATE_CHECKER_ID or Constants.UPDATE_CHECKER_ID
    local success, info = pcall(Marketplace.GetProductInfo, Marketplace, checkerId)
    if success and info.Description ~= Constants.VERSION then
      return info.Description
    else
      return false
    end
  end
end

------------------------
-- UI
------------------------
local app = Roact.createElement(App, {
  plugin = plugin,
  IsOutdated = CheckForUpdates()
})

local tree = Roact.mount(app, ui, 'PartToTerrain')

------------------------
-- Events
------------------------
ui:BindToClose(function()
  activate(false)
end)

plugin.Unloading:Connect(function()
  activate(false)
  Roact.unmount(tree)
  outline:Despawn()
end)

plugin.Deactivation:Connect(function()
  if isEnabled and ui.Enabled then
    activate(false)
  end
end)

if Run:IsEdit() then
  button.Click:Connect(function()
    activate(not isEnabled)
  end)
else
  button.Enabled = false
  Roact.unmount(tree)
end

mouse.Button1Down:Connect(function()
  local part = mouse.Target
  local material = Store:Get('Material')

  if isEnabled and part and not part:IsA('Terrain') then
    local success, err = pcall(function()
      TerrainConverter(part, material, plugin:GetSetting('DeletePart'), plugin:GetSetting('IgnoreLockedParts'))
    end)

    if not success then
      warn(Localization(err))
    end
  end

end)

mouse.Move:Connect(function()
  local part = mouse.Target

  if isEnabled and plugin:GetSetting('EnabledSelectionBox') and part and not part:IsA('Terrain') then
    if plugin:GetSetting('IgnoreLockedParts') and part.Locked then
      return outline:Set(nil)
    end
    outline:Set(part)
  end

end)
