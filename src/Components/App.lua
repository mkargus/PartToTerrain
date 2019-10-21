local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)
local StudioTheme = require(Modules.StudioTheme)
local Navbar = require(Modules.Navbar)
local MaterialSelection = require(Modules.MaterialSelection)

local App = Roact.PureComponent:extend('App')

function App:init()
  local store = self.props.store

  self.state = {
    -- height = 0,
    store = nil
  }

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
  local state = self.state
  local body

  if state.store.Frame == 'Materials' then
    body = Roact.createElement(MaterialSelection)
  elseif state.store.Frame == 'Settings' then
    body = Roact.createElement('TextLabel', {
      Position = UDim2.new(0,5,0,30),
      Size = UDim2.new(1,-10,1,-35),
      Text = 'Settings'
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
