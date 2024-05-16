--[[
  Props:
    string Key
    boolean Active
    number WidthScale
    ContentId Icon
    boolean IsDisplayingText
    int LayoutOrder

    function onClick = A callback when the user clicks this Tab.
]]

local TAB_ICON_SIZE = 24
local TAB_INNER_PADDING = 3

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Components = Plugin.Components
local TextLabel = require(Components.TextLabel)
local Tooltip = require(Components.Tooltip)

local useTheme = require(Plugin.Hooks.useTheme)

local function Tab(props)
  local theme = useTheme()
  local isHovering, setHovering = React.useState(false)

  local onMouseEnter = React.useCallback(function()
    setHovering(true)
  end, {})

  local onMouseLeave = React.useCallback(function()
    setHovering(false)
  end, {})

  local color = theme:GetColor((props.Active or isHovering) and Enum.StudioStyleGuideColor.MainText or Enum.StudioStyleGuideColor.DimmedText)

  return React.createElement('TextButton', {
    AutoButtonColor = false,
    BackgroundColor3 = theme:GetColor(props.Active and Enum.StudioStyleGuideColor.Titlebar or Enum.StudioStyleGuideColor.Dark),
    BorderSizePixel = 0,
    LayoutOrder = props.LayoutOrder,
    Size = UDim2.fromScale(props.WidthScale, 1),
    Text = '',
    [React.Event.MouseButton1Click] = props.onClick,
    [React.Event.MouseEnter] = onMouseEnter,
    [React.Event.MouseLeave] = onMouseLeave
  }, {
    Tooltip = not props.IsDisplayingText and React.createElement(Tooltip.Trigger, {
      Text = props.Text
    }),

    UpperBorder = props.Active and React.createElement('Frame', {
      BackgroundColor3 = Color3.fromRGB(0, 162, 255),
      BorderSizePixel = 0,
      Size = UDim2.new(1, 0, 0, 2)
    }),

    Container = React.createElement('Frame', {
      BackgroundTransparency = 1,
      Size = UDim2.fromScale(1, 1)
    }, {
      UIListLayout = React.createElement('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, TAB_INNER_PADDING),
        SortOrder = Enum.SortOrder.LayoutOrder
      }),
      Icon = React.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        Image = props.Icon,
        Size = UDim2.fromOffset(TAB_ICON_SIZE, TAB_ICON_SIZE),
        ImageColor3 = color
      }),
      Name = props.IsDisplayingText and React.createElement(TextLabel, {
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 20),
        Text = props.Text,
        TextColor3 = color,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1
      })
    })
  })
end

return Tab
