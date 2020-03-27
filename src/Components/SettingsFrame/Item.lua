------------------------------
-- Trash code. Redo this.
------------------------------

local Modules = script.Parent.Parent
local Roact = require(Modules.Parent.Roact)
local StudioTheme = require(Modules.StudioTheme)
local ThemedTextLabel = require(Modules.ThemedTextLabel)
local Localization = require(Modules.Parent.Util.Localization)
local TextButton = require(Modules.TextButton)
local ToggleButton = require(Modules.ToggleButton)

local SettingsItem = Roact.PureComponent:extend('SettingsItem')

function SettingsItem:init()
  local _props = self.props

  self.state = {
    height = 120,
    isExpanded = false,
    settingEnabled = _props.plugin:GetSetting(_props.item)
  }

  self._expandClick = function()
    self:setState({
      isExpanded = not self.state.isExpanded
    })
  end

  self._ToggleClick = function()
    local plugin = _props.plugin
    local item = _props.item

    plugin:SetSetting(item, not plugin:GetSetting(item))
    self:setState({
      settingEnabled = plugin:GetSetting(item)
    })
  end
end

function SettingsItem:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor('CategoryItem'),
      BorderSizePixel = 0,
      ClipsDescendants = true,
      -- ! Image clips through the scrollbar.
      Size = state.isExpanded and UDim2.new(1,0,0,state.height) or UDim2.new(1,0,0,30)
    }, {

      Button = Roact.createElement(TextButton, {
        Text = '',
        Size = UDim2.new(1,0,0,30),
        MouseClick = self._expandClick
      }),

      Title = Roact.createElement(ThemedTextLabel, {
        BackgroundTransparency = 1,
        Position = UDim2.new(0,2,0,2),
        Size = UDim2.new(1,-30,0,26),
        Text = Localization('Settings.'..props.item),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = 'Left',
        ZIndex = 2
      }),

      ExpandImg = Roact.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(1,-26,0,2),
        Size = UDim2.new(0,24,0,24),
        Image = 'rbxasset://textures/ui/LuaChat/icons/ic-back@2x.png',
        ImageColor3 = theme:GetColor('SubText'),
        Rotation = state.isExpanded and 90 or 270,
        ZIndex = 2
      }),

      Desc = Roact.createElement(ThemedTextLabel, {
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,0,30),
        Text = Localization('Settings.'..props.item..'Desc'),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = 'Left',
      }),

      ToggleFrame = Roact.createElement('Frame', {
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,0,75),
        Size = UDim2.new(1,0,0,24)
      }, {
        Toggle = Roact.createElement(ToggleButton, {
          Enabled = state.settingEnabled,
          Position = UDim2.new(1,-42,0,0),
          MouseClick = self._ToggleClick
        }),
        ToggleText = Roact.createElement(ThemedTextLabel, {
          BackgroundTransparency = 1,
          Size = UDim2.new(1,-48,0,24),
          Text = Localization('Toggle.'..(state.settingEnabled and 'Enabled' or 'Disabled')),
          TextSize = 14,
          TextWrapped = true,
          TextXAlignment = 'Left',
        })

      })

    })
  end)
end

return SettingsItem
