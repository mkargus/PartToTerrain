local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local StudioTheme = require(Plugin.Components.StudioTheme)

local ScrollingFrame = Roact.PureComponent:extend('ScrollingFrame')

ScrollingFrame.defaultProps = {
  CanvasSize = UDim2.new(0, 0, 0, 0),
  ScrollBarThickness = 8
}

function ScrollingFrame:init()
  self.state = {
    isYAxisShowing = false
  }

  function self._onWindowSizeChange(rbx)
    self:setState({
      isYAxisShowing = rbx.AbsoluteWindowSize.Y < rbx.AbsoluteCanvasSize.Y
    })
  end
end

function ScrollingFrame:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(theme)
    local isDark = theme.Name == 'Dark'

    local BkgColor = isDark and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(245, 245, 245)
    local ScrollbarColor = isDark and Color3.fromRGB(85, 85, 85) or Color3.fromRGB(245, 245, 245)

    return Roact.createElement('Frame', {
      BackgroundTransparency = 1,
      Position = props.Position,
      LayoutOrder = props.LayoutOrder,
      Size = props.Size
    }, {
      YScrollingBackground = state.isYAxisShowing and Roact.createElement('Frame', {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = BkgColor,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 12, 1, 0)
      }),
      ScrollingFrame = Roact.createElement('ScrollingFrame', {
        AutomaticCanvasSize = props.AutomaticCanvasSize,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        BottomImage = 'rbxasset://textures/StudioToolbox/ScrollBarBottom.png',
        CanvasSize = props.CanvasSize,
        MidImage = 'rbxasset://textures/StudioToolbox/ScrollBarMiddle.png',
        Position = UDim2.new(0, 0, 0, 3),
        ScrollBarImageColor3 = ScrollbarColor,
        ScrollBarThickness = props.ScrollBarThickness,
        ScrollingDirection = props.ScrollingDirection,
        Size = UDim2.new(1, -2, 1, -6),
        TopImage = 'rbxasset://textures/StudioToolbox/ScrollBarTop.png',
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
        ZIndex = 2,
        [Roact.Change.AbsoluteWindowSize] = self._onWindowSizeChange
      }, props[Roact.Children])
    })
  end)

end

return ScrollingFrame
