local MarketplaceService = game:GetService('MarketplaceService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local Localization = require(Util.Localization)
local OutlineManager = require(Util.OutlineManager)
local TerrainConverter = require(Util.TerrainConverter)

local App = require(Plugin.Components.App)
local Store = require(Plugin.Components.Store)

local PluginApp = Roact.PureComponent:extend('PluginApp')

function PluginApp:init()
  self.plugin = self.props.plugin
  self.plugin.Deactivation:Connect(function()
    self.OutlineObj:Set(nil)
  end)

  self.pluginMouse = self.plugin:GetMouse()

  self.toolbar = self.plugin:CreateToolbar('mkargus')

  self.button = self.toolbar:CreateButton(
    Localization(Constants.IS_DEV_CHANNEL and 'Plugin.NameDev' or 'Plugin.Name'),
    Localization('Plugin.Desc'),
    Constants.PLUGIN_BUTTON_ICON
  )
  -- self.button.Enabled = false
  self.button.Click:Connect(function()
    self.widgetGui.Enabled = not self.widgetGui.Enabled
    self.plugin:Activate(true)
  end)

  self.widgetGui = self.plugin:CreateDockWidgetPluginGui('PartToTerrain', Constants.DOCK_WIDGET_INFO)
  self.widgetGui.Title = Localization('Plugin.NameVersion', { Constants.VERSION })
  self.widgetGui.Name = 'PartToTerrain'
  self.widgetGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  self.widgetGui:GetPropertyChangedSignal('Enabled'):Connect(function()
    self.button:SetActive(self.widgetGui.Enabled)
  end)

end

function PluginApp:isUpdateAvailable()
  if self.plugin:GetSetting('CheckUpdates') then
    local CheckerID = Constants.IS_DEV_CHANNEL and Constants.DEV_UPDATE_CHECKER_ID or Constants.UPDATE_CHECKER_ID
    local success, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, CheckerID)

    if success and info.Description ~= Constants.VERSION then
      return true
    else
      return false
    end

  end
end

function PluginApp:render()
  return Roact.createElement(Roact.Portal, {
    target = self.widgetGui
  }, {
    App = Roact.createElement(App, {
      plugin = self.plugin,
      IsOutdated = self:isUpdateAvailable()
    })
  })
end

function PluginApp:didMount()
  self.OutlineObj = OutlineManager.new()

  self.pluginMouse.Move:Connect(function()
    local part = self.pluginMouse.Target
    if part and not part:IsA('Terrain') then
      self.OutlineObj:Set(part)
    else
      self.OutlineObj:Set(nil)
    end
  end)

  self.pluginMouse.Button1Down:Connect(function()
    local part = self.pluginMouse.Target
    local material = Store:Get('Material')

    if part and not part:IsA('Terrain') then
      local success, err = pcall(function()
        TerrainConverter(part, material, self.plugin:GetSetting('DeletePart'), self.plugin:GetSetting('IgnoreLockedParts'))
      end)

      if not success then
        warn(Localization(err))
      end
    end
  end)
end

function PluginApp:willUnmount()
  self.OutlineObj:Despawn()
end

return PluginApp
