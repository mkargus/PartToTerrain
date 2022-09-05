local Roact = require(script.Parent.Parent.Packages.Roact)

local TextLabel = Roact.PureComponent:extend('TextLabel')

TextLabel.defaultProps = {
  BorderSizePixel = 0,
  Font = Enum.Font.Gotham,
  TextSize = 14
}

function TextLabel:render()
  local props = self.props

  return Roact.createElement('TextLabel', {
    AutomaticSize = props.AutomaticSize,
    BackgroundColor3 = props.BackgroundColor3,
    BackgroundTransparency = props.BackgroundTransparency,
    BorderColor3 = props.BorderColor3,
    BorderSizePixel = props.BorderSizePixel,
    Font = props.Font,
    LayoutOrder = props.LayoutOrder,
    LineHeight = props.LineHeight,
    Position = props.Position,
    RichText = props.RichText,
    Size = props.Size,
    Text = props.Text,
    TextColor3 = props.TextColor3,
    TextSize = props.TextSize,
    TextWrapped = props.TextWrapped,
    TextXAlignment = props.TextXAlignment,
  }, props[Roact.Children])
end

return TextLabel
