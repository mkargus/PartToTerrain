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
local TAB_INNER_PADDING = 3

local TextService = game:GetService('TextService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local Tab = require(Plugin.Components.Tab)

local function CreateNextOrder(): () -> number
  local LayoutOrder = 0

  return function()
    LayoutOrder += 1
    return LayoutOrder
  end
end

local function canTextBeDisplayed(tabs, tabSize)
  if #tabs > 0 then
    for _, tab in tabs do
      local textWidth = TextService:GetTextSize(tab.Text, 14, Enum.Font.Gotham, Vector2.new(100000, 20)).X
      local totalWidth = TAB_ICON_SIZE + TAB_INNER_PADDING + textWidth

      if totalWidth >= tabSize then
        return false
      end

    end
  end

  return true
end

local function TabSet(props, hooks)
  local currentWidth, setWidth = hooks.useState(0)

  local onTabSelected = hooks.useCallback(function(key: string)
    if props.onTabSelected then
      props.onTabSelected(key)
    end
  end, {})

  local onAbsoluteSizeChange = hooks.useCallback(function(rbx: Frame)
    setWidth(rbx.AbsoluteSize.X)
  end, {})

  local NextOrder = CreateNextOrder()

  local children = {
    UIListLayout = Roact.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Horizontal,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      SortOrder = Enum.SortOrder.LayoutOrder
    })
  }

  local textDisplayed = canTextBeDisplayed(props.Tabs, currentWidth / # props.Tabs)

  for _, tab in props.Tabs do
    children[tab.key] = Roact.createElement(Tab, {
      Key = tab.key,
      Active = props.CurrentTab == tab.key,
      WidthScale = 1 / #props.Tabs,
      Icon = tab.icon,
      IsDisplayingText = textDisplayed,
      LayoutOrder = NextOrder(),
      Text = tab.Text,
      onClick = function()
        onTabSelected(tab.key)
      end
    })
  end

  return Roact.createElement('Frame', {
    BackgroundTransparency = 1,
    Size = props.Size,
    [Roact.Change.AbsoluteSize] = onAbsoluteSizeChange
  }, children)
end

TabSet = Hooks.new(Roact)(TabSet)

return TabSet
