local Modules = script.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local StudioTheme = require(Modules.StudioTheme)
local Navbar = require(Modules.Navbar)
local MaterialPanel = require(Modules.MaterialPanel)
local SettingsPanel = require(Modules.SettingsPanel)
local ThemedTextLabel = require(Modules.ThemedTextLabel)
local Localization = require(Modules.Parent.Util.Localization)

local App = Roact.PureComponent:extend('App')

function App:init()
  local _store = self.props.store

  self.state = {
    store = _store:getState()
  }

  _store.changed:connect(function()
    self:setState({
      store = _store:getState()
    })
  end)
end

function App:render()
  local props = self.props
  local state = self.state
  local store = state.store

  local body

  if store.Panel == 'Materials' then
    body = Roact.createElement(MaterialPanel, {
      Size = props.IsOutdated and UDim2.new(1,-10,1,-53) or UDim2.new(1,-10,1,-35),
      MaterialSelected = store.Material
    })
  elseif store.Panel == 'Settings' then
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
      Navbar = Roact.createElement(Navbar, {
        ActiveFrame = store.Panel
      }),
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

return App
