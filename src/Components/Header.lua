local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Constants = require(Plugin.Util.Constants)
local Store = require(Plugin.Util.Store)

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
        Tabs = Constants.NAVBAR_TABS,
        onTabSelected = function(tabName)
          Store:Set('Panel', tabName)
        end
      }),

      Search = props.IsSearchEnabled and Roact.createElement(Search, {
        Position = UDim2.new(0, 3, 0, 31),
        onTextChange = function(rbx)
          Store:Set('SearchTerm', rbx.Text)
        end
      })
    })

  end)
end

return Header
