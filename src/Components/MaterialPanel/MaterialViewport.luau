-- This is based off of how Roblox does it on the Terrain Editor.
-- It might be bad but it works.

local InsertService = game:GetService('InsertService')

local React = require(script.Parent.Parent.Parent.Packages.React)

local DEFAULT_COLORS = {
  [Enum.Material.Asphalt] = Color3.fromRGB(80, 84, 84),
  [Enum.Material.Basalt] = Color3.fromRGB(75, 74, 74),
  [Enum.Material.Brick] = Color3.fromRGB(138, 97, 73),
  [Enum.Material.Cobblestone] = Color3.fromRGB(134, 134, 118),
  [Enum.Material.Concrete] = Color3.fromRGB(152, 152, 152),
  [Enum.Material.CrackedLava] = Color3.fromRGB(255, 24, 67),
  [Enum.Material.Glacier] = Color3.fromRGB(221, 228, 229),
  [Enum.Material.Grass] = Color3.fromRGB(111, 126, 62),
  [Enum.Material.Ground] = Color3.fromRGB(140, 130, 104),
  [Enum.Material.Ice] = Color3.fromRGB(204, 210, 223),
  [Enum.Material.LeafyGrass] = Color3.fromRGB(106, 134, 64),
  [Enum.Material.Limestone] = Color3.fromRGB(255, 243, 192),
  [Enum.Material.Mud] = Color3.fromRGB(121, 112, 98),
  [Enum.Material.Pavement] = Color3.fromRGB(143, 144, 135),
  [Enum.Material.Rock] = Color3.fromRGB(99, 100, 102),
  [Enum.Material.Salt] = Color3.fromRGB(255, 255, 254),
  [Enum.Material.Sand] = Color3.fromRGB(207, 203, 167),
  [Enum.Material.Sandstone] = Color3.fromRGB(148, 124, 95),
  [Enum.Material.Slate] = Color3.fromRGB(88, 89, 86),
  [Enum.Material.Snow] = Color3.fromRGB(235, 253, 255),
  [Enum.Material.WoodPlanks] = Color3.fromRGB(172, 148, 108),
}

local DEFAULT_MODEL = Instance.new('Model')

local templateCache = {}

type MaterialViewportProps = {
  LayoutOrder: number?,
  Material: Enum.Material,
  Size: UDim2?,
}

local function getMeshPartAsync(assetId: string)
  if templateCache[assetId] then
    return templateCache[assetId]
  end

  local meshPart

  local success, err = pcall(function()
    meshPart = InsertService:CreateMeshPartAsync(assetId, Enum.CollisionFidelity.Box, Enum.RenderFidelity.Automatic)
    if meshPart then
      meshPart.Size = Vector3.new(5, 5, 5)
    end
  end)

  if not success or not meshPart then
    warn(err)
    return DEFAULT_MODEL
  end

  templateCache[assetId] = meshPart
  return meshPart
end

local function MaterialViewport(props: MaterialViewportProps)
  local viewportRef = React.useRef(nil :: ViewportFrame?)
  local cameraRef = React.useRef(Instance.new('Camera'))
  local model, setModel = React.useState(DEFAULT_MODEL :: Model)
  local activePart, setActivePart = React.useState(nil :: BasePart?)

  local centerCamera = React.useCallback(function()
    local FocusDirection = Vector3.new(0, 0, -1)

    local camera = cameraRef.current

    local viewModel = model
    if not viewModel then
      return
    end

    local initialDistance = 6
    local modelSize: Vector3 = if viewModel:IsA('Model') then viewModel:GetExtentsSize() else viewModel.Size

    local viewDistance = (initialDistance or modelSize.Magnitude) * 0.8
    local directionUnit = FocusDirection.Unit

    camera.Focus = CFrame.new(Vector3.zero)
    camera.CFrame = CFrame.new(camera.Focus.Position + (viewDistance * directionUnit), camera.Focus.Position)
  end, {})

  React.useEffect(function()
    setModel(getMeshPartAsync('rbxasset://models/MaterialManager/smooth_sphere.mesh'))
  end, {})

  React.useEffect(function()
    if model and model:IsA('BasePart') and viewportRef.current then
      local cloneModel = model:Clone()
      cloneModel.Parent = viewportRef.current

      setActivePart(cloneModel)
      centerCamera()
    end

    return function()
      if activePart then
        activePart:Destroy()
      end
    end
  end, { model } :: { any })

  -- Add material texture and color.
  React.useEffect(function()
    if not activePart or not activePart:IsA('MeshPart') then
      return
    end

    activePart.Color = DEFAULT_COLORS[props.Material] or Color3.fromRGB(163, 162, 165)
    activePart.Material = props.Material
  end, { activePart, props.Material } :: { any })

  React.useEffect(function()
    return function()
      cameraRef.current:Destroy()
    end
  end, {})

  return React.createElement('ViewportFrame', {
    Ambient = Color3.fromRGB(120, 120, 135),
    LightColor = Color3.fromRGB(316, 316, 331),
    LightDirection = Vector3.new(10, -10, 10),

    BackgroundTransparency = 1,
    LayoutOrder = props.LayoutOrder,
    Size = props.Size,
    CurrentCamera = cameraRef.current,
    ref = viewportRef,
  })
end

return MaterialViewport
