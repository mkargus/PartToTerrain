local ChangeHistoryService = game:GetService('ChangeHistoryService')
local MarketplaceService = game:GetService('MarketplaceService')
local RunService = game:GetService('RunService')
local Selection = game:GetService('Selection')
local UserInputService = game:GetService('UserInputService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local Localization = require(Util.Localization)
local Settings = require(Util.Settings)
local Store = require(Util.Store)
local TerrainUtil = require(Util.TerrainUtil)

local Components = Plugin.Components
local App = require(Components.App)
local Outline = require(Components.Outline)
local StudioWidget = require(Components.StudioWidget)
local Tooltip = require(Components.Tooltip)

local function GetInvisibleParts()
  local ignoreList = {}

  for _, descendant in ipairs(workspace:GetDescendants()) do
    if descendant:IsA('BasePart') and descendant.Transparency == 1 then
      table.insert(ignoreList, descendant)
    end
  end

  return ignoreList
end

local function IsUpdateAvailable()
  if not RunService:IsRunning() then
    local CheckerID = Constants.IS_DEV_CHANNEL and Constants.DEV_UPDATE_CHECKER_ID or Constants.UPDATE_CHECKER_ID
    local success, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, CheckerID)

    if success then
      local LatestVersion = string.match(info.Description, '([0-9]+%.[0-9]+%.[0-9]+)')

      if LatestVersion and LatestVersion ~= Constants.VERSION then
        return true
      end

    end
  end

  -- Fallback
  return false
end

local PluginApp = Roact.PureComponent:extend('PluginApp')

function PluginApp:init()
  self.state = {
    guiEnabled = false,
    isOutdated = nil
  }

  -- This is a fix for a unintended side effect when undoing,
  -- where it will select the part and give it a outline.
  ChangeHistoryService.OnUndo:Connect(function(waypoint)
    if waypoint == 'PartToTerrain' then
      Selection:Set({})
    end
  end)

  self.plugin = self.props.plugin :: Plugin

  self.plugin.Deactivation:Connect(function()
    self:setState({ guiEnabled = false })
  end)

  -- TODO: Make PluginToolbar & PluginToolbarButton into a Roact component
  self.toolbar = self.plugin:CreateToolbar('mkargus')

  self.button = self.toolbar:CreateButton(
    Localization(Constants.IS_DEV_CHANNEL and 'Plugin.NameDev' or 'Plugin.Name'),
    Localization('Plugin.Desc'),
    Constants.PLUGIN_BUTTON_ICON
  )
  self.button.Enabled = RunService:IsRunning() ~= true

  self.button.Click:Connect(function()
    if not self.state.guiEnabled then
      self.plugin:Activate(true)
      self:setState({ guiEnabled = true })
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
  self.raycastParams.FilterType = Enum.RaycastFilterType.Exclude

  self.PluginMouseClickConnection = self.pluginMouse.Button1Down:Connect(function()
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
          Store:Set('Material', RaycastResults.Material)
          return
        end

      elseif not obj:IsA('Terrain') and TerrainUtil:IsConvertibleToTerrain(RaycastResults.Instance) then

        if Settings:Get('IgnoreLockedParts') and obj.Locked then
          return
        end

        local shape, cframe, size = TerrainUtil:GetPartInfo(obj)
        local material = Store:Get('Material')
        local preserceTerrain = Settings:Get('PreserveTerrain')

        local success = TerrainUtil:ConvertToTerrain(shape, material, cframe, size, preserceTerrain)
        if success then
          if Settings:Get('DeletePart') then
            obj.Parent = nil
          end
          ChangeHistoryService:SetWaypoint('PartToTerrain')

        end
      end
    end
  end)

end

function PluginApp:didUpdate()
  self.button:SetActive(self.state.guiEnabled)

  if self.state.guiEnabled then
    task.spawn(function()
      self.raycastParams.FilterDescendantsInstances = Settings:Get('IgnoreInvisibleParts') and GetInvisibleParts() or {}
    end)
  end

end

function PluginApp:render()
  local state = self.state

  if RunService:IsRunning() then
    return nil
  end

  return Roact.createElement(StudioWidget, {
    plugin = self.plugin,
    Id = 'PartToTerrain',
    Title = Localization('Plugin.NameVersion', { Constants.VERSION }),

    Enabled = state.guiEnabled,

    OverridePreviousState = true,
    FloatingSize = Vector2.new(250, 330),
    MinimumSize = Vector2.new(250, 300),

    onClose = function()
      self.plugin:Deactivate()
    end
  }, {
    TooltipContainer = Roact.createElement(Tooltip.Container),

    App = state.guiEnabled and Roact.createElement(App, {
      IsOutdated = state.isOutdated
    }),

    Outline = state.guiEnabled and Roact.createElement(Outline, {
      PluginMouse = self.pluginMouse,
      RaycastParams = self.raycastParams
    })
  })
end

function PluginApp:didMount()
  -- Creates a seprate thread for update checking as to not block rendering thread.
  -- This is incase Roblox servers go extremely slow or if a user has a bad connection.
  task.spawn(function()
    if IsUpdateAvailable() then
      self:setState({ isOutdated = true })
    end
  end)
end

function PluginApp:willUnmount()
  self.toolbar:Destroy()
  self.button:Destroy()

  self.PluginMouseClickConnection:Disconnect()
end

return PluginApp
