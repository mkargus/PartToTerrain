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

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local Components = Plugin.Components
local TextLabel = require(Components.TextLabel)
local Tooltip = require(Components.Tooltip)

local useTheme = require(Plugin.Hooks.useTheme)

local function Tab(props, hooks)
  local theme = useTheme(hooks)
  local isHovering, setHovering = hooks.useState(false)

  local onMouseEnter = hooks.useCallback(function()
    setHovering(true)
  end, {})

  local onMouseLeave = hooks.useCallback(function()
    setHovering(false)
  end, {})

  local color = theme:GetColor((props.Active or isHovering) and Enum.StudioStyleGuideColor.MainText or Enum.StudioStyleGuideColor.DimmedText)

  return Roact.createElement('TextButton', {
    AutoButtonColor = false,
    BackgroundColor3 = theme:GetColor(props.Active and Enum.StudioStyleGuideColor.Titlebar or Enum.StudioStyleGuideColor.Dark),
    BorderSizePixel = 0,
    LayoutOrder = props.LayoutOrder,
    Size = UDim2.fromScale(props.WidthScale, 1),
    Text = '',
    [Roact.Event.MouseButton1Click] = props.onClick,
    [Roact.Event.MouseEnter] = onMouseEnter,
    [Roact.Event.MouseLeave] = onMouseLeave
  }, {
    Tooltip = (not props.IsDisplayingText and isHovering) and Roact.createElement(Tooltip, {
      Text = props.Text
    }),

    UpperBorder = props.Active and Roact.createElement('Frame', {
      BackgroundColor3 = Color3.fromRGB(0, 162, 255),
      BorderSizePixel = 0,
      Size = UDim2.new(1, 0, 0, 2)
    }),

    Container = Roact.createElement('Frame', {
      BackgroundTransparency = 1,
      Size = UDim2.fromScale(1, 1)
    }, {
      UIListLayout = Roact.createElement('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, TAB_INNER_PADDING),
        SortOrder = Enum.SortOrder.LayoutOrder
      }),
      Icon = Roact.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        Image = props.Icon,
        Size = UDim2.fromOffset(TAB_ICON_SIZE, TAB_ICON_SIZE),
        ImageColor3 = color
      }),
      Name = props.IsDisplayingText and Roact.createElement(TextLabel, {
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

Tab = Hooks.new(Roact)(Tab)

return Tab
