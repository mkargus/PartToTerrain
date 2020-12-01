local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Localization = require(Util.Localization)
local Constants = require(Util.Constants)

local Components = Plugin.Components
local StudioTheme = require(Components.StudioTheme)
local Navbar = require(Components.Navbar)
local MaterialPanel = require(Components.MaterialPanel)
local SettingsPanel = require(Components.SettingsPanel)
local TextLabel = require(Components.TextLabel)
local Store = require(Components.Store)

local App = Roact.PureComponent:extend('App')

function App:renderBody(Panel)
  if Panel == 'Materials' then
    return Roact.createElement(MaterialPanel, {
      Size = self.props.IsOutdated and UDim2.new(1, 0, 1, -53) or UDim2.new(1, 0, 1, -35),
    })
  elseif Panel == 'Settings' then
    return Roact.createElement(SettingsPanel, {
      Size = self.props.IsOutdated and UDim2.new(1, -10, 1, -53) or UDim2.new(1, -10, 1, -35),
      plugin = self.props.plugin
    })
  end
end

function App:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor('MainBackground'),
      BorderSizePixel = 0,
      Size = UDim2.new(1, 0, 1, 0)
    }, {
      UIListLayout = Roact.createElement('UIListLayout', {
        -- HorizontalAlignment = 'Center',
        SortOrder = 'LayoutOrder'
      }),

      Navbar = Roact.createElement(Navbar, {
        Tabs = Constants.NAVBAR_TABS
      }),

      Body = self:renderBody(state.Panel),

      update = props.IsOutdated and Roact.createElement(TextLabel, {
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Titlebar),
        Position = UDim2.new(0, 0, 1, -17),
        Text = Localization('Notice.Outdated', { props.IsOutdated }),
        TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
        TextSize = 12,
        TextWrapped = true
      })
    })
  end)
end

return Store:Roact(App, { 'Panel' })
