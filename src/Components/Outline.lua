local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local Settings = require(Util.Settings)
local TerrainEnum = require(Util.TerrainEnum)
local TerrainUtil = require(Util.TerrainUtil)

local Outline = Roact.PureComponent:extend('Outline')

function Outline:init()
  self.state = {
    part = nil
  }

  self.PluginMouse = self.props.PluginMouse :: PluginMouse

  self.MoveConnection = self.PluginMouse.Move:Connect(function()
    local camera = workspace.CurrentCamera.CFrame
    local ray = self.props.PluginMouse.UnitRay
    local RaycastResults = workspace:Raycast(camera.Position, ray.Direction * 15000, self.props.raycastParams)

    if RaycastResults and not RaycastResults.Instance:IsA('Terrain') then

      -- Only change the state if the part in the RaycastResults is different from the one in the state.
      if RaycastResults.Instance ~= self.state.part then
        self:setState({ part = RaycastResults.Instance })
      end

    else

      if self.state.part then
        self.props.PluginMouse.Icon = ''
        self:setState({ part = Roact.None })
      end

    end
  end)
end

function Outline:isLockedPartAllowed(Part)
  local setting = Settings:Get('IgnoreLockedParts')
  if setting then
    return setting == Part.Locked
  else
    return false
  end
end

function Outline:render()
  local state = self.state
  local Part = state.part

  if not Part then
    self.PluginMouse.Icon = 'rbxasset://SystemCursors/Arrow'
    return nil
  end

  local shape, _, size = TerrainUtil:GetPartInfo(Part)
  local isConvertibleToTerrain = TerrainUtil:IsConvertibleToTerrain(Part)
  local isLockedPartAllowed = self:isLockedPartAllowed(Part)

  self.PluginMouse.Icon = (isConvertibleToTerrain and not isLockedPartAllowed) and '' or 'rbxasset://SystemCursors/Forbidden'

  -- If the setting is disabled, then no need to do anymore work.
  if not Settings:Get('EnabledSelectionBox') then return nil end

  local color = (function()
    if isConvertibleToTerrain and not isLockedPartAllowed then
      return #Part:GetChildren() == 0 and Constants.OUTLINE_COLOR_ALLOW or Constants.OUTLINE_COLOR_WARNING
    else
      return Constants.OUTLINE_COLOR_ERROR
    end
  end)()

  return Roact.createElement(Roact.Portal, {
    target = game:GetService('CoreGui')
  }, {

    PTT_BoxHandleAdornment = (shape == TerrainEnum.Shape.Block or shape == TerrainEnum.Shape.Wedge) and Roact.createElement('BoxHandleAdornment', {
      Adornee = Part,
      AlwaysOnTop = true,
      Color3 = color,
      Size = size,
      Transparency = 0.3,
      ZIndex = 1
    }),

    PTT_SphereHandleAdornment = shape == TerrainEnum.Shape.Ball and Roact.createElement('SphereHandleAdornment', {
      Adornee = Part,
      AlwaysOnTop = true,
      Color3 = color,
      Radius = math.min(size.X, size.Y, size.Z) / 2,
      Transparency = 0.3,
      ZIndex = 1
    }),

    CylinderHandleAdornment = shape == TerrainEnum.Shape.CylinderRotate and Roact.createElement('CylinderHandleAdornment', {
      Adornee = Part,
      AlwaysOnTop = true,
      CFrame = CFrame.new() * CFrame.Angles(0, math.rad(90), 0),
      Color3 = color,
      Height = size.X,
      Radius = math.min(size.Y, size.Z) / 2,
      Transparency = 0.3,
      ZIndex = 1
     })
  })
end

function Outline:willUnmount()
  self.MoveConnection:Disconnect()
end

return Outline
