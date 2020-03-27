local Modules = script.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local StudioTheme = require(Modules.StudioTheme)

return function(props)
  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('ScrollingFrame', {
      BackgroundTransparency = 1,
      BorderSizePixel = 0,
      BottomImage = 'rbxasset://textures/StudioToolbox/ScrollBarBottom.png',
      CanvasSize = props.CanvasSize,
      MidImage = 'rbxasset://textures/StudioToolbox/ScrollBarMiddle.png',
      Position = props.Position,
      ScrollBarImageColor3 = theme:GetColor('Mid'),
      ScrollBarThickness = 7,
      ScrollingDirection = 'Y',
      Size = props.Size,
      TopImage = 'rbxasset://textures/StudioToolbox/ScrollBarTop.png'
    }, props[Roact.Children])
  end)
end
