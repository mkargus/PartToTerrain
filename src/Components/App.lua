local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)
local StudioTheme = require(Modules.StudioTheme)
local Navbar = require(Modules.Navbar)
local MaterialFrame = require(Modules.MaterialFrame)
local SettingsFrame = require(Modules.SettingsFrame)

local App = Roact.PureComponent:extend('App')

function App:init()
  local store = self.props.store

  self.state = {
    store = store:getState()
  }

  store.changed:connect(function()
    self:setState({
      store = store:getState()
    })
  end)
end

function App:render()
  local props = self.props
  local state = self.state
  local store = state.store

  local body

  if store.Frame == 'Materials' then
    body = Roact.createElement(MaterialFrame, {
      -- TODO: Change the value for outdated size.
      Size = props.IsOutdated and UDim2.new(1,0,1,0) or UDim2.new(1,-10,1,-35),
      Items = props.Constants.Materials,
      MaterialSelected = store.Material
    })
  elseif store.Frame == 'Settings' then
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
        ActiveFrame = store.Frame
      }),
      Body = body,

      -- why does this work
      -- update = not props.IsOutdated and Roact.createElement('TextLabel') or nil
    })
  end)
end

return App
