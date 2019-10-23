local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)
local StudioTheme = require(Modules.StudioTheme)
local Navbar = require(Modules.Navbar)
local MaterialFrame = require(Modules.MaterialFrame)
local SettingsFrame = require(Modules.SettingsFrame)

local App = Roact.PureComponent:extend('App')

function App:init()
  local store = self.props.store

  self:setState({
    store = store:getState()
  })

  store.changed:connect(function()
    self:setState({
      store = store:getState()
    })
  end)
end

function App:render()
  local props = self.props
  local state = self.state
  local body

  if state.store.Frame == 'Materials' then
    body = Roact.createElement(MaterialFrame, {
      -- TODO: Change the value for outdated size.
      Size = props.IsOutdated and UDim2.new(1,0,1,0) or UDim2.new(1,-10,1,-35)
    })
  elseif state.store.Frame == 'Settings' then
    -- TODO: Support outdate size to match MaterialFrame.
    body = Roact.createElement(SettingsFrame, {
      Items = props.Constants.Settings
    })
  end

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor('MainBackground'),
      BorderSizePixel = 0,
      Size = UDim2.new(1,0,1,0)
    }, {
      Navbar = Roact.createElement(Navbar, {
        ActiveFrame = state.store.Frame
      }),
      Body = body
    })
  end)
end

return App
