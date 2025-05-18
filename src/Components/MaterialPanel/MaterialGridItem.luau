local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)

local Localization = require(Plugin.Util.Localization)

local MaterialImage = require(script.Parent.MaterialImage)
local Tooltip = require(Plugin.Components.Tooltip)

local useTheme = require(Plugin.Hooks.useTheme)

type Props = {
  Material: Enum.Material,
  Selected: boolean?,

  OnClick: () -> ()?,
}

local function MaterialGridItem(props: Props)
  local theme = useTheme()
  local isHover, setHover = React.useState(false)
  local isPress, setPress = React.useState(false)

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
      CornerRadius = UDim.new(0, 3),
    }),

    UIPadding = React.createElement('UIPadding', {
      PaddingBottom = UDim.new(0, 1),
      PaddingLeft = UDim.new(0, 1),
      PaddingRight = UDim.new(0, 1),
      PaddingTop = UDim.new(0, 1),
    }),

    Tooltip = React.createElement(Tooltip.Trigger, {
      Text = Localization('Materials.'..props.Material.Name)
    }),

    Frame = React.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Button, modifier),
      Size = UDim2.fromScale(1, 1),
    }, {
      UICorner = React.createElement('UICorner', {
        CornerRadius = UDim.new(0, 2),
      }),

      MaterialImage = React.createElement(MaterialImage, {
        Material = props.Material,
        Size = UDim2.fromScale(1, 1),
        Use2022Materials = true,
      }),

      UIPadding = React.createElement('UIPadding', {
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3),
        PaddingTop = UDim.new(0, 3),
      }),
    }),
  })
end

return MaterialGridItem
