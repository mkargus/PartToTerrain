local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local TerrainEnum = require(Util.TerrainEnum)
local TerrainUtil = require(Util.TerrainUtil)

local Outline = Roact.PureComponent:extend('Outline')

function Outline:init()
  self.state = {
    part = workspace.Terrain
  }

  local raycastParams = RaycastParams.new()
  raycastParams.IgnoreWater = true

  self.pluginMouse = self.props.plugin:GetMouse()

  self.pluginMouse.Move:Connect(function()
    local camera = workspace.CurrentCamera.CFrame
    local ray = self.pluginMouse.UnitRay
    local RaycastResults = workspace:Raycast(camera.Position, ray.Direction * 1000, raycastParams)

    if RaycastResults and not RaycastResults.Instance:IsA('Terrain') then
      self:setState({ part = RaycastResults.Instance })
    else
      self.pluginMouse.Icon = ''
      self:setState({ part = workspace.Terrain })
    end
  end)

  self.props.plugin.Deactivation:Connect(function()
    self.pluginMouse.Icon = ''
    self:setState({ part = workspace.Terrain })
  end)
end

function Outline:shouldUpdate(_, nextState)
  if self.state.part == nextState.part then
    return false
  end

  return true
end

function Outline:render()
  local state = self.state
  local Part = state.part

  -- TODO: Include Ignore locked part setting.

  if Part:IsA('Terrain') then return nil end

  local shape = TerrainUtil.getPartShape(Part)

  local isConvertibleToTerrain = TerrainUtil.isConvertibleToTerrain(Part)

  self.pluginMouse.Icon = isConvertibleToTerrain and '' or 'rbxasset://SystemCursors/Forbidden'

  local color = (function()
    if isConvertibleToTerrain then
      return #Part:GetChildren() == 0  and Constants.OUTLINE_COLOR_ALLOW or Constants.OUTLINE_COLOR_WARNING
    else
      return Constants.OUTLINE_COLOR_ERROR
    end
  end)()

  return Roact.createElement(Roact.Portal, {
    target = game.CoreGui
  }, {

    PTT_BoxHandleAdornment = (shape == TerrainEnum.Shape.Block or shape == TerrainEnum.Shape.Wedge) and Roact.createElement('BoxHandleAdornment', {
      Adornee = Part,
      AlwaysOnTop = true,
      Color3 = color,
      Size = Part.Size,
      Transparency = 0.3,
      ZIndex = 1
    }),

    PTT_SphereHandleAdornment = shape == TerrainEnum.Shape.Ball and Roact.createElement('SphereHandleAdornment', {
      Adornee = Part,
      AlwaysOnTop = true,
      Color3 = color,
      Radius = math.min(Part.Size.X, Part.Size.Y, Part.Size.Z) / 2,
      Transparency = 0.3,
      ZIndex = 1
    }),

    CylinderHandleAdornment = shape == TerrainEnum.Shape.CylinderRotate and Roact.createElement('CylinderHandleAdornment', {
      Adornee = Part,
      AlwaysOnTop = true,
      CFrame = CFrame.new() * CFrame.Angles(0, math.rad(90), 0),
      Color3 = color,
      Height = Part.Size.X,
      Radius = math.min(Part.Size.Y, Part.Size.Z) / 2,
      Transparency = 0.3,
      ZIndex = 1
    })
  })
end

return Outline
