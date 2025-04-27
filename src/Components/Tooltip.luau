-- Based off of the Rojo's tooltip.
-- https://github.com/rojo-rbx/rojo/blob/master/plugin/src/App/Components/Tooltip.lua
local HttpService = game:GetService('HttpService')
local TextSerice = game:GetService('TextService')

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Components = Plugin.Components
local TextLabel = require(Components.TextLabel)

local useTheme = require(Plugin.Hooks.useTheme)

local PADDING = 3
local SHOW_DELAY_TIME = 0.5
local OFFSET = Vector2.new(13, 5)

local TooltipContext = React.createContext({})

-- Popup
local function Popup(props)
  local theme = useTheme()

  local TextSize = TextSerice:GetTextSize(props.Text, 14, Enum.Font.Gotham, Vector2.new(160, math.huge))

  local tooltipWidth = TextSize.X + (2 * PADDING)
  local tooltipHeight = TextSize.Y + (2 * PADDING)

  local targetX = props.Position.X + OFFSET.X
  local targetY = props.Position.Y + OFFSET.Y

  if targetX + tooltipWidth >= props.Size.X then
    targetX = props.Size.X - tooltipWidth
  end

  if targetY + tooltipHeight >= props.Size.Y then
    targetY = props.Size.Y - tooltipHeight
  end

  return React.createElement(TextLabel, {
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Tooltip),
    Position = UDim2.fromOffset(targetX, targetY),
    Size = UDim2.fromOffset(tooltipWidth, tooltipHeight),
    Text = props.Text,
    TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
  }, {
    UICorner = React.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3),
    }),
    UIPadding = React.createElement('UIPadding', {
      PaddingBottom = UDim.new(0, PADDING),
      PaddingLeft = UDim.new(0, PADDING),
      PaddingRight = UDim.new(0, PADDING),
      PaddingTop = UDim.new(0, PADDING),
    }),
    UIStroke = React.createElement('UIStroke', {
      ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
      Color = theme:GetColor(Enum.StudioStyleGuideColor.Border),
    }),
  })
end

-- Provider
local Provider = React.Component:extend('TooltipProvider')

function Provider:init()
  self.state = {
    tips = {},
    addTip = function(id, data)
      self:setState(function(state)
        state.tips[id] = data
        return state
      end)
    end,
    removeTip = function(id)
      self:setState(function(state)
        state.tips[id] = nil
        return state
      end)
    end,
  }
end

function Provider:render()
  return React.createElement(TooltipContext.Provider, {
    value = self.state,
  }, self.props.children)
end

-- Container
local function Container()
  local context = React.useContext(TooltipContext)
  local size, setSize = React.useState(Vector2.one)

  local popups = {}
  local tips = context.tips

  for key, value in tips do
    popups[key] = React.createElement(Popup, {
      Text = value.Text or '',
      Position = value.Position or Vector2.zero,
      Size = size,
    })
  end

  return React.createElement('Frame', {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 1000,
    [React.Change.AbsoluteSize] = function(rbx: Frame)
      setSize(rbx.AbsoluteSize)
    end,
  }, popups)
end

-- Trigger
local Trigger = React.Component:extend('TooltipTrigger')

function Trigger:init()
  self.id = HttpService:GenerateGUID(false)
  self.mousePos = Vector2.zero
end

function Trigger:render()
  local props = self.props

  return React.createElement('Frame', {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 1000,
    [React.Event.MouseMoved] = function(_, x, y)
      self.mousePos = Vector2.new(x, y)
    end,
    [React.Event.MouseEnter] = function()
      self.showDelayThread = task.delay(SHOW_DELAY_TIME, function()
        props.context.addTip(self.id, {
          Text = props.Text,
          Position = self.mousePos,
        })
        self.showDelayThread = nil
      end)
    end,
    [React.Event.MouseLeave] = function()
      if self.showDelayThread then
        pcall(task.cancel, self.showDelayThread)
        self.showDelayThread = nil
      end
      props.context.removeTip(self.id)
    end,
  })
end

function Trigger:componentWillUnmount()
  if self.showDelayThread then
    pcall(task.cancel, self.showDelayThread)
  end
  self.props.context.removeTip(self.id)
end

local function TriggerConsumer(props)
  local context = React.useContext(TooltipContext)

  local innerProps = table.clone(props)
  innerProps.context = context

  return React.createElement(Trigger, innerProps)
end

return {
  Provider = Provider,
  Container = Container,
  Trigger = TriggerConsumer,
}
