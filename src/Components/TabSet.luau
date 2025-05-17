local TAB_ICON_SIZE = 20
local TAB_INNER_PADDING = 6
local TAB_OUTER_PADDING = 2

local TextService = game:GetService('TextService')

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Tab = require(Plugin.Components.Tab)

local createNextOrder = require(Plugin.Util.createNextOrder)

type Props = {
  AutomaticSize: Enum.AutomaticSize?,
  LayoutOrder: number?,
  SelectedTab: string?,
  Size: UDim2?,
  Tabs: {{
    Disabled: boolean?,
    Key: string,
    Icon: string,
    Text: string,
  }},

  OnTabSelected: (tab: string) -> ()?
}

local function canTextBeDisplayed(tabs, tabSize): boolean
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

local function TabSet(props: Props)
  local currentWidth, setWidth = React.useState(0)

  local onTabSelected = React.useCallback(function(key: string)
    if props.OnTabSelected then
      props.OnTabSelected(key)
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
  } :: any

  local textDisplayed = canTextBeDisplayed(props.Tabs, currentWidth / #props.Tabs)

  for _, tab in props.Tabs do
    children[tab.Key] = React.createElement(Tab, {
      Disabled = tab.Disabled,
      DisplayText = textDisplayed,
      Icon = tab.Icon,
      LayoutOrder = nextOrder(),
      Selected = props.SelectedTab == tab.Key,
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
  }, {
    Elements = React.createElement(React.Fragment, nil, children)
  })
end

return TabSet
