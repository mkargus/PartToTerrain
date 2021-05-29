--[[
  A collective set of Tabs for navigation

  Props:
    string CurrentTab
    table Tabs = {
      string Key,
      ContentId icon
      string Text
    }

    function onTabSelected = A callback for when a Tab is selected.
]]
local TextService = game:GetService('TextService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)

local Tab = require(Plugin.Components.Tab)

local TabSet = Roact.PureComponent:extend('TabSet')

function TabSet:init()
  self.state = {
    currentWidth = 0
  }

  function self._onAbsoluteSizeChange(rbx)
    self:setState({
      currentWidth = rbx.AbsoluteSize.X
    })
  end

  function self.onTabSelected(key)
    if self.props.onTabSelected then
      self.props.onTabSelected(key)
    end
  end

end

function TabSet:ResetLayout()
  self.currentLayout = 0
end

function TabSet:NextLayout()
  self.currentLayout = self.currentLayout + 1
  return self.currentLayout
end

local function canTextBeDisplayed(tabs, tabSize)
  if #tabs > 0 then
    for _, tab in ipairs(tabs) do
      local textWidth = TextService:GetTextSize(tab.Text, 14, Enum.Font.Gotham, Vector2.new(100000, 20)).X
      local totalWidth = Constants.TAB_ICON_SIZE + Constants.TAB_INNER_PADDING + textWidth

      if totalWidth >= tabSize then
        return false
      end

    end
  end

  return true
end

function TabSet:render()
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
    children[tab.key] = Roact.createElement(Tab, {

      -- ! ------------------------------
      -- ! READ TAB FOR POSSIBLE CHANGES.
      -- ! ------------------------------

      Key = tab.key,
      Active = props.CurrentTab == tab.key,
      widthScale = 1 / #props.Tabs,
      Icon = tab.icon,
      displayText = textDisplayed,
      LayoutOrder = self:NextLayout(),
      Text = tab.Text,
      onClick = function()
        self.onTabSelected(tab.key)
      end
    })

  end

  return Roact.createElement('Frame', {
    BackgroundTransparency = 1,
    Size = props.Size,
    [Roact.Change.AbsoluteSize] = self._onAbsoluteSizeChange
  }, children)

end

return TabSet
