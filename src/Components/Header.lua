local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Store = require(Plugin.Util.Store)
local Localization = require(Plugin.Util.Localization)

local Components = Plugin.Components
local StudioTheme = require(Components.StudioTheme)
local Search = require(Components.Search)
local TabSet = require(Components.TabSet)

local Header = Roact.PureComponent:extend('Header')

function Header:render()
  local props = self.props

  local Height = props.IsSearchEnabled and 60 or 28

  return StudioTheme.withTheme(function(theme)

    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor('Titlebar'),
      BorderColor3 = theme:GetColor('Border'),
      Size = UDim2.new(1, 0, 0, Height)
    }, {

      Navbar = Roact.createElement(TabSet, {
        CurrentTab = Store:Get('Panel'),
        Size = UDim2.new(1, 0, 0, 28),
        Tabs = {
          { key = 'Materials', icon = 'rbxassetid://5741677639', Text = Localization('Button.Materials') },
          { key = 'Settings', icon = 'rbxassetid://5747147099', Text = Localization('Button.Settings') },
        },
        onTabSelected = function(tabName)
          Store:Set('Panel', tabName)
        end
      }),

      Search = props.IsSearchEnabled and Roact.createElement(Search, {
        Position = UDim2.new(0, 3, 0, 31),
        Text = Store:Get('SearchTerm'),
        onTextChange = function(rbx)
          Store:Set('SearchTerm', rbx.Text)
        end
      })
    })

  end)
end

return Header
