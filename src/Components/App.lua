local Modules = script.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local StudioTheme = require(Modules.StudioTheme)
local Navbar = require(Modules.Navbar)
local MaterialPanel = require(Modules.MaterialPanel)
local SettingsPanel = require(Modules.SettingsPanel)
local ThemedTextLabel = require(Modules.ThemedTextLabel)
local Localization = require(Modules.Parent.Util.Localization)
local Store = require(Modules.Store)

local App = Roact.PureComponent:extend('App')

function App:render()
  local props = self.props
  local store = self.state.Panel

  local body

  if store == 'Materials' then
    body = Roact.createElement(MaterialPanel, {
      Size = props.IsOutdated and UDim2.new(1,-10,1,-53) or UDim2.new(1,-10,1,-35),
    })
  elseif store == 'Settings' then
    body = Roact.createElement(SettingsPanel, {
      Size = props.IsOutdated and UDim2.new(1,-10,1,-53) or UDim2.new(1,-10,1,-35),
      plugin = props.plugin
    })
  end

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor('MainBackground'),
      BorderSizePixel = 0,
      Size = UDim2.new(1,0,1,0)
    }, {
      UIListLayout = Roact.createElement('UIListLayout', {
        HorizontalAlignment = 'Center',
        Padding = UDim.new(0, 5),
        SortOrder = 'LayoutOrder'
      }),
      Navbar = Roact.createElement(Navbar),
      Body = body,

      update = props.IsOutdated and Roact.createElement(ThemedTextLabel, {
        BackgroundColor3 = theme:GetColor('Separator'),
        Position = UDim2.new(0,0,1,-17),
        Text = Localization('Notice.Outdated', { props.IsOutdated }),
        TextWrapped = true
      })
    })
  end)
end

return Store:Roact(App, { 'Panel' })
