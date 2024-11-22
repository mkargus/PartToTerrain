--!strict
--? Might edit to use the button colors from the Material Manager

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local useTheme = require(Plugin.Hooks.useTheme)

type Props = {
  Icon: string,
  Position: UDim2?,

  onClick: (() -> ())
}

return function(props: Props)
  local theme = useTheme()

  local isHover, setHover = React.useState(false)

  local onMouseEnter = React.useCallback(function()
    setHover(true)
  end, {})

  local onMouseLeave = React.useCallback(function()
    setHover(false)
  end, {})

  local styleModifier = Enum.StudioStyleGuideModifier.Default
  if isHover then
    styleModifier = Enum.StudioStyleGuideModifier.Hover
  end

  return React.createElement('ImageButton', {
    AutoButtonColor = false,
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder),
    Size = UDim2.fromOffset(30, 30),
    Position = props.Position or UDim2.new(),
    [React.Event.MouseEnter] = onMouseEnter,
    [React.Event.MouseLeave] = onMouseLeave,
    [React.Event.Activated] = props.onClick :: any
  }, {
    UICorner = React.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3),
    }),

    Image = React.createElement('ImageLabel', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Button, styleModifier),
      Image = props.Icon,
      ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.ButtonText),
      Position = UDim2.fromOffset(1, 1),
      Size = UDim2.new(1, -2, 1, -2),
    }, {
      UICorner = React.createElement('UICorner', {
        CornerRadius = UDim.new(0, 3),
      }),
    })

  })
end
