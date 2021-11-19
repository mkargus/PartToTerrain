local ChangeHistoryService = game:GetService('ChangeHistoryService')
local MarketplaceService = game:GetService('MarketplaceService')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local Localization = require(Util.Localization)
local Store = require(Util.Store)
local TerrainUtil = require(Util.TerrainUtil)

local PluginGuiWrapper = require(Plugin.Context.PluginGuiWrapper)

local Components = Plugin.Components
local App = require(Components.App)
local StudioWidget = require(Components.StudioWidget)
local Outline = require(Components.Outline)

local PluginApp = Roact.PureComponent:extend('PluginApp')

function PluginApp:init()
  self.state = {
    guiEnabled = false,
    pluginGui = nil,
    isOutdated = nil
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
    self:setState({ guiEnabled = false })
  end)

  self.toolbar = self.plugin:CreateToolbar('mkargus')

  self.button = self.toolbar:CreateButton(
    Localization(Constants.IS_DEV_CHANNEL and 'Plugin.NameDev' or 'Plugin.Name'),
    Localization('Plugin.Desc'),
    Constants.PLUGIN_BUTTON_ICON
  )
  self.button.Enabled = RunService:IsRunning() ~= true

  self.button.Click:Connect(function()
    self:setState({ guiEnabled = not self.state.guiEnabled })

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

  self.raycastParams = RaycastParams.new()
  self.raycastParams.IgnoreWater = true

  self.pluginMouse.Button1Down:Connect(function()
    local camera = workspace.CurrentCamera.CFrame
    local ray = self.pluginMouse.UnitRay
    local RaycastResults = workspace:Raycast(camera.Position, ray.Direction * 15000, self.raycastParams)

    local function isPressingAlt()
      return UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)
    end

    if RaycastResults then
      local obj = RaycastResults.Instance

      if isPressingAlt() then
        if obj:IsA('Terrain') then
          return Store:Set('Material', RaycastResults.Material)
        end

      elseif not obj:IsA('Terrain') and TerrainUtil.isConvertibleToTerrain(RaycastResults.Instance) then

        if self.plugin:GetSetting('IgnoreLockedParts') and obj.Locked then
          return
        end

        local shape, cframe, size = TerrainUtil.GetPartInfo(obj)
        local material = Store:Get('Material')
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
  if self.plugin:GetSetting('CheckUpdates') and not RunService:IsRunning() then
    local CheckerID = Constants.IS_DEV_CHANNEL and Constants.DEV_UPDATE_CHECKER_ID or Constants.UPDATE_CHECKER_ID
    local success, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, CheckerID)

    if success then
      local LastestVersion = info.Description:match('([0-9]+%.[0-9]+%.[0-9]+)')

      if LastestVersion and LastestVersion ~= Constants.VERSION then
        return true
      end

    end
  end

  -- Fallback
  return false
end

function PluginApp:didUpdate()
  self.button:SetActive(self.state.guiEnabled)
end

function PluginApp:render()
  local state = self.state

  local isPluginGuiLoaded = state.pluginGui ~= nil

  return not RunService:IsRunning() and Roact.createElement(StudioWidget, {
    plugin = self.plugin,
    Id = 'PartToTerrain',
    Title = Localization('Plugin.NameVersion', { Constants.VERSION }),

    Active = state.guiEnabled,

    OverridePreviousState = true,
    FloatingSize = Vector2.new(250, 330),
    MinimumSize = Vector2.new(250, 300),

    onClose = function()
      self.plugin:Deactivate()
    end,
    [Roact.Ref] = function(ref)
      self:setState({ pluginGui = ref })
    end
  }, {
    ShowOnTop = isPluginGuiLoaded and Roact.createElement(PluginGuiWrapper.Provider, {
      pluginGui = state.pluginGui
    }),

    App = Roact.createElement(App, {
      IsOutdated = state.isOutdated
    }),

    Outline = (state.guiEnabled and self.plugin:GetSetting('EnabledSelectionBox')) and Roact.createElement(Outline, {
      PluginMouse = self.pluginMouse,
      raycastParams = self.raycastParams
    })
  })
end

function PluginApp:didMount()
  -- Creates a seprate thread for update checking as to not block rendering thread.
  -- This is incase Roblox servers go extremely slow or if a user has a bad connection.
  task.spawn(function()
    self:setState({ isOutdated = self:isUpdateAvailable() })
  end)
end

return PluginApp
