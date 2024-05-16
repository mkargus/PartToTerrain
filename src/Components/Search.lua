local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Localization = require(Plugin.Util.Localization)

local useTheme = require(Plugin.Hooks.useTheme)

local function Search(props)
  local theme = useTheme()
  local TextBoxRef = React.useRef(nil)
  local isFocus, setFocus = React.useState(false)
  local isHover, setHover = React.useState(false)

  local onMouseButton1Click = React.useCallback(function()
    TextBoxRef.current:CaptureFocus()
  end, {})

  local onMouseEnter = React.useCallback(function()
    setHover(true)
  end, {})

  local onMouseLeave = React.useCallback(function()
    setHover(false)
  end, {})

  local onFocused = React.useCallback(function()
    setFocus(true)
  end, {})

  local onFocusLost = React.useCallback(function()
    setFocus(false)
  end, {})

  local Modifier = Enum.StudioStyleGuideModifier.Default
  if isFocus then
    Modifier = Enum.StudioStyleGuideModifier.Selected
  elseif isHover then
    Modifier = Enum.StudioStyleGuideModifier.Hover
  end

  return React.createElement('ImageButton', {
    AutoButtonColor = false,
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, Modifier),
    BorderSizePixel = 0,
    Position = props.Position,
    Size = UDim2.new(1, -7, 0, 26),
    [React.Event.MouseButton1Click] = onMouseButton1Click,
    [React.Event.MouseEnter] = onMouseEnter,
    [React.Event.MouseLeave] = onMouseLeave
  }, {
    UICorner = React.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3)
    }),

    Container = React.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground, Modifier),
      Position = UDim2.fromOffset(1, 1),
      Size = UDim2.new(1, -2, 1, -2)
    }, {
      UICorner = React.createElement('UICorner', {
        CornerRadius = UDim.new(0, 3)
      }),

      Icon = React.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
        Image = 'rbxassetid://5927945389',
        ImageRectSize = Vector2.new(96, 96),
        Size = UDim2.fromOffset(24, 24)
      }),

      Input = React.createElement('TextBox', {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        PlaceholderText = Localization('Plugin.Search'),
        PlaceholderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
        Position = UDim2.fromOffset(24, 0),
        Size = UDim2.new(1, -24, 1, 0),
        Text = props.Text or '',
        TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
        TextSize = 14,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ref = TextBoxRef,
        [React.Event.Focused] = onFocused,
        [React.Event.FocusLost] = onFocusLost,
        [React.Change.Text] = props.onTextChange
      })
    })
  })
end

return Search
