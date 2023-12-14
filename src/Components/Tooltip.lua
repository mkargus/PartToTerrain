--!strict
-- Based off of the Rojo's tooltip.
-- https://github.com/rojo-rbx/rojo/blob/master/plugin/src/App/Components/Tooltip.lua
local HttpService = game:GetService('HttpService')
local TextSerice = game:GetService('TextService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local Components = Plugin.Components
local TextLabel = require(Components.TextLabel)

local useTheme = require(Plugin.Hooks.useTheme)

local PADDING = 3
local SHOW_DELAY_TIME = 0.5
local OFFSET = Vector2.new(13, 5)

local TooltipContext = Roact.createContext({})

type PopupProp = {
  Position: Vector2,
  Size: Vector2,
  Text: string
}

-- Popup
local function Popup(props: PopupProp, hooks)
  local theme = useTheme(hooks)

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

  return Roact.createElement(TextLabel, {
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Tooltip),
    Position = UDim2.fromOffset(targetX, targetY),
    Size = UDim2.fromOffset(tooltipWidth, tooltipHeight),
    Text = props.Text,
    TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText)
  }, {
    UICorner = Roact.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3)
    }),
    UIPadding = Roact.createElement('UIPadding', {
      PaddingBottom = UDim.new(0, PADDING),
      PaddingLeft = UDim.new(0, PADDING),
      PaddingRight = UDim.new(0, PADDING),
      PaddingTop = UDim.new(0, PADDING)
    }),
    UIStroke = Roact.createElement('UIStroke', {
      ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
      Color = theme:GetColor(Enum.StudioStyleGuideColor.Border)
    })
  })
end

Popup = Hooks.new(Roact)(Popup)

-- Provider
local Provider = Roact.Component:extend('TooltipProvider')

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
    end
  }
end

function Provider:render()
  return Roact.createElement(TooltipContext.Provider, {
    value = self.state
  }, self.props[Roact.Children])
end

-- Container
local function Container(_, hooks)
  local context = hooks.useContext(TooltipContext)
  local size, setSize = hooks.useState(Vector2.one)

  local popups = {}
  local tips = context.tips

  for key, value in tips do
    popups[key] = Roact.createElement(Popup, {
      Text = value.Text or '',
      Position = value.Position or Vector2.zero,
      Size = size
    })
  end

  return Roact.createElement('Frame', {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 1000,
    [Roact.Change.AbsoluteSize] = function(rbx: Frame)
      setSize(rbx.AbsoluteSize)
    end
  }, popups)
end

Container = Hooks.new(Roact)(Container)

-- Trigger
local Trigger = Roact.Component:extend('TooltipTrigger')

function Trigger:init()
  self.id = HttpService:GenerateGUID(false)
  self.mousePos = Vector2.zero
end

function Trigger:render()
  local props = self.props

  return Roact.createElement('Frame', {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 1000,
    [Roact.Event.MouseMoved] = function(_, x, y)
      self.mousePos = Vector2.new(x, y)
    end,
    [Roact.Event.MouseEnter] = function()
      self.showDelayThread = task.delay(SHOW_DELAY_TIME, function()
        props.context.addTip(self.id, {
          Text = props.Text,
          Position = self.mousePos
        })
        self.showDelayThread = nil
      end)
    end,
    [Roact.Event.MouseLeave] = function()
      if self.showDelayThread then
        pcall(task.cancel, self.showDelayThread)
        self.showDelayThread = nil
      end
      props.context.removeTip(self.id)
    end
  })
end

local function TriggerConsumer(props, hooks)
  local context = hooks.useContext(TooltipContext)

  local innerProps = table.clone(props)
  innerProps.context = context

  return Roact.createElement(Trigger, innerProps)
end

TriggerConsumer = Hooks.new(Roact)(TriggerConsumer)

return {
  Provider = Provider,
  Container = Container,
  Trigger = TriggerConsumer
}
