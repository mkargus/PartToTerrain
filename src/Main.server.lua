-- Made By Fastcar48
if not plugin then
  error('Part to Terrain has to be ran as a plugin.')
end

-- Services
local mouse = plugin:GetMouse()
local ChangeHistoryService = game:GetService('ChangeHistoryService')
local MarketplaceService = game:GetService('MarketplaceService')
local RunService = game:GetService('RunService')
local Modules = script.Parent
local Constants = require(Modules.Constants)
local Roact = require(Modules.Roact)
local Rodux = require(Modules.Rodux)
local RoactRodux = require(Modules.RoactRodux)
local Reducer = require(Modules.Reducer)
local App = require(Modules.Components.App)
local Localization = require(Modules.Components.Localization)
local outlineManager = require(Modules.outlineManager)
local terrainConverter = require(Modules.terrainConverter)

-- Settings
for _, settings in pairs(Constants.Settings) do
  if plugin:GetSetting(settings.id) == nil then
    plugin:SetSetting(settings.id, settings.defaultValue)
  end
end

local isEnabled = false

local button = plugin:CreateToolbar('Fasty48'):CreateButton(
  Localization('Plugin.Name'),
  Localization('Plugin.Desc'),
  'rbxassetid://297321964'
)

local ui = plugin:CreateDockWidgetPluginGui('PartToTerrain', DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, true, 300, 300, 220, 200))
ui.Title = Localization('Plugin.NameVersion', { Constants.Version })
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
  if RunService:IsEdit() and plugin:GetSetting('CheckUpdates') then
    local success, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, Constants.UpdateChecker)
    if success and info.Description ~= Constants.Version then
      return true
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
  Material = Enum.Material.Air,
})

local app = Roact.createElement(RoactRodux.StoreProvider, {
  store = store
}, {
  App = Roact.createElement(App, {
    plugin = plugin,
    store = store,
    Constants = Constants,
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

plugin.Unloading:connect(function()
  activate(false)
  Roact.unmount(tree)
  outlineManager:Destroy()
end)

plugin.Deactivation:connect(function()
  if isEnabled and ui.Enabled then
    activate(false)
  end
end)

if RunService:IsEdit() then
  button.Click:connect(function()
    activate(not isEnabled)
  end)
else
  button.Enabled = false
  Roact.unmount(tree)
end

ChangeHistoryService.OnUndo:connect(function(waypoint)
  if waypoint == 'PartToTerrain' then
    game.Selection:Set({})
  end
end)

mouse.Button1Down:connect(function()
  local part = mouse.Target
  local Material = store:getState().Material
  if isEnabled and part then
    local success, err = pcall(function() terrainConverter:Convert(part, Material, plugin:GetSetting('IgnoreLockedParts')) end)
    if success then
      if plugin:GetSetting('DeletePart') then
        part:remove()
      end
      ChangeHistoryService:SetWaypoint('PartToTerrain')
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
