local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local StudioTheme = require(Plugin.Components.StudioTheme)

local ScrollingFrame = Roact.PureComponent:extend('ScrollingFrame')

ScrollingFrame.defaultProps = {
  ScrollBarThickness = 8,
  ScrollBarThicknessPadding = 3
}

function ScrollingFrame:init()
  self.state = {
    isShowingScrollBar = false
  }

  function self._onChange(rbx)
    self:setState({
      isShowingScrollBar = rbx.AbsoluteWindowSize.Y <= rbx.CanvasSize.Y.Offset
    })
  end
end

function ScrollingFrame:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(_, themeEnum)
    local isDark = themeEnum == Enum.UITheme.Dark

    local BkgColor = isDark and Color3.fromRGB(38, 38, 38) or Color3.fromRGB(245, 245, 245)
    local ScrollbarColor = isDark and Color3.fromRGB(85, 85, 85) or Color3.fromRGB(245, 245, 245)

    return Roact.createElement('Frame', {
      BackgroundTransparency = 1,
      LayoutOrder = props.LayoutOrder,
      Size = props.Size
    }, {
      ScrollingBKG = state.isShowingScrollBar and Roact.createElement('Frame', {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = BkgColor,
        BorderSizePixel = props.ScrollBarThicknessPadding,
        BorderColor3 = BkgColor,
        Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, props.ScrollBarThickness, 1, 0)
      }),
      ScrollingFrame = Roact.createElement('ScrollingFrame', {
        -- AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        BottomImage = 'rbxasset://textures/StudioToolbox/ScrollBarBottom.png',
        CanvasSize = props.CanvasSize,
        MidImage = 'rbxasset://textures/StudioToolbox/ScrollBarMiddle.png',
        ScrollBarImageColor3 = ScrollbarColor,
        ScrollBarThickness = props.ScrollBarThickness,
        ScrollingDirection = 'Y',
        Size = UDim2.new(1, 0, 1, 0),
        TopImage = 'rbxasset://textures/StudioToolbox/ScrollBarTop.png',
        VerticalScrollBarInset = 'ScrollBar',
        ZIndex = 2,
        [Roact.Change.AbsoluteWindowSize] = self._onChange
      }, props[Roact.Children])
    })
  end)

end

return ScrollingFrame
