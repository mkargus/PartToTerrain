local MarketplaceService = game:GetService('MarketplaceService')
local RunService = game:GetService('RunService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local Localization = require(Util.Localization)
local OutlineManager = require(Util.OutlineManager)
local TerrainConverter = require(Util.TerrainConverter)
local Store = require(Util.Store)

local App = require(Plugin.Components.App)
local PluginSettings = require(Plugin.Components.PluginSettings)
local StudioWidget = require(Plugin.Components.StudioWidget)
-- local Outline = require(Plugin.Components.Outline)

local PluginApp = Roact.PureComponent:extend('PluginApp')

function PluginApp:init()
  self.state = {
    guiEnabled = false
  }

  self.plugin = self.props.plugin

  self.plugin.Deactivation:Connect(function()
    self:setState({
      guiEnabled = false
    })
    self.button:SetActive(false)

    self.OutlineObj:Set(nil)
  end)

  self.pluginMouse = self.plugin:GetMouse()

  self.toolbar = self.plugin:CreateToolbar('mkargus')

  self.button = self.toolbar:CreateButton(
    Localization(Constants.IS_DEV_CHANNEL and 'Plugin.NameDev' or 'Plugin.Name'),
    Localization('Plugin.Desc'),
    Constants.PLUGIN_BUTTON_ICON
  )
  self.button.Enabled = RunService:IsRunning() ~= true

  self.button.Click:Connect(function()
    self:setState({
      guiEnabled = not self.state.guiEnabled
    })

    self.button:SetActive(self.state.guiEnabled)

    if self.state.guiEnabled then
      self.plugin:Activate(true)
    else
      self.plugin:Deactivate()
    end
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
  local state = self.state

  return RunService:IsRunning() ~= true and Roact.createElement(StudioWidget, {
    plugin = self.plugin,
    Id = 'PartToTerrain',
    Title = Localization('Plugin.NameVersion', { Constants.VERSION }),

    Active = state.guiEnabled,

    OverridePreviousState = true,
    FloatingSize = Vector2.new(250, 330),
    MinimumSize = Vector2.new(250, 300),

    onClose = function()
      self.plugin:Deactivate()
    end
  }, {
    Roact.createElement(PluginSettings.StudioProvider, {
      plugin = self.plugin
    }, {
      App = Roact.createElement(App, {
        IsOutdated = self:isUpdateAvailable()
      })
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
        TerrainConverter.DEPRECATED_Convert(part, material, self.plugin:GetSetting('DeletePart'), self.plugin:GetSetting('IgnoreLockedParts'))
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
