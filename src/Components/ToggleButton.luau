--[[
  A toggle button with on and off state.

  Props:
    bool IsActive
    UDim2 Position

    callback onClick()
]]

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local useTheme = require(Plugin.Hooks.useTheme)

local function ToggleButton(props)
  local theme = useTheme()

  local isDark = theme.Name == 'Dark'
  local disabledColor = if isDark then Color3.fromRGB(85, 85, 85) else Color3.fromRGB(184, 184, 184)

  return React.createElement('ImageButton', {
    AutoButtonColor = false,
    AnchorPoint = props.AnchorPoint,
    BackgroundColor3 = if props.IsActive then Color3.fromRGB(64, 166, 81) else disabledColor,
    Size = UDim2.fromOffset(40, 24),
    Position = props.Position,
    [React.Event.MouseButton1Click] = props.onClick
  }, {
    UICorner = React.createElement('UICorner', {
      CornerRadius = UDim.new(1, 0)
    }),
    StateFrame = React.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
      Position = UDim2.fromOffset(if props.IsActive then 18 else 2, 2),
      Size = UDim2.fromOffset(20, 20)
    }, {
      UICorner = React.createElement('UICorner', {
        CornerRadius = UDim.new(1, 0)
      })
    })
  })
end

return ToggleButton
