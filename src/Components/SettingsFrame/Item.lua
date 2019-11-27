local Modules = script.Parent.Parent
local Roact = require(Modules.Parent.Roact)
local StudioTheme = require(Modules.StudioTheme)
local TextLabel = require(Modules.TextLabel)
local Localization = require(Modules.Localization)
local TextButton = require(Modules.TextButton)

local SettingsItem = Roact.PureComponent:extend('SettingsItem')

function SettingsItem:init()
  self.state = {
    height = 0,
    isExpanded = false
  }

  self._expand = function()
    self:setState({
      isExpanded = not self.state.isExpanded
    })
  end

end

function SettingsItem:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BorderMode = 'Inset',
      ClipsDescendants = true,
      Size = UDim2.new(1,0,0,30),
    }, {
      Button = Roact.createElement(TextButton, {
        Text = '',
        Size = UDim2.new(1,0,0,30),
        MouseClick = self._expand
      }),
      Title = Roact.createElement(TextLabel, {
        BackgroundTransparency = 1,
        Position = UDim2.new(0,2,0,2),
        Size = UDim2.new(1,-30,1,-4),
        Text = Localization('Settings.'..props.item),
        TextColor3 = theme:GetColor('MainText'),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = 'Left'
      }),
      Image = Roact.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(1,-26,0,2),
        Size = UDim2.new(0,24,0,24),
        Image = 'rbxasset://textures/ui/LuaChat/icons/ic-back@2x.png',
        ImageColor3 = theme:GetColor('SubText'),
        Rotation = state.isExpanded and 90 or 270
      }),
    --   Desc = Roact.createElement(TextLabel, {
    --     AutoSize = true,
    --     BackgroundTransparency = 0,
    --     Position = UDim2.new(0,0,0,30),
    --     Size = UDim2.new(1,0,0,0),
    --     Text = Localization('Settings.'..props.item..'Desc'),
    --     TextColor3 = theme:GetColor('MainText'),
    --     TextSize = 14,
    --     TextWrapped = true,
    --     TextXAlignment = 'Left',
    --   }),
    })
  end)
end

return SettingsItem
