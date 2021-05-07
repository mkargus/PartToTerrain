local ChangeHistoryService = game:GetService('ChangeHistoryService')
local MarketplaceService = game:GetService('MarketplaceService')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local Localization = require(Util.Localization)
local Store = require(Util.Store)
local TerrainUtil = require(Util.TerrainUtil)

local Components = Plugin.Components
local App = require(Components.App)
local PluginSettings = require(Components.PluginSettings)
local StudioWidget = require(Components.StudioWidget)
local Outline = require(Components.Outline)

local PluginApp = Roact.PureComponent:extend('PluginApp')

function PluginApp:init()
  self.state = {
    guiEnabled = false
  }

  -- This is a fix for a unintended side effect when undoing,
  -- where it will select the part and give it a outline.
  ChangeHistoryService.OnUndo:Connect(function(waypoint)
    if waypoint == 'PartToTerrain' then
      game:GetService('Selection'):Set({})
    end
  end)

  self.plugin = self.props.plugin

  self.plugin.Deactivation:Connect(function()
    self:setState({
      guiEnabled = false
    })
    self.button:SetActive(false)
  end)

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

  ----------------------------------------
  -- Plugin Mouse
  ----------------------------------------
  self.pluginMouse = self.plugin:GetMouse()

  local raycastParams = RaycastParams.new()
  raycastParams.IgnoreWater = true

  self.pluginMouse.Button1Down:Connect(function()
    local camera = workspace.CurrentCamera.CFrame
    local ray = self.pluginMouse.UnitRay
    local RaycastResults = workspace:Raycast(camera.Position, ray.Direction * 1000, raycastParams)

    local function isPressingAlt()
      return UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
    end

    if RaycastResults then
      local obj = RaycastResults.Instance

      if isPressingAlt() and obj:IsA('Terrain') then
        return Store:Set('Material', RaycastResults.Material)

      elseif not obj:IsA('Terrain') and TerrainUtil.isConvertibleToTerrain(RaycastResults.Instance) then

        if self.plugin:GetSetting('IgnoreLockedParts') and obj.Locked then
          return
        end

        local shape = TerrainUtil.getPartShape(obj)
        local material = Store:Get('Material')
        local cframe = obj.CFrame
        local size = obj.Size
        local preserceTerrain = self.plugin:GetSetting('PreserveTerrain')

        local success = TerrainUtil.convertToTerrain(shape, material, cframe, size, preserceTerrain)
        if success then
          if self.plugin:GetSetting('DeletePart')  then
            obj.Parent = nil
          end
          ChangeHistoryService:SetWaypoint('PartToTerrain')

        end
      end
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
      }),

      Outline = self.plugin:GetSetting('EnabledSelectionBox') and Roact.createElement(Outline, {
        plugin = self.plugin
      })

    })
  })
end

return PluginApp
