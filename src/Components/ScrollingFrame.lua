local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local useTheme = require(Plugin.Hooks.useTheme)

local function ScrollingFrame(props)
  local theme = useTheme()
  local isYAxisShowing, setYAxisShowing = React.useState(false)

  local onCanvasSizeChange = React.useCallback(function(rbx: ScrollingFrame)
    setYAxisShowing(rbx.AbsoluteWindowSize.Y < rbx.AbsoluteCanvasSize.Y)
  end, {})

  local isDark = theme.Name == 'Dark'
  local BkgColor = if isDark then Color3.fromRGB(38, 38, 38) else Color3.fromRGB(245, 245, 245)
  local ScrollbarColor = if isDark then Color3.fromRGB(85, 85, 85) else Color3.fromRGB(245, 245, 245)

  return React.createElement('Frame', {
    BackgroundTransparency = 1,
    Position = props.Position,
    LayoutOrder = props.LayoutOrder,
    Size = props.Size
  }, {
    ScrollingFrame = React.createElement('ScrollingFrame', {
      AutomaticCanvasSize = props.AutomaticCanvasSize,
      BackgroundTransparency = 1,
      BorderSizePixel = 0,
      BottomImage = 'rbxasset://textures/StudioToolbox/ScrollBarBottom.png',
      CanvasSize = props.CanvasSize or UDim2.new(),
      MidImage = 'rbxasset://textures/StudioToolbox/ScrollBarMiddle.png',
      Position = UDim2.fromOffset(0, 3),
      ScrollBarImageColor3 = ScrollbarColor,
      ScrollBarThickness = props.ScrollBarThickness or 8,
      ScrollingDirection = props.ScrollingDirection,
      Size = UDim2.new(1, -2, 1, -6),
      TopImage = 'rbxasset://textures/StudioToolbox/ScrollBarTop.png',
      VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
      ZIndex = 2,
      [React.Change.AbsoluteCanvasSize] = onCanvasSizeChange
    }, props.children),
    YScrollingBackground = isYAxisShowing and React.createElement('Frame', {
      AnchorPoint = Vector2.new(1, 0),
      BackgroundColor3 = BkgColor,
      BorderSizePixel = 0,
      Position = UDim2.fromScale(1, 0),
      Size = UDim2.new(0, 12, 1, 0)
    })
  })
end

return ScrollingFrame
