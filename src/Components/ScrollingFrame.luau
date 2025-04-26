local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local useTheme = require(Plugin.Hooks.useTheme)

type Props = {
  AutomaticCanvasSize: Enum.AutomaticSize?,
  CanvasSize: UDim2?,
  Position: UDim2?,
  ScrollBarThickness: number?,
  ScrollingDirection: Enum.ScrollingDirection?,
  Size: UDim2?,
  LayoutOrder: number?,
  children: React.ReactNode,
}

local function ScrollingFrame(props: Props)
  local theme = useTheme()
  local isDark = theme.Name == 'Dark'
  local ScrollbarColor = if isDark then Color3.fromRGB(85, 85, 85) else Color3.fromRGB(245, 245, 245)

  return React.createElement('ScrollingFrame', {
    AutomaticCanvasSize = props.AutomaticCanvasSize,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    BottomImage = 'rbxasset://textures/StudioToolbox/ScrollBarBottom.png',
    CanvasSize = props.CanvasSize or UDim2.new(),
    MidImage = 'rbxasset://textures/StudioToolbox/ScrollBarMiddle.png',
    Position = props.Position,
    ScrollBarImageColor3 = ScrollbarColor,
    ScrollBarThickness = props.ScrollBarThickness or 8,
    ScrollingDirection = props.ScrollingDirection,
    Size = props.Size,
    TopImage = 'rbxasset://textures/StudioToolbox/ScrollBarTop.png',
    VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
    ZIndex = 2,
    LayoutOrder = props.LayoutOrder,
  }, props.children)
end

return ScrollingFrame
