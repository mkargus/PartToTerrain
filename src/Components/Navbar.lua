local Modules = script.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local Store = require(Modules.Store)
local TextButton = require(Modules.TextButton)
local Localization = require(Modules.Parent.Util.Localization)
local StudioTheme = require(Modules.StudioTheme)

local Navbar = Roact.PureComponent:extend('Navbar')

function Navbar:render()
  local activePanel = self.state.Panel

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor('RibbonTab'),
      BorderColor3 = theme:GetColor('Border'),
      Size = UDim2.new(1,0,0,25)
    }, {
      UIListLayout = Roact.createElement('UIListLayout', {
        FillDirection = 'Horizontal',
        HorizontalAlignment = 'Center'
      }),
      Materials = Roact.createElement(TextButton, {
        Selected = activePanel == 'Materials',
        Text = Localization('Button.Materials'),
        Size = UDim2.new(0, 125, 1, 0),
        MouseClick = function()
          Store:Set('Panel', 'Materials')
        end
      }),
      Settings = Roact.createElement(TextButton, {
        Selected = activePanel == 'Settings',
        Text = Localization('Button.Settings'),
        Size = UDim2.new(0, 125, 1, 0),
        MouseClick = function()
          Store:Set('Panel', 'Settings')
        end
      })
    })
  end)
end


return Store:Roact(Navbar, { 'Panel' })
