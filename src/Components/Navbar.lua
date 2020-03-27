local Modules = script.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local RoactRodux = require(Modules.Parent.Libs.RoactRodux)
local Actions = require(Modules.Parent.Actions)

local TextButton = require(Modules.TextButton)
local Localization = require(Modules.Parent.Util.Localization)
local Constants = require(Modules.Parent.Util.Constants)

local Navbar = Roact.PureComponent:extend('Navbar')

function Navbar:render()
  local props = self.props
  return Roact.createElement('Frame', {
    BackgroundTransparency = 1,
    Size = UDim2.new(1,0,0,25)
  }, {
    UIListLayout = Roact.createElement('UIListLayout', {
      FillDirection = 'Horizontal',
      Padding = UDim.new(0,1)
    }),
    Materials = Roact.createElement(TextButton, {
      Selected = props.ActiveFrame == 'Materials',
      Text = Localization('Button.Materials'),
      Size = Constants.NAVBAR_BUTTON_SIZE,
      MouseClick = function()
        props.SetFrame('Materials')
      end
    }),
    Settings = Roact.createElement(TextButton, {
      Selected = props.ActiveFrame == 'Settings',
      Text = Localization('Button.Settings'),
      Size = Constants.NAVBAR_BUTTON_SIZE,
      MouseClick = function()
        props.SetFrame('Settings')
      end
    })
  })
end

local function mapStateToProps(state)
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
