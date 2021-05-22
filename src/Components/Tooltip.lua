local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local TextLabel = require(Plugin.Components.TextLabel)
local StudioTheme = require(Plugin.Components.StudioTheme)

local Tooltip = Roact.PureComponent:extend('Tooltip')

function Tooltip:render()
  local props = self.props

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement(TextLabel, {
      AutomaticSize = Enum.AutomaticSize.XY,
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Tooltip),
      BackgroundTransparency = 0.1,
      Size = UDim2.new(0, 50, 0, 16),
      Text = props.Text,
      TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
    }, {
      UICorner = Roact.createElement('UICorner', {
        CornerRadius = UDim.new(0, 3)
      }),
      UIPadding = Roact.createElement('UIPadding', {
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3),
        PaddingTop = UDim.new(0, 3)
      }),
      -- UIStroke = Roact.createElement('UIStroke', {
      --   ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
      --   Color = theme:GetColor('Border')
      -- })
    })
  end)

end

return Tooltip
