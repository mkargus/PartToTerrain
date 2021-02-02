local Plugin = script.Parent.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local StudioTheme = require(Plugin.Components.StudioTheme)

local Separator = Roact.PureComponent:extend('Separator')

function Separator:render()
  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Separator),
      BorderSizePixel = 0,
      Size = UDim2.new(1, 0, 0, 1),
      LayoutOrder = self.props.LayoutOrder
    }, {
      UIGradient = Roact.createElement('UIGradient', {
        Transparency = NumberSequence.new({
          NumberSequenceKeypoint.new(0, 1),
          NumberSequenceKeypoint.new(0.1, 0),
          NumberSequenceKeypoint.new(0.9, 0),
          NumberSequenceKeypoint.new(1, 1)
        })
      })
    })
  end)
end

return Separator
