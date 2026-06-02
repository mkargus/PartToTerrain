local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)

local Localization = require(Plugin.Util.Localization)

local MaterialViewport = require(script.Parent.MaterialViewport)
local Tooltip = require(Plugin.Components.Tooltip)

local useTheme = require(Plugin.Contexts.StudioTheme).useTheme

local OVERRIDE_MATERIALS = {
  [Enum.Material.Air] = true,
  [Enum.Material.Water] = true,
}

type Props = {
  Material: Enum.Material,
  Selected: boolean?,

  OnClick: () -> ()?,
}

local function MaterialGridItem(props: Props)
  local theme = useTheme()
  local isHover, setHover = React.useState(false)
  local isPress, setPress = React.useState(false)

  local shouldUseMaterialImage = OVERRIDE_MATERIALS[props.Material]

  local onClick = React.useCallback(function()
    if props.OnClick then
      props.OnClick()
    end
  end, { props.OnClick })

  local onMouseEnter = React.useCallback(function()
    setHover(true)
  end, {})

  local onMouseLeave = React.useCallback(function()
    setHover(false)
    setPress(false)
  end, {})

  local onMouseButton1Down = React.useCallback(function()
    setPress(true)
  end, {})

  local onMouseButton1Up = React.useCallback(function()
    setPress(false)
  end, {})

  local borderColor = Enum.StudioStyleGuideColor.Border
  if props.Selected then
    borderColor = Enum.StudioStyleGuideColor.LinkText
  end

  local modifier = Enum.StudioStyleGuideModifier.Default
  if isPress then
    modifier = Enum.StudioStyleGuideModifier.Pressed
  elseif isHover then
    modifier = Enum.StudioStyleGuideModifier.Hover
  end

  return React.createElement('ImageButton', {
    AutoButtonColor = false,
    BackgroundColor3 = theme:GetColor(borderColor, modifier),
    [React.Event.MouseButton1Click] = onClick,
    [React.Event.MouseEnter] = onMouseEnter,
    [React.Event.MouseLeave] = onMouseLeave,
    [React.Event.MouseButton1Down] = onMouseButton1Down,
    [React.Event.MouseButton1Up] = onMouseButton1Up,
  }, {
    UICorner = React.createElement('UICorner', {
      CornerRadius = UDim.new(0, 8),
    }),

    UIPadding = React.createElement('UIPadding', {
      PaddingBottom = UDim.new(0, 1),
      PaddingLeft = UDim.new(0, 1),
      PaddingRight = UDim.new(0, 1),
      PaddingTop = UDim.new(0, 1),
    }),

    Tooltip = React.createElement(Tooltip.Trigger, {
      Text = Localization('Materials.' .. props.Material.Name),
    }),

    Frame = React.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Button, modifier),
      Size = UDim2.fromScale(1, 1),
    }, {
      UICorner = React.createElement('UICorner', {
        CornerRadius = UDim.new(0, 7),
      }),

      MaterialViewport = not shouldUseMaterialImage and React.createElement(MaterialViewport, {
        Material = props.Material,
        Size = UDim2.fromScale(1, 1),
      }),

      MaterialImage = shouldUseMaterialImage and React.createElement('ImageLabel', {
        Image = `rbxasset://studio_svg_textures/Lua/TerrainEditor/Dark/Large/{props.Material.Name}.png`,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
      }),

      UIPadding = shouldUseMaterialImage and React.createElement('UIPadding', {
        PaddingBottom = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 2),
        PaddingTop = UDim.new(0, 2),
      }),
    }),
  })
end

return MaterialGridItem
