local React = require(script.Parent.Parent.Packages.React)

local useTheme = require('../Hooks/useTheme')

type Props = {
  Disabled: boolean?,
  DisplayText: boolean?,
  Icon: string?,
  LayoutOrder: number?,
  Selected: boolean?,
  Text: string?,

  OnClick: () -> ()?,
}

local function Tab(props: Props)
  local theme = useTheme()
  local isHover, setHover = React.useState(false)

  local onMouseEnter = React.useCallback(function()
    setHover(true)
  end, {})

  local onMouseLeave = React.useCallback(function()
    setHover(false)
  end, {})

  local onClick = React.useCallback(function()
    if not props.Disabled and props.OnClick then
      props.OnClick()
    end
  end, { props.OnClick, props.Disabled } :: { unknown })

  local iconSize = 20
  if not props.DisplayText then
    iconSize = 24
  end

  local font = Enum.Font.BuilderSans
  if props.Selected then
    font = Enum.Font.BuilderSansBold
  end

  local textColor = Enum.StudioStyleGuideColor.MainText
  local borderColor = Enum.StudioStyleGuideColor.Border

  local modifier = Enum.StudioStyleGuideModifier.Default
  if props.Disabled then
    modifier = Enum.StudioStyleGuideModifier.Disabled
  elseif props.Selected then
    modifier = Enum.StudioStyleGuideModifier.Selected
    if theme.Name == 'Light' then
      textColor = Enum.StudioStyleGuideColor.BrightText
    end
  elseif isHover then
    modifier = Enum.StudioStyleGuideModifier.Hover
  end

  return React.createElement('ImageButton', {
    AutoButtonColor = false,
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.RibbonTab, modifier),
    BorderSizePixel = 0,
    LayoutOrder = props.LayoutOrder,
    [React.Event.MouseButton1Click] = onClick,
    [React.Event.MouseEnter] = onMouseEnter,
    [React.Event.MouseLeave] = onMouseLeave,
  }, {
    UIPadding = React.createElement('UIPadding', {
      PaddingBottom = UDim.new(0, 3),
      PaddingLeft = UDim.new(0, 3),
      PaddingRight = UDim.new(0, 3),
      PaddingTop = UDim.new(0, 3),
    }),

    UIFlexItem = React.createElement('UIFlexItem', {
      FlexMode = Enum.UIFlexMode.Fill,
      ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
    }),

    UIListLayout = React.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Horizontal,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      Padding = UDim.new(0, 6),
      SortOrder = Enum.SortOrder.LayoutOrder,
      VerticalAlignment = Enum.VerticalAlignment.Center,
    }),

    Borders = React.createElement('Folder', nil, {
      Selected = props.Selected and React.createElement('Frame', {
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, 3, 1, 3),
        Size = UDim2.new(1, 6, 1, 6),
      }, {
        Top = React.createElement('Frame', {
          BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.LinkText),
          BorderSizePixel = 0,
          Size = UDim2.new(1, 0, 0, 2),
        }),

        Right = React.createElement('Frame', {
          AnchorPoint = Vector2.new(1, 1),
          BackgroundColor3 = theme:GetColor(borderColor),
          BorderSizePixel = 0,
          Position = UDim2.fromScale(1, 1),
          Size = UDim2.new(0, 2, 1, -2),
        }),

        Left = React.createElement('Frame', {
          AnchorPoint = Vector2.new(0, 1),
          BackgroundColor3 = theme:GetColor(borderColor),
          BorderSizePixel = 0,
          Position = UDim2.fromScale(0, 1),
          Size = UDim2.new(0, 2, 1, -2),
        }),
      }),

      Bottom = not props.Selected and React.createElement('Frame', {
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = theme:GetColor(borderColor),
        BorderSizePixel = 0,
        Position = UDim2.new(0, -3, 1, 3),
        Size = UDim2.new(1, 6, 0, 2),
      }),
    }),

    ImageLabel = React.createElement('ImageLabel', {
      BackgroundTransparency = 1,
      Image = props.Icon,
      ImageColor3 = theme:GetColor(textColor, modifier),
      LayoutOrder = 1,
      Size = UDim2.fromOffset(iconSize, iconSize),
    }),

    TextLabel = props.DisplayText and React.createElement('TextLabel', {
      AutomaticSize = Enum.AutomaticSize.X,
      BackgroundTransparency = 1,
      FontFace = Font.fromEnum(font),
      LayoutOrder = 2,
      Size = UDim2.fromOffset(0, 24),
      Text = props.Text,
      TextColor3 = theme:GetColor(textColor, modifier),
      TextSize = 16,
    }),
  })
end

return Tab
