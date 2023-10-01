local Roact = require(script.Parent.Parent.Packages.Roact)

local function TextLabel(props)
  return Roact.createElement('TextLabel', {
    AutomaticSize = props.AutomaticSize,
    BackgroundColor3 = props.BackgroundColor3,
    BackgroundTransparency = props.BackgroundTransparency,
    BorderColor3 = props.BorderColor3,
    BorderSizePixel = props.BorderSizePixel or 0,
    Font = props.Font or Enum.Font.Gotham,
    LayoutOrder = props.LayoutOrder,
    LineHeight = props.LineHeight,
    Position = props.Position,
    RichText = props.RichText,
    Size = props.Size,
    Text = props.Text,
    TextColor3 = props.TextColor3,
    TextSize = props.TextSize or 14,
    TextWrapped = props.TextWrapped,
    TextXAlignment = props.TextXAlignment,
  }, props[Roact.Children])
end

return TextLabel
