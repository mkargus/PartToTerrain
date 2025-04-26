local ChangeHistoryService = game:GetService('ChangeHistoryService')
local MarketplaceService = game:GetService('MarketplaceService')
local Selection = game:GetService('Selection')
local UserInputService = game:GetService('UserInputService')

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

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

  for _, descendant in workspace:GetDescendants() do
    if descendant:IsA('BasePart') and descendant.Transparency == 1 then
      table.insert(ignoreList, descendant)
    end
  end

  return ignoreList
end

local function IsUpdateAvailable()
  local CheckerID = Constants.IS_DEV_CHANNEL and Constants.DEV_UPDATE_CHECKER_ID or Constants.UPDATE_CHECKER_ID
  local success, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, CheckerID)

  if success then
    local LatestVersion = string.match(info.Description, '([0-9]+%.[0-9]+%.[0-9]+)')

    if LatestVersion and LatestVersion ~= Constants.VERSION then
      return true
    end
  end

  -- Fallback
  return false
end

local PluginApp = React.PureComponent:extend('PluginApp')

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
    Localization('Plugin.Name') .. if Constants.IS_DEV_CHANNEL then '[DEV]' else '',
    Localization('Plugin.Desc'),
    Constants.PLUGIN_BUTTON_ICON
  )

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
    local cameraPos = workspace.CurrentCamera.CFrame.Position
    local dir = self.pluginMouse.UnitRay.Direction
    local RaycastResults = workspace:Raycast(cameraPos, dir * 15000, self.raycastParams)

    if not RaycastResults then
      return
    end

    local obj = RaycastResults.Instance

    -- Adds in Terrain Editor's shortcut to select material.
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
      if obj:IsA('Terrain') then
        Store:Set('Material', RaycastResults.Material)
      end
      return
    end

    if not TerrainUtil:IsConvertibleToTerrain(obj) then
      return
    end

    if Settings:Get('IgnoreLockedParts') and obj.Locked then
      return
    end

    local shape, cframe, size = TerrainUtil:GetPartInfo(obj)
    local material = Store:Get('Material')
    local preserveTerrain = Settings:Get('PreserveTerrain')

    local chRecording = ChangeHistoryService:TryBeginRecording('PartToTerrain')

    local success = TerrainUtil:ConvertToTerrain(shape, material, cframe, size, preserveTerrain)
    if success then
      if Settings:Get('DeletePart') then
        obj.Parent = nil
      end
      ChangeHistoryService:FinishRecording(chRecording, Enum.FinishRecordingOperation.Commit)
    else
      ChangeHistoryService:FinishRecording(chRecording, Enum.FinishRecordingOperation.Cancel)
    end
  end)
end

function PluginApp:componentDidUpdate()
  self.button:SetActive(self.state.guiEnabled)

  if self.state.guiEnabled then
    task.spawn(function()
      self.raycastParams.FilterDescendantsInstances = Settings:Get('IgnoreInvisibleParts') and GetInvisibleParts() or {}
    end)
  end

end

function PluginApp:render()
  local state = self.state

  return React.createElement(StudioWidget, {
    plugin = self.plugin,
    Id = 'PartToTerrain',
    Title = Localization('Plugin.Name') .. if Constants.IS_DEV_CHANNEL then '[DEV]' else '',

    Enabled = state.guiEnabled,

    OverridePreviousState = true,
    FloatingSize = Vector2.new(250, 330),
    MinimumSize = Vector2.new(250, 300),

    onClose = function()
      self.plugin:Deactivate()
    end
  }, {
    App = React.createElement(App),

    Outline = state.guiEnabled and React.createElement(Outline, {
      PluginMouse = self.pluginMouse,
      RaycastParams = self.raycastParams
    })
  })
end

function PluginApp:componentDidMount()
  -- Creates a seprate thread for update checking as to not block rendering thread.
  -- This is incase Roblox servers go extremely slow or if a user has a bad connection.
  task.spawn(function()
    if IsUpdateAvailable() then
      self:setState({ isOutdated = true })
    end
  end)
end

function PluginApp:componentWillUnmount()
  self.toolbar:Destroy()
  self.button:Destroy()

  self.PluginMouseClickConnection:Disconnect()
end

return PluginApp
