local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)
local StudioTheme = require(Modules.StudioTheme)

local TextButton = Roact.PureComponent:extend('TextButton')

TextButton.defaultProps = {
  Font = Enum.Font.SourceSans,
  TextSize = 14
}

function TextButton:init()
  self.state = {
    hover = false,
    press = false
  }

  self._mouseEnter = function()
    self:setState({
      hover = true
    })
  end

  self._mouseLeave = function()
    self:setState({
      hover = false,
      press = false
    })
  end

  self._mouseButtonDown = function()
    self:setState({
      press = true
    })
  end

  self._mouseButtonUp = function()
    self:setState({
      press = false
    })
  end
end

function TextButton:render()
  local props = self.props
  local ButtonState = 'Default'

  if props.Disabled then
    ButtonState = 'Disabled'
  elseif props.Selected then
    ButtonState = 'Selected'
  elseif self.state.press then
    ButtonState = 'Pressed'
  elseif self.state.hover then
    ButtonState = 'Hover'
  end

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('TextButton', {
      AutoButtonColor = false,
      BackgroundColor3 = theme:GetColor('Button', ButtonState),
      BorderColor3 = theme:GetColor('ButtonBorder', ButtonState),
      Font = props.Font,
      Position = props.Position,
      Size = props.Size,
      Text = props.Text,
      TextColor3 = theme:GetColor('ButtonText', ButtonState),
      TextSize = props.TextSize,
      [Roact.Event.MouseButton1Click] = props.leftClick,
      [Roact.Event.MouseEnter] = self._mouseEnter,
      [Roact.Event.MouseLeave] = self._mouseLeave,
      [Roact.Event.MouseButton1Down] = self._mouseButtonDown,
      [Roact.Event.MouseButton1Up] = self._mouseButtonUp
    })
  end)
end

return TextButton
