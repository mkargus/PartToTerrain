--[[
  A collective set of NavTabs for navigation

  Props:
    table Tabs =
      {string Key, ContentId icon, ContentId outlineIcon}
]]
local TextService = game:GetService('TextService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local Localization = require(Util.Localization)

local Components = Plugin.Components
local Store = require(Components.Store)
local NavTab = require(Components.NavTab)

local Navbar = Roact.PureComponent:extend('Navbar')

function Navbar:init()
  self.state = {
    currentWidth = 0
  }

  function self._onAbsoluteSizeChange(rbx)
    self:setState({
      currentWidth = rbx.AbsoluteSize.X
    })
  end
end

function Navbar:ResetLayout()
  self.currentLayout = 0
end

function Navbar:NextLayout()
  self.currentLayout = self.currentLayout + 1
  return self.currentLayout
end

local function canTextBeDisplayed(tabs, tabSize)
  if #tabs > 0 then
    for _, tab in ipairs(tabs) do
      local textWidth = TextService:GetTextSize(Localization('Button.'..tab.key), 14, Enum.Font.Gotham, Vector2.new(100000, 20)).X
      local totalWidth = Constants.TAB_ICON_SIZE + Constants.TAB_INNER_PADDING + textWidth

      if totalWidth >= tabSize then
        return false
      end

    end
  end

  return true
end

function Navbar:render()
  local props = self.props
  local state = self.state

  self:ResetLayout()

  local children = {
    UIListLayout = Roact.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Horizontal,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      SortOrder = Enum.SortOrder.LayoutOrder
    })
  }

  local textDisplayed = canTextBeDisplayed(props.Tabs, state.currentWidth / # props.Tabs)

  for _, tab in ipairs (props.Tabs) do
    children[tab.key] = Roact.createElement(NavTab, {
        Key = tab.key,
        isSelected = state.Panel == tab.key,
        widthScale = 1 / #props.Tabs,
        Icon = tab.icon,
        OutlineIcon = tab.outlineIcon,
        displayText = textDisplayed,
        LayoutOrder = self:NextLayout()
      })
  end

  return Roact.createElement('Frame', {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 28),
    [Roact.Change.AbsoluteSize] = self._onAbsoluteSizeChange
  }, children)

end

return Store:Roact(Navbar, { 'Panel' })
