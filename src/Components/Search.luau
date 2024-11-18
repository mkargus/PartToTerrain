local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local useTheme = require(Plugin.Hooks.useTheme)

type Props = {
  PlaceholderText: string,
  Position: UDim2?,
}

local function Search(props: Props)
  local theme = useTheme()

  local textBoxRef = React.useRef(nil)
  local isHover, setHover = React.useState(false)
  local isFocus, setFocus = React.useState(false)

  local onMouseButton1Click = React.useCallback(function()
    textBoxRef.current:CaptureFocus()
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

  local StyleModifier = Enum.StudioStyleGuideModifier.Default
  if isFocus then
    StyleModifier = Enum.StudioStyleGuideModifier.Selected
  elseif isHover then
    StyleModifier = Enum.StudioStyleGuideModifier.Hover
  end

  return React.createElement('ImageButton', {
    AutoButtonColor = false,
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, StyleModifier),
    Size = UDim2.new(1, -41, 0, 30),
    Position = props.Position or UDim2.new(),
    [React.Event.MouseButton1Click] = onMouseButton1Click,
    [React.Event.MouseEnter] = onMouseEnter,
    [React.Event.MouseLeave] = onMouseLeave
  }, {
    UICorner = React.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3),
    }),

    frame = React.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground, StyleModifier),
      Position = UDim2.fromOffset(1, 1),
      Size = UDim2.new(1, -2, 1, -2),
    }, {
      Icon = React.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        Image = 'rbxassetid://109030707998304',
        ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
        Size = UDim2.fromOffset(28, 28),
      }),

      UICorner = React.createElement('UICorner', {
        CornerRadius = UDim.new(0, 3),
      }),

      TextBox = React.createElement('TextBox', {
        BackgroundTransparency = 1,
        FontFace = Font.new('rbxasset://fonts/families/Montserrat.json'),
        PlaceholderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
        PlaceholderText = props.PlaceholderText,
        Position = UDim2.fromOffset(28, 0),
        Size = UDim2.new(1, -28, 1, 0),
        Text = '',
        TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
        TextSize = 16,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ref = textBoxRef,
        [React.Event.Focused] = onFocused,
        [React.Event.FocusLost] = onFocusLost,
        -- [React.Change.Text] = props.onTextChange
      })
    })
  })
end

return Search
