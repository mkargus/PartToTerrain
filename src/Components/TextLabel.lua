local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)

-- local TextService = game:GetService("TextService")

return function(props)
  return Roact.createElement('TextLabel', {
    BackgroundColor3 = props.BackgroundColor3,
    BackgroundTransparency = props.BackgroundTransparency or 0,
    BorderSizePixel = 0,
    ClipsDescendants = props.ClipsDescendants,
    Font = props.Font or 'SourceSans',
    Position = props.Position,
    Size = props.Size,
    Text = props.Text,
    TextColor3 = props.TextColor3,
    TextSize = props.TextSize or 14
  })
end
