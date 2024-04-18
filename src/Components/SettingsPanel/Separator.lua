local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)

local useTheme = require(Plugin.Hooks.useTheme)

local function Separator(props)
  local theme = useTheme()

  return React.createElement('Frame', {
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Separator),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 1),
    LayoutOrder = props.LayoutOrder
  }, {
    UIGradient = React.createElement('UIGradient', {
      Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.1, 0),
        NumberSequenceKeypoint.new(0.9, 0),
        NumberSequenceKeypoint.new(1, 1)
      })
    })
  })
end

return Separator
