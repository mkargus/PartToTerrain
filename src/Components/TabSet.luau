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

local TAB_ICON_SIZE = 24
local TAB_INNER_PADDING = 6
local TAB_OUTER_PADDING = 2

local TextService = game:GetService('TextService')

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Tab = require(Plugin.Components.Tab)

local createNextOrder = require(Plugin.Util.createNextOrder)

local function CanTextBeDisplayed(tabs, tabSize)
  if #tabs > 0 then
    for _, tab in tabs do
      local textWidth = TextService:GetTextSize(tab.Text, 16, Enum.Font.BuilderSansBold, Vector2.new(100000, 20)).X
      local totalWidth = TAB_ICON_SIZE + TAB_INNER_PADDING + textWidth + (TAB_OUTER_PADDING * 2)

      if totalWidth >= tabSize then
        return false
      end
    end
  end

  return true
end

local function TabSet(props)
  local currentWidth, setWidth = React.useState(0)

  local onTabSelected = React.useCallback(function(key: string)
    if props.onTabSelected then
      props.onTabSelected(key)
    end
  end, {})

  local onAbsoluteSizeChange = React.useCallback(function(rbx: Frame)
    setWidth(rbx.AbsoluteSize.X)
  end, {})

  local nextOrder = createNextOrder()

  local children = {
    UIListLayout = React.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Horizontal,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      SortOrder = Enum.SortOrder.LayoutOrder,
    }),
  }

  local textDisplayed = CanTextBeDisplayed(props.Tabs, currentWidth / #props.Tabs)

  for _, tab in props.Tabs do
    children[tab.Key] = React.createElement(Tab, {
      Disabled = tab.Disabled,
      Selected = props.CurrentTab == tab.Key,
      Icon = tab.Icon,
      DisplayText = textDisplayed,
      LayoutOrder = nextOrder(),
      Text = tab.Text,
      OnClick = function()
        onTabSelected(tab.Key)
      end,
    })
  end

  return React.createElement('Frame', {
    AutomaticSize = props.AutomaticSize,
    BackgroundTransparency = 1,
    LayoutOrder = props.LayoutOrder,
    Size = props.Size,
    [React.Change.AbsoluteSize] = onAbsoluteSizeChange,
  }, children)
end

return TabSet
