local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Localization = require(Plugin.Util.Localization)

local StudioTheme = require(Plugin.Components.StudioTheme)

local Search = Roact.PureComponent:extend('Search')

function Search:init()
  self.state = {
    isFocus = false,
    isHover = false
  }

  self.TextBoxRef = Roact.createRef()

  function self._onMouseButton1Click()
    self.TextBoxRef:getValue():CaptureFocus()
  end

  function self._onMouseEnter()
    self:setState({ isHover = true })
  end

  function self._onMouseLeave()
    self:setState({ isHover = false })
  end

  function self._onFocused()
    self:setState({ isFocus = true })
  end

  function self.onFocusLost()
    self:setState({ isFocus = false })
  end
end

function Search:render()
  local props = self.props
  local state = self.state
  local Modifier = 'Default'

  if state.isFocus then
    Modifier = 'Selected'
  elseif state.isHover then
    Modifier = 'Hover'
  end

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('ImageButton', {
      AutoButtonColor = false,
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBorder, Modifier),
      BorderSizePixel = 0,
      Position = props.Position,
      Size = UDim2.new(1, -6, 0, 26),
      [Roact.Event.MouseButton1Click] = self._onMouseButton1Click,
      [Roact.Event.MouseEnter] = self._onMouseEnter,
      [Roact.Event.MouseLeave] = self._onMouseLeave
    }, {
      UICorner = Roact.createElement('UICorner', {
        CornerRadius = UDim.new(0, 3)
      }),

      Container = Roact.createElement('Frame', {
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground, Modifier),
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2)
      }, {
        UICorner = Roact.createElement('UICorner', {
          CornerRadius = UDim.new(0, 3)
        }),

        Icon = Roact.createElement('ImageLabel', {
          BackgroundTransparency = 1,
          ImageColor3 = theme:GetColor('DimmedText'),
          Image = 'rbxassetid://5927945389',
          ImageRectSize = Vector2.new(96, 96),
          Size = UDim2.new(0, 24, 0, 24)
        }),

        Input = Roact.createElement('TextBox', {
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Font = Enum.Font.Gotham,
          PlaceholderText = Localization('Plugin.Search'),
          PlaceholderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
          Position = UDim2.new(0, 24, 0, 0),
          Size = UDim2.new(1, -24, 1, 0),
          Text = props.Text or '',
          TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
          TextSize = 14,
          TextTruncate = 'AtEnd',
          TextXAlignment = Enum.TextXAlignment.Left,
          [Roact.Ref] = self.TextBoxRef,
          [Roact.Event.Focused] = self._onFocused,
          [Roact.Event.FocusLost] = self.onFocusLost,
          [Roact.Change.Text] = props.onTextChange
        })
      })

    })
  end)
end

return Search
