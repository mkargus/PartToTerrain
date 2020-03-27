local Modules = script.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local StudioTheme = require(Modules.StudioTheme)

local ToggleButton = Roact.PureComponent:extend('ToggleButton')

function ToggleButton:render()
  local props = self.props
  local state = props.Enabled and 'on' or 'off'

  return StudioTheme.withTheme(function(_, themeEnum)
    return Roact.createElement('ImageButton', {
      BackgroundTransparency = 1,
      Image = 'rbxasset://textures/RoactStudioWidgets/toggle_'..state..'_'..themeEnum.Name:lower()..'.png',
      Position = props.Position,
      Size = UDim2.new(0,40,0,24),
      [Roact.Event.MouseButton1Click] = props.MouseClick,
    })
  end)
end

return ToggleButton
