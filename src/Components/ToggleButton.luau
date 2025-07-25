local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local useTheme = require(Plugin.Hooks.useTheme)

local IMAGE_BASE = 'rbxasset://textures/RoactStudioWidgets/toggle_%s_%s.png'

type Props = {
  AnchorPoint: Vector2?,
  Disabled: boolean?,
  LayoutOrder: number?,
  Position: UDim2?,
  Selected: boolean?,

  OnClick: (value: boolean) -> ()?,
}

local function ToggleButton(props: Props)
  local theme = useTheme()
  local themeKey = string.lower(theme.Name)

  local modiferKey = 'off'
  if props.Disabled and props.Selected then
    modiferKey = 'on_disable'
  elseif props.Selected then
    modiferKey = 'on'
  elseif props.Disabled then
    modiferKey = 'disable'
  end

  local onClick = React.useCallback(function()
    if not props.Disabled and props.OnClick then
      props.OnClick(not props.Selected)
    end
  end, { props.OnClick, props.Disabled } :: { unknown })

  return React.createElement('ImageButton', {
    AnchorPoint = props.AnchorPoint,
    AutoButtonColor = false,
    BackgroundTransparency = 1,
    Image = string.format(IMAGE_BASE, modiferKey, themeKey),
    LayoutOrder = props.LayoutOrder,
    Position = props.Position,
    Size = UDim2.fromOffset(40, 24),
    [React.Event.MouseButton1Click] = onClick,
  })
end

return ToggleButton
