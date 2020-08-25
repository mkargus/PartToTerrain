local Modules = script.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local RoactRodux = require(Modules.Parent.Libs.RoactRodux)
local Actions = require(Modules.Parent.Actions)

local TextButton = require(Modules.TextButton)
local Localization = require(Modules.Parent.Util.Localization)
local StudioTheme = require(Modules.StudioTheme)

local Navbar = Roact.PureComponent:extend('Navbar')

function Navbar:render()
  local props = self.props

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.RibbonTab),
      BorderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border),
      Size = UDim2.new(1,0,0,25)
    }, {
      UIListLayout = Roact.createElement('UIListLayout', {
        FillDirection = 'Horizontal',
        Padding = UDim.new(0,0)
      }),
      UIPadding = Roact.createElement('UIPadding', {
        PaddingLeft = UDim.new(0.5, -125)
      }),
      Materials = Roact.createElement(TextButton, {
        Selected = props.ActiveFrame == 'Materials',
        Text = Localization('Button.Materials'),
        Size = UDim2.new(0, 125, 1, 0),
        MouseClick = function()
          props.SetPanel('Materials')
        end
      }),
      Settings = Roact.createElement(TextButton, {
        Selected = props.ActiveFrame == 'Settings',
        Text = Localization('Button.Settings'),
        Size = UDim2.new(0, 125, 1, 0),
        MouseClick = function()
          props.SetPanel('Settings')
        end
      })
    })
  end)
end

local function mapStateToProps()
  return {}
end

local function mapDispatchToProps(dispatch)
  return {
    SetPanel = function(panel)
      dispatch(Actions.SetPanel(panel))
    end
  }
end

return RoactRodux.connect(mapStateToProps,mapDispatchToProps)(Navbar)
