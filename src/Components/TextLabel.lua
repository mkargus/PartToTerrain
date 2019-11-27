local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)

local TextService = game:GetService("TextService")

local function update(rbx)
  if rbx.TextWrapped then
    local width = rbx.AbsoluteSize.X
    local tb = TextService:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(width, 100000))
    rbx.Size = UDim2.new(1,0,0,tb.Y+2)
  else
    local tb = TextService:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(100000, 100000))
    rbx.Size = UDim2.new(0,tb.X,0,tb.Y)
  end
end

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
    TextSize = props.TextSize or 16,
    TextWrapped = props.TextWrapped,
    TextXAlignment = props.TextXAlignment,
    ZIndex = props.ZIndex,
    [Roact.Change.AbsoluteSize] = props.AutoSize and update or nil,
    [Roact.Change.TextBounds] = props.AutoSize and update or nil
  })
end
