local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local Store = require(Plugin.Util.Store)
local Localization = require(Plugin.Util.Localization)

local Components = Plugin.Components
local Search = require(Components.Search)
local TabSet = require(Components.TabSet)

local useTheme = require(Plugin.Hooks.useTheme)

local function Header(props, hooks)
  local theme = useTheme(hooks)
  local Height = if props.IsSearchEnabled then 60 else 28

  return Roact.createElement('Frame', {
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Titlebar),
    BorderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border),
    Size = UDim2.new(1, 0, 0, Height)
  }, {
    Navbar = Roact.createElement(TabSet, {
      CurrentTab = props.CurrentPanel,
      Size = UDim2.new(1, 0, 0, 28),
      Tabs = {
        { Key = 'Materials', Icon = 'rbxassetid://5741677639', Text = Localization('Button.Materials') },
        { Key = 'Settings', Icon = 'rbxassetid://5747147099', Text = Localization('Button.Settings') },
      },
      onTabSelected = function(tabName)
        Store:Set('Panel', tabName)
      end
    }),

    Search = props.IsSearchEnabled and Roact.createElement(Search, {
      Position = UDim2.fromOffset(3, 31),
      Text = Store:Get('SearchTerm'),
      onTextChange = function(rbx)
        Store:Set('SearchTerm', rbx.Text)
      end
    })
  })
end

Header = Hooks.new(Roact)(Header)

return Header
