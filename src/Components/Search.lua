local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local Localization = require(Plugin.Util.Localization)

local useTheme = require(Plugin.Hooks.useTheme)

local function Search(props, hooks)
  local theme = useTheme(hooks)
  local TextBoxRef = hooks.useValue(Roact.createRef())
  local isFocus, setFocus = hooks.useState(false)
  local isHover, setHover = hooks.useState(false)

  local onMouseButton1Click = hooks.useCallback(function()
    TextBoxRef.value:getValue():CaptureFocus()
  end, {})

  local onMouseEnter = hooks.useCallback(function()
    setHover(true)
  end, {})

  local onMouseLeave = hooks.useCallback(function()
    setHover(false)
  end, {})

  local onFocused = hooks.useCallback(function()
    setFocus(true)
  end, {})

  local onFocusLost = hooks.useCallback(function()
    setFocus(false)
  end, {})

  local Modifier = Enum.StudioStyleGuideModifier.Default
  if isFocus then
    Modifier = Enum.StudioStyleGuideModifier.Selected
  elseif isHover then
    Modifier = Enum.StudioStyleGuideModifier.Hover
  end

  return Roact.createElement('ImageButton', {
    AutoButtonColor = false,
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, Modifier),
    BorderSizePixel = 0,
    Position = props.Position,
    Size = UDim2.new(1, -7, 0, 26),
    [Roact.Event.MouseButton1Click] = onMouseButton1Click,
    [Roact.Event.MouseEnter] = onMouseEnter,
    [Roact.Event.MouseLeave] = onMouseLeave
  }, {
    UICorner = Roact.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3)
    }),

    Container = Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground, Modifier),
      Position = UDim2.fromOffset(1, 1),
      Size = UDim2.new(1, -2, 1, -2)
    }, {
      UICorner = Roact.createElement('UICorner', {
        CornerRadius = UDim.new(0, 3)
      }),

      Icon = Roact.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
        Image = 'rbxassetid://5927945389',
        ImageRectSize = Vector2.new(96, 96),
        Size = UDim2.fromOffset(24, 24)
      }),

      Input = Roact.createElement('TextBox', {
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
        [Roact.Ref] = TextBoxRef.value,
        [Roact.Event.Focused] = onFocused,
        [Roact.Event.FocusLost] = onFocusLost,
        [Roact.Change.Text] = props.onTextChange
      })
    })
  })
end

Search = Hooks.new(Roact)(Search)

return Search
