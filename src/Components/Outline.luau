local CoreGui = game:GetService('CoreGui')

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)
local ReactRoblox = require(Plugin.Packages.ReactRoblox)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local Settings = require(Util.Settings)
local TerrainEnum = require(Util.TerrainEnum)
local TerrainUtil = require(Util.TerrainUtil)

local useEventConnection = require(Plugin.Hooks.useEventConnection)

local function IsLockedPartAllowed(Part)
  local setting = Settings:Get('IgnoreLockedParts')

  return if setting then setting == Part.Locked else false
end

local function GetColor(Part, isConvertibleToTerrain, isLockedPartAllowed)
  if isConvertibleToTerrain and not isLockedPartAllowed then
    return if #Part:GetChildren() == 0 then Constants.OUTLINE_COLOR_ALLOW else Constants.OUTLINE_COLOR_WARNING
  else
    return Constants.OUTLINE_COLOR_ERROR
  end
end

local function CreateOutline(Part, color)
  local shape, _, size = TerrainUtil:GetPartInfo(Part)

  local DEFAULT_OUTLINE_PROPS = {
    Adornee = Part,
    AlwaysOnTop = true,
    Color3 = color,
    Transparency = 0.3,
    ZIndex = 1
  }

  local props = table.clone(DEFAULT_OUTLINE_PROPS)

  if shape == TerrainEnum.Shape.Block or shape == TerrainEnum.Shape.Wedge then
    props.Size = size
    return 'BoxHandleAdornment', props
  elseif shape == TerrainEnum.Shape.Ball then
    props.Radius = math.min(size.X, size.Y, size.Z) / 2
    return 'SphereHandleAdornment', props
  elseif shape == TerrainEnum.Shape.Cylinder then
    props.CFrame = CFrame.Angles(math.rad(90), 0, 0)
    props.Height = size.Y
    props.Radius = math.min(size.X, size.Z) / 2
    return 'CylinderHandleAdornment', props
  elseif shape == TerrainEnum.Shape.CylinderRotate then
    props.CFrame = CFrame.Angles(0, math.rad(90), 0)
    props.Height = size.X
    props.Radius = math.min(size.Y, size.Z) / 2
    return 'CylinderHandleAdornment', props
  else
    print('Unknown Shape outline requested. Returning Block shape.')
    props.Size = size
    return 'BoxHandleAdornment', props
  end
end

local function Outline(props)
  local Part, setPart = React.useState(nil)
  local PluginMouse = props.PluginMouse :: PluginMouse

  useEventConnection(PluginMouse.Move, function()
    local camera = workspace.CurrentCamera.CFrame
    local ray = PluginMouse.UnitRay
    local RaycastResults = workspace:Raycast(camera.Position, ray.Direction * 15000, props.RaycastParams)

    if RaycastResults and not RaycastResults.Instance:IsA('Terrain') then
      -- Only change the state if the part in the RaycastResults is different from the one in the state.
      if RaycastResults.Instance ~= Part then
        setPart(RaycastResults.Instance)
      end
    else
      setPart(nil)
    end
  end)

  if not Part then
    PluginMouse.Icon = 'rbxasset://SystemCursors/Arrow'
    return nil
  end

  local isConvertibleToTerrain = TerrainUtil:IsConvertibleToTerrain(Part)
  local isLockedPartAllowed = IsLockedPartAllowed(Part)

  PluginMouse.Icon = (isConvertibleToTerrain and not isLockedPartAllowed) and '' or 'rbxasset://SystemCursors/Forbidden'

  -- If the setting is disabled, then no need to do anymore work.
  if not Settings:Get('EnabledSelectionBox') then return nil end

  local color = GetColor(Part, isConvertibleToTerrain, isLockedPartAllowed)
  local outlineClass, outlineProps = CreateOutline(Part, color)

  return ReactRoblox.createPortal({
    PTT_Outline = React.createElement(outlineClass, outlineProps)
  }, CoreGui)
end

return Outline
