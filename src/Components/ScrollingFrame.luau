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

  return React.createElement('ScrollingFrame', {
    AutomaticCanvasSize = props.AutomaticCanvasSize,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    BottomImage = 'rbxasset://textures/StudioSharedUI/ScrollBarBottom.png',
    CanvasSize = props.CanvasSize or UDim2.new(),
    LayoutOrder = props.LayoutOrder,
    MidImage = 'rbxasset://textures/StudioSharedUI/ScrollBarMiddle.png',
    Position = props.Position,
    ScrollBarImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
    ScrollBarImageTransparency = 0.8,
    ScrollBarThickness = props.ScrollBarThickness or 8,
    ScrollingDirection = props.ScrollingDirection,
    Size = props.Size,
    TopImage = 'rbxasset://textures/StudioSharedUI/ScrollBarTop.png',
    VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
  }, props.children)
end

return ScrollingFrame
