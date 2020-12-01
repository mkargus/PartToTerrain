local Roact = require(script.Parent.Parent.Libs.Roact)
local TextService = game:GetService("TextService")

local function update(rbx)
  if rbx.TextWrapped then
    local width = rbx.AbsoluteSize.X
    local tb = TextService:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(width, 100000))
    rbx.Size = UDim2.new(1, 0, 0, tb.Y + 6)
  else
    local tb = TextService:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(100000, 100000))
    rbx.Size = UDim2.new(0, tb.X, 0, tb.Y)
  end
end

return function(props)
  local autoSize = not props.Size

  return Roact.createElement('TextLabel', {
    -- AutomaticSize = props.AutomaticSize,
    BackgroundColor3 = props.BackgroundColor3,
    BackgroundTransparency = props.BackgroundTransparency or 0,
    BorderSizePixel = props.BorderSizePixel or 0,
    ClipsDescendants = props.ClipsDescendants,
    Font = props.Font or Enum.Font.Gotham,
    LayoutOrder = props.LayoutOrder,
    Position = props.Position,
    Size = props.Size or props.TextWrapped and UDim2.new(1, 0, 0, 0) or nil,
    Text = props.Text,
    TextColor3 = props.TextColor3,
    TextSize = props.TextSize or 14,
    TextWrapped = props.TextWrapped,
    TextXAlignment = props.TextXAlignment,
    Visible = props.Visible,
    ZIndex = props.ZIndex,
    [Roact.Change.AbsoluteSize] = autoSize and update or nil,
    [Roact.Change.TextBounds] = autoSize and update or nil
  })
end
