local Modules = script.Parent.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local StudioTheme = require(Modules.StudioTheme)
local ThemedTextLabel = require(Modules.ThemedTextLabel)
local Localization = require(Modules.Parent.Util.Localization)
local Constants = require(Modules.Parent.Util.Constants)
local ToggleButton = require(Modules.ToggleButton)

local SettingsItem = Roact.PureComponent:extend('SettingsItem')

function SettingsItem:init()
  self.state = {
    height = 0,
    isExpanded = false,
    isToggleEnabled = self.props.plugin:GetSetting(self.props.item)
  }

  function self._expandClick()
    self:setState({
      isExpanded = not self.state.isExpanded
    })
  end

  function self._textSizeChange(rbx)
    local Text = game:GetService('TextService')
    local tb = Text:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(rbx.AbsoluteSize.X, 100000))
    rbx.Size = UDim2.new(1, 0, 0, tb.Y + 5)

    -- Bad practice. Will replace at a later time.
    rbx.Parent.ToggleFrame.Position = UDim2.new(0,0,0,tb.Y+35+3)
    self:setState({
      height = tb.Y+35+3+24+3
    })
  end

  function self._toggleClick()
    local props = self.props
    local plugin = props.plugin
    plugin:SetSetting(props.item, not plugin:GetSetting(props.item))

    self:setState({
      isToggleEnabled = plugin:GetSetting(props.item)
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
      -- Does the trick for now.
      Size = state.isExpanded and UDim2.new(1, props.isScrollbarShowing and -8 or 0,0,state.height) or UDim2.new(1,props.isScrollbarShowing and -8 or 0,0,30),
    }, {

      -- "Header"
      Button = Roact.createElement('TextButton', {
        BackgroundTransparency = 1,
        Text = '',
        Size = UDim2.new(1,0,0,30),
        [Roact.Event.MouseButton1Click] = self._expandClick
      }, {
        Title = Roact.createElement(ThemedTextLabel, {
          BackgroundTransparency = 1,
          Position = UDim2.new(0,2,0,2),
          Size = UDim2.new(1,-30,0,26),
          Text = Localization('Settings.'..props.item),
          TextSize = '14',
          TextXAlignment = 'Left',
        }),
        ExpandImg = Roact.createElement('ImageLabel', {
          BackgroundTransparency = 1,
          Position = UDim2.new(1,-26,0,2),
          Size = UDim2.new(0,24,0,24),
          Image = Constants.SETTING_EXPAND_IMAGE,
          ImageColor3 = theme:GetColor('SubText'),
          Rotation = state.isExpanded and 90 or 270,
        })
      }),

      Desc = Roact.createElement('TextLabel', {
        BackgroundTransparency = 1,
        Position = UDim2.new(0,0,0,30),
        Font = 'SourceSans',
        Text = Localization('Settings.'..props.item..'Desc'),
        TextSize = 14,
        Size = UDim2.new(1,0,0,0),
        TextWrapped = true,
        TextColor3 = theme:GetColor('MainText'),
        TextXAlignment = 'Left',
        [Roact.Change.AbsoluteSize] = self._textSizeChange
      }),

      ToggleFrame = Roact.createElement('Frame', {
        BackgroundTransparency = 1,
        Position = UDim2.new(1,0,0,0),
        Size = UDim2.new(1,0,0,24),
        Visible = true
      }, {
        ToggleButton = Roact.createElement(ToggleButton, {
          Position = UDim2.new(1,-42,0,0),
          Enabled = state.isToggleEnabled,
          MouseClick = self._toggleClick
        }),
        ToggleLabel = Roact.createElement(ThemedTextLabel, {
          BackgroundTransparency = 1,
          Size = UDim2.new(1,-42,1,0),
          Text = Localization('Toggle.'..(state.isToggleEnabled and 'Enabled' or 'Disabled')),
          TextSize = 14,
          TextXAlignment = 'Left'
        })
      })
    })
  end)

end

return SettingsItem
