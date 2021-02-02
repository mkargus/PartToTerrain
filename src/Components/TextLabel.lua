local Roact = require(script.Parent.Parent.Libs.Roact)

local TextLabel = Roact.PureComponent:extend('TextLabel')

TextLabel.defaultProps = {
  -- AutomaticSize = Enum.AutomaticSize.None,
  BackgroundTransparency = 0,
  BorderSizePixel = 0,
  Font = Enum.Font.Gotham,
  TextSize = 14
}

function TextLabel:render()
  local props = self.props

  return Roact.createElement('TextLabel', {
    -- AutomaticSize = props.AutomaticSize,
    BackgroundColor3 = props.BackgroundColor3,
    BackgroundTransparency = props.BackgroundTransparency,
    BorderSizePixel = props.BorderSizePixel,
    ClipsDescendants = props.ClipsDescendants,
    Font = props.Font,
    LayoutOrder = props.LayoutOrder,
    Position = props.Position,
    Size = props.Size,
    Text = props.Text,
    TextColor3 = props.TextColor3,
    TextSize = props.TextSize,
    TextWrapped = props.TextWrapped,
    TextXAlignment = props.TextXAlignment,
    Visible = props.Visible,
    ZIndex = props.ZIndex,
    [Roact.Ref] = props[Roact.Ref]
  })
end

return TextLabel
