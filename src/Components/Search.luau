local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Localization = require(Plugin.Util.Localization)

local useTheme = require(Plugin.Hooks.useTheme)

type Props = {
  Disabled: boolean?,
  Position: UDim2?,
  Text: string?,

  OnTextChange: (rbx: TextBox) -> ()?,
}

local function Search(props: Props)
  local theme = useTheme()
  local textBoxRef = React.useRef(nil :: TextBox?)
  local isFocus, setFocus = React.useState(false)
  local isHover, setHover = React.useState(false)

  local onMouseButton1Click = React.useCallback(function()
    if textBoxRef.current then
      textBoxRef.current:CaptureFocus()
    end
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

  local modifier = Enum.StudioStyleGuideModifier.Default
  if props.Disabled then
    modifier = Enum.StudioStyleGuideModifier.Disabled
  elseif isFocus then
    modifier = Enum.StudioStyleGuideModifier.Selected
    if theme.Name == 'Light' then
      modifier = Enum.StudioStyleGuideModifier.Default
    end
  elseif isHover then
    modifier = Enum.StudioStyleGuideModifier.Hover
  end

  return React.createElement('ImageButton', {
    AutoButtonColor = false,
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, modifier),
    BorderSizePixel = 0,
    Position = props.Position,
    Size = UDim2.fromScale(1, 0),
    [React.Event.MouseButton1Click] = onMouseButton1Click,
    [React.Event.MouseEnter] = onMouseEnter,
    [React.Event.MouseLeave] = onMouseLeave,
  }, {
    UICorner = React.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3),
    }),

    UIPadding = React.createElement('UIPadding', {
      PaddingBottom = UDim.new(0, 1),
      PaddingLeft = UDim.new(0, 1),
      PaddingRight = UDim.new(0, 1),
      PaddingTop = UDim.new(0, 1),
    }),

    Container = React.createElement('Frame', {
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground, modifier),
      Size = UDim2.fromScale(1, 1),
    }, {
      UICorner = React.createElement('UICorner', {
        CornerRadius = UDim.new(0, 3),
      }),

      UIPadding = React.createElement('UIPadding', {
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3),
        PaddingTop = UDim.new(0, 3),
      }),

      UIListLayout = React.createElement('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
      }),

      Icon = React.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText, modifier),
        Image = 'rbxassetid://5927945389',
        ImageRectSize = Vector2.new(96, 96),
        LayoutOrder = 1,
        Size = UDim2.fromOffset(18, 18),
      }),

      Input = React.createElement('TextBox', {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        LayoutOrder = 2,
        Font = Enum.Font.BuilderSans,
        PlaceholderText = Localization('Plugin.Search'),
        PlaceholderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText, modifier),
        Size = UDim2.new(1, 0, 0, 20),
        Text = props.Text or '',
        TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText, modifier),
        TextEditable = not props.Disabled,
        TextSize = 16,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        ref = textBoxRef,
        [React.Event.Focused] = onFocused,
        [React.Event.FocusLost] = onFocusLost,
        [React.Change.Text] = props.OnTextChange,
      }, {
        UIFlexItem = React.createElement('UIFlexItem', {
          FlexMode = Enum.UIFlexMode.Shrink,
        }),
      }),

      -- Clear = React.createElement('ImageButton', {
      --   BackgroundTransparency = 1,
      --   Image = 'http://www.roblox.com/asset/?id=74430943943008',
      --   ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText, modifier),
      --   LayoutOrder = 3,
      --   Size = UDim2.fromOffset(20, 20),
      -- })
    }),
  })
end

return Search
