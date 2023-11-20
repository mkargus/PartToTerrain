local Plugin = script.Parent.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local useTheme = require(Plugin.Hooks.useTheme)

local function Separator(props, hooks)
  local theme = useTheme(hooks)

  return Roact.createElement('Frame', {
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Separator),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 1),
    LayoutOrder = props.LayoutOrder
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
end

Separator = Hooks.new(Roact)(Separator)

return Separator
