local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local TerrainEnum = require(Util.TerrainEnum)
local TerrainUtil = require(Util.TerrainUtil)

local PluginSettings = require(Plugin.Components.PluginSettings)

local Outline = Roact.PureComponent:extend('Outline')

function Outline:init()
  self.state = {
    part = nil
  }

  local raycastParams = RaycastParams.new()
  raycastParams.IgnoreWater = true

  self.MoveConnection = self.props.PluginMouse.Move:Connect(function()
    local camera = workspace.CurrentCamera.CFrame
    local ray = self.props.PluginMouse.UnitRay
    local RaycastResults = workspace:Raycast(camera.Position, ray.Direction * 1000, raycastParams)

    if RaycastResults and not RaycastResults.Instance:IsA('Terrain') then
      self:setState({ part = RaycastResults.Instance })
    else
      self.props.PluginMouse.Icon = ''
      self:setState({ part = Roact.None })
    end
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

  if not Part then return nil end

  local shape, _, size = TerrainUtil.GetPartInfo(Part)

  local isConvertibleToTerrain = TerrainUtil.isConvertibleToTerrain(Part)

  return PluginSettings.with(function(settings)

    local function isLockedPartAllowed()
      local setting = settings:Get('IgnoreLockedParts')
      if setting then
        return setting == Part.Locked
      else
        return false
      end
    end

    self.props.PluginMouse.Icon = (isConvertibleToTerrain and not isLockedPartAllowed()) and '' or 'rbxasset://SystemCursors/Forbidden'

    local color = (function()
      if isConvertibleToTerrain and not isLockedPartAllowed() then
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
  end)
end

function Outline:willUnmount()
  self.MoveConnection:Disconnect()
end

return Outline
