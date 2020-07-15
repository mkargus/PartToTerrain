-- Made By Fastcar48
if not plugin then
  error('Part to Terrain has to be ran as a plugin.')
end

-- Services
local ChangeHistory = game:GetService('ChangeHistoryService')
local Marketplace = game:GetService('MarketplaceService')
local Run = game:GetService('RunService')

local mouse = plugin:GetMouse()

local sp = script.Parent
local Roact = require(sp.Libs.Roact)
local Rodux = require(sp.Libs.Rodux)
local RoactRodux = require(sp.Libs.RoactRodux)
local Reducer = require(sp.Reducer)
local App = require(sp.Components.App)
local Constants = require(sp.Util.Constants)
local Localization = require(sp.Util.Localization)
local outlineManager = require(sp.Util.outlineManager)
local terrainConverter = require(sp.Util.TerrainConverter)

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
    outlineManager:Hide()
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
local store = Rodux.Store.new(Reducer, {
  Frame = "Materials",
  Material = Enum.Material.Grass,
})

local app = Roact.createElement(RoactRodux.StoreProvider, {
  store = store
}, {
  App = Roact.createElement(App, {
    plugin = plugin,
    store = store,
    IsOutdated = CheckForUpdates()
  })
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
  outlineManager:Destroy()
end)

plugin.Deactivation:Connect(function()
  if isEnabled and ui.Enabled then
    activate(false)
  end
end)

if Run:IsEdit() then
  button.Click:connect(function()
    activate(not isEnabled)
  end)
else
  button.Enabled = false
  Roact.unmount(tree)
end

ChangeHistory.OnUndo:connect(function(waypoint)
  if waypoint == 'PartToTerrain' then
    game.Selection:Set({})
  end
end)

mouse.Button1Down:connect(function()
  local part = mouse.Target
  local Material = store:getState().Material
  if isEnabled and part then
    local success, err = pcall(function()
      terrainConverter:Convert(part, Material, plugin:GetSetting('IgnoreLockedParts'))
    end)
    if success then
      if plugin:GetSetting('DeletePart') then
        part:remove()
      end
      ChangeHistory:SetWaypoint('PartToTerrain')
    else
      -- Temp solution
      warn(Localization(err))
    end
  end
end)

mouse.Move:connect(function()
  local part = mouse.Target
  if isEnabled and part and plugin:GetSetting('EnabledSelectionBox') then
    if plugin:GetSetting('IgnoreLockedParts') then
      if part.Locked then
        outlineManager:Hide()
      else
        outlineManager:Set(part)
      end
    else
      outlineManager:Set(part)
    end
  else
    outlineManager:Hide()
  end
end)
