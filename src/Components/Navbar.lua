local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)
local RoactRodux = require(Modules.Parent.RoactRodux)
local Actions = require(Modules.Parent.Actions)

local TextButton = require(Modules.TextButton)
local Localization = require(Modules.Localization)

local Navbar = Roact.PureComponent:extend('Navbar')

function Navbar:render()
  return Roact.createElement('Frame', {
    BackgroundTransparency = 1,
    Size = UDim2.new(1,0,0,25)
  }, {
    UIListLayout = Roact.createElement('UIListLayout', {
      FillDirection = 'Horizontal',
      Padding = UDim.new(0,1)
    }),
    Materials = Roact.createElement(TextButton, {
      Selected = self.props.ActiveFrame == 'Materials',
      Text = Localization('Button.Materials'),
      Size = UDim2.new(0.5,0,1,0),
      leftClick = function()
        self.props.SetFrame('Materials')
      end
    }),
    Settings = Roact.createElement(TextButton, {
      Selected = self.props.ActiveFrame == 'Settings',
      Text = Localization('Button.Settings'),
      Size = UDim2.new(0.5,0,1,0),
      leftClick = function()
        self.props.SetFrame('Settings')
      end
    }),
  })
end

local function mapStateToProps(state)
  if not state then return end
  return {}
end

local function mapDispatchToProps(dispatch)
  return {
    SetFrame = function(frame)
      dispatch(Actions.SetFrame(frame))
    end
  }
end

return RoactRodux.connect(mapStateToProps,mapDispatchToProps)(Navbar)
