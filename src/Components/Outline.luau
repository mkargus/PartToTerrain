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

type OutlineProps = {
  PluginMouse: PluginMouse,
  RaycastParams: RaycastParams?,
}

local function IsLockedPartAllowed(part: BasePart): boolean
  local ignoreLocked = Settings:Get('IgnoreLockedParts')

  if ignoreLocked and part.Locked then
    return false
  end

  return true
end

local function GetColor(part: BasePart, isConvertible: boolean, isLockedAllowed: boolean): Color3
  if not isConvertible or not isLockedAllowed then
    return Constants.OUTLINE_COLOR_ERROR
  end

  if #part:GetChildren() ~= 0 then
    return Constants.OUTLINE_COLOR_WARNING
  end

  return Constants.OUTLINE_COLOR_ALLOW
end

local function CreateOutline(part: BasePart, color: Color3): (string, { any })
  local shape, _, size = TerrainUtil:GetPartInfo(part)

  local props = {
    Adornee = part,
    AlwaysOnTop = true,
    Color3 = color,
    Transparency = 0.3,
    ZIndex = 1,
  }

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
    warn('Unknown Shape outline requested. Returning Block shape.')
    props.Size = size
    return 'BoxHandleAdornment', props
  end
end

local function Outline(props: OutlineProps)
  local mouse = props.PluginMouse

  local part, setPart = React.useState(nil :: BasePart?)
  local lastDispatchedPart = React.useRef(nil :: BasePart?)

  useEventConnection(mouse.Move, function()
    local camera = workspace.CurrentCamera.CFrame
    local ray = mouse.UnitRay
    local results = workspace:Raycast(camera.Position, ray.Direction * Constants.RAYCAST_LENGTH, props.RaycastParams)

    local hitPart = nil
    if results and not results.Instance:IsA('Terrain') then
      hitPart = results.Instance
    end

    if hitPart == lastDispatchedPart.current then
      return
    end

    lastDispatchedPart.current = hitPart
    setPart(hitPart)
  end)

  -- Handles changing the mouse icon
  React.useEffect(function()
    if not part then
      mouse.Icon = 'rbxasset://SystemCursors/Arrow'
      return
    end

    local isConvertibleToTerrain = TerrainUtil:IsConvertibleToTerrain(part)
    local isLockedPartAllowed = IsLockedPartAllowed(part)

    if not isConvertibleToTerrain or not isLockedPartAllowed then
      mouse.Icon = 'rbxasset://SystemCursors/Forbidden'
    else
      mouse.Icon = '' -- Roblox defaults to a pointing arrow.
    end
  end, { part })

  -- Bail early if the there is no part or the setting is off.
  if not part or not Settings:Get('EnabledSelectionBox') then
    return nil
  end

  local isConvertibleToTerrain = TerrainUtil:IsConvertibleToTerrain(part)
  local isLockedPartAllowed = IsLockedPartAllowed(part)

  local color = GetColor(part, isConvertibleToTerrain, isLockedPartAllowed)
  local outlineClass, outlineProps = CreateOutline(part, color)

  return ReactRoblox.createPortal({
    PTT_Outline = React.createElement(outlineClass, outlineProps),
  }, CoreGui)
end

return Outline
