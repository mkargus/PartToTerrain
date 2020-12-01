--[[
  Props:
    string Key
    boolean isSelected
    number widthScale
    ContentId Icon
    ContentId OutlineIcon
    boolean displayText
    int LayoutOrder
]]

local TextService = game:GetService('TextService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Localization = require(Util.Localization)
local Constants = require(Util.Constants)
local Store = require(Util.Store)

local Components = Plugin.Components
local StudioTheme = require(Components.StudioTheme)
local TextLabel = require(Components.TextLabel)


local NavTab = Roact.PureComponent:extend('NavTab')

function NavTab:init()
  self.state = {
    hovering = false
  }

  function self._onMouseButton1Click()
    Store:Set('Panel', self.props.Key)
  end

  function self._onMouseEnter()
    self:setState({ hovering = true })
  end

  function self._onMouseLeave()
    self:setState({ hovering = false })
  end

  self._textWidth = TextService:GetTextSize(Localization('Button.'..self.props.Key), 14, Enum.Font.Gotham, Vector2.new(10000, 20)).X

end

function NavTab:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('TextButton', {
      AutoButtonColor = false,
      BackgroundColor3 = theme:GetColor(props.isSelected and 'Titlebar' or 'Dark'),
      BorderSizePixel = 0,
      LayoutOrder = props.LayoutOrder,
      Size = UDim2.new(props.widthScale, 0, 1, 0),
      Text = '',
      [Roact.Event.MouseButton1Click] = self._onMouseButton1Click,
      [Roact.Event.MouseEnter] = self._onMouseEnter,
      [Roact.Event.MouseLeave] = self._onMouseLeave
    }, {

      UpperBorder = props.isSelected and Roact.createElement('Frame', {
        BackgroundColor3 = Color3.fromRGB(0, 162, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2)
      }),

      Container = Roact.createElement('Frame', {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0)
      }, {
        UIListLayout = Roact.createElement('UIListLayout', {
          FillDirection = Enum.FillDirection.Horizontal,
          HorizontalAlignment = Enum.HorizontalAlignment.Center,
          VerticalAlignment = Enum.VerticalAlignment.Center,
          Padding = UDim.new(0, Constants.TAB_INNER_PADDING),
          SortOrder = Enum.SortOrder.LayoutOrder
        }),
        Icon = Roact.createElement('ImageLabel', {
          BackgroundTransparency = 1,
          Image = props.isSelected and props.Icon or props.OutlineIcon,
          Size = UDim2.new(0, Constants.TAB_ICON_SIZE, 0, Constants.TAB_ICON_SIZE),
          ImageColor3 = theme:GetColor((props.isSelected or state.hovering) and 'MainText' or 'DimmedText')
        }),
        Name = props.displayText and Roact.createElement(TextLabel, {
          BackgroundTransparency = 1,
          Size = UDim2.new(0, self._textWidth, 0, 20),
          Text = Localization('Button.'..props.Key),
          TextColor3 = theme:GetColor((props.isSelected or state.hovering) and 'MainText' or 'DimmedText'),
          TextXAlignment = Enum.TextXAlignment.Left,
          LayoutOrder = 1
        })
      })

    })

  end)

end

return NavTab
