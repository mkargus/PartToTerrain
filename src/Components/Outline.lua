local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Constants = require(Plugin.Util.Constants)
local TerrainEnum = require(Plugin.Util.TerrainEnum)
local TerrainUtil = require(Plugin.Util.TerrainUtil)

local Outline = Roact.PureComponent:extend('Outline')

function Outline:init()
  self.state = {
    part = workspace.Terrain
  }

  local raycastParams = RaycastParams.new()
  raycastParams.IgnoreWater = true

  local pluginMouse = self.props.plugin:GetMouse()

  pluginMouse.Move:Connect(function()
    local camera = workspace.CurrentCamera.CFrame
    local ray = pluginMouse.UnitRay
    local RaycastResults = workspace:Raycast(camera.Position, ray.Direction * 1000, raycastParams)

    if RaycastResults and not RaycastResults.Instance:IsA('Terrain') then
      self:setState({
        part = RaycastResults.Instance
      })
    else
      self:setState({
        part = workspace.Terrain
      })
    end
  end)

  self.props.plugin.Deactivation:Connect(function()
    self:setState({ part = workspace.Terrain })
  end)
end

function Outline:render()
  local state = self.state
  local Part = state.part

  if Part:IsA('Terrain') then return nil end

  local shape = TerrainUtil.getPartShape(Part)

  local isConvertibleToTerrain = TerrainUtil.isConvertibleToTerrain(Part)

  -- TODO: There's a better way to do this.
  local color = (function()
    if isConvertibleToTerrain then
      if #Part:GetChildren() == 0 then
        return Constants.OUTLINE_COLOR_ALLOW
      else
        return Constants.OUTLINE_COLOR_WARNING
      end
    else
      return Constants.OUTLINE_COLOR_ERROR
    end
  end)()

  return Roact.createElement(Roact.Portal, {
    target = game.CoreGui
  }, {

    PTT_BoxHandleAdornment = shape == TerrainEnum.Shape.Block and Roact.createElement('BoxHandleAdornment', {
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
    })
  })
end

return Outline
