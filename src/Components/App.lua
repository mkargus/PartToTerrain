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
local ThemedTextLabel = require(Components.ThemedTextLabel)
local Store = require(Components.Store)

local App = Roact.PureComponent:extend('App')

function App:render()
  local props = self.props
  local store = self.state.Panel

  local body

  if store == 'Materials' then
    body = Roact.createElement(MaterialPanel, {
      Size = props.IsOutdated and UDim2.new(1, -10, 1, -53) or UDim2.new(1, -10, 1, -35),
    })
  elseif store == 'Settings' then
    body = Roact.createElement(SettingsPanel, {
      Size = props.IsOutdated and UDim2.new(1, -10, 1, -53) or UDim2.new(1, -10, 1, -35),
      plugin = props.plugin
    })
  end

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor('MainBackground'),
      BorderSizePixel = 0,
      Size = UDim2.new(1, 0, 1, 0)
    }, {
      UIListLayout = Roact.createElement('UIListLayout', {
        HorizontalAlignment = 'Center',
        Padding = UDim.new(0, 5),
        SortOrder = 'LayoutOrder'
      }),

      Navbar = Roact.createElement(Navbar, {
        Tabs = Constants.NAVBAR_TABS
      }),

      Body = body,

      update = props.IsOutdated and Roact.createElement(ThemedTextLabel, {
        BackgroundColor3 = theme:GetColor('Separator'),
        Position = UDim2.new(0, 0, 1, -17),
        Text = Localization('Notice.Outdated', { props.IsOutdated }),
        TextWrapped = true
      })
    })
  end)
end

return Store:Roact(App, { 'Panel' })
