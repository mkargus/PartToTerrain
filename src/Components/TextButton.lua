local Modules = script.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local StudioTheme = require(Modules.StudioTheme)

local TextButton = Roact.PureComponent:extend('TextButton')

function TextButton:init()
  self.state = {
    hover = false,
    press = false
  }

  function self._mouseEnter()
    self:setState({
      hover = true
    })
  end

  function self._mouseLeave()
    self:setState({
      hover = false,
      press = false
    })
  end

  function self._mouseButtonDown()
    self:setState({
      press = true
    })
  end

  function self._mouseButtonUp()
    self:setState({
      press = false
    })
  end
end

function TextButton:render()
  local props = self.props
  local state = self.state
  local ButtonState = 'Default'

  if props.Selected then
    ButtonState = 'Selected'
  elseif state.press then
    ButtonState = 'Pressed'
  elseif state.hover then
    ButtonState = 'Hover'
  end

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('TextButton', {
      AutoButtonColor = false,
      BackgroundColor3 = theme:GetColor('Button', ButtonState),
      BorderColor3 = theme:GetColor('ButtonBorder', ButtonState),
      Font = props.Font or 'SourceSans',
      Position = props.Position,
      Size = props.Size,
      Text = props.Text,
      TextColor3 = theme:GetColor('ButtonText', ButtonState),
      TextSize = props.TextSize or 16,
      [Roact.Event.MouseButton1Click] = props.MouseClick,
      [Roact.Event.MouseEnter] = self._mouseEnter,
      [Roact.Event.MouseLeave] = self._mouseLeave,
      [Roact.Event.MouseButton1Down] = self._mouseButtonDown,
      [Roact.Event.MouseButton1Up] = self._mouseButtonUp
    })
  end)
end

return TextButton
