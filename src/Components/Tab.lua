--[[
  Props:
    string Key
    boolean Active
    number widthScale
    ContentId Icon
    ? boolean displayText (Possible renaming to 'ShowText')
    int LayoutOrder

    function onClick = A callback when the user clicks this Tab.
]]

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)

local Components = Plugin.Components
local StudioTheme = require(Components.StudioTheme)
local TextLabel = require(Components.TextLabel)
local Tooltip = require(Components.Tooltip)

local Tab = Roact.PureComponent:extend('Tab')

function Tab:init()
  self.state = {
    isHovering = false
  }

  function self._onMouseEnter()
    self:setState({ isHovering = true })
  end

  function self._onMouseLeave()
    self:setState({ isHovering = false })
  end
end

function Tab:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('TextButton', {
      AutoButtonColor = false,
      BackgroundColor3 = theme:GetColor(props.Active and 'Titlebar' or 'Dark'),
      BorderSizePixel = 0,
      LayoutOrder = props.LayoutOrder,
      Size = UDim2.new(props.widthScale, 0, 1, 0),
      Text = '',
      [Roact.Event.MouseButton1Click] = props.onClick,
      [Roact.Event.MouseEnter] = self._onMouseEnter,
      [Roact.Event.MouseLeave] = self._onMouseLeave
    }, {

      UpperBorder = props.Active and Roact.createElement('Frame', {
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
          Image = props.Icon,
          Size = UDim2.new(0, Constants.TAB_ICON_SIZE, 0, Constants.TAB_ICON_SIZE),
          ImageColor3 = theme:GetColor((props.Active or state.hovering) and 'MainText' or 'DimmedText')
        }),
        Name = props.displayText and Roact.createElement(TextLabel, {
          AutomaticSize = Enum.AutomaticSize.X,
          BackgroundTransparency = 1,
          Size = UDim2.new(0, 0, 0, 20),
          Text = props.Text,
          TextColor3 = theme:GetColor((props.Active or state.hovering) and 'MainText' or 'DimmedText'),
          TextXAlignment = Enum.TextXAlignment.Left,
          LayoutOrder = 1
        }),

        Tooltip = (not props.displayText and state.isHovering) and Roact.createElement(Tooltip, {
          Text = props.Text
        })

      })

    })

  end)

end

return Tab
