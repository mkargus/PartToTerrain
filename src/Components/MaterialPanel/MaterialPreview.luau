local React = require(script.Parent.Parent.Parent.Packages.React)

local DEFAULT_COLOR = Color3.new(1, 1, 1)

local FOCUS_POSITION = Vector3.zero
local FOCUS_DIRECTION = Vector3.new(0, 0, -1)

local function buildPart(): Part
  local part = Instance.new('Part')
  part.Anchored = true
  part.CanCollide = false
  part.CanQuery = false
  part.CanTouch = false

  part.TopSurface = Enum.SurfaceType.Smooth
  part.BottomSurface = Enum.SurfaceType.Smooth

  part.Size = Vector3.new(5, 5, 5)
  part.Shape = Enum.PartType.Ball

  return part
end

local function frameCamera(extentsSize: Vector3, initialDistance: number?): CFrame
  local baseDistance = initialDistance or extentsSize.Magnitude
  local distance = baseDistance * 0.8
  return CFrame.new(FOCUS_POSITION + distance * FOCUS_DIRECTION.Unit, FOCUS_POSITION)
end

type MaterialPreviewProps = {
  Material: Enum.Material,
  Variant: string?,
  Color: Color3?,

  LayoutOrder: number?,
  Size: UDim2?,
}

local function MaterialPreview(props: MaterialPreviewProps)
  local viewportRef = React.useRef(nil :: ViewportFrame?)

  React.useEffect(function()
    local viewport = viewportRef.current
    if viewport == nil then
      return
    end

    local part = buildPart()
    part.Material = props.Material
    part.MaterialVariant = props.Variant or ''
    part.Color = props.Color or DEFAULT_COLOR

    local framing = frameCamera(part.Size, 6)
    local camera = Instance.new('Camera')
    camera.CFrame = framing
    viewport.CurrentCamera = camera

    part.Parent = viewport

    return function()
      part:Destroy()
      camera:Destroy()
    end
  end, { props.Material, props.Color, props.Variant } :: { any })

  return React.createElement('ViewportFrame', {
    Ambient = Color3.fromRGB(120, 120, 135),
    LightColor = Color3.fromRGB(316, 316, 331),
    LightDirection = Vector3.new(10, -10, 10),

    BackgroundTransparency = 1,
    LayoutOrder = props.LayoutOrder,
    Size = props.Size,
    ref = viewportRef,
  })
end

return MaterialPreview
