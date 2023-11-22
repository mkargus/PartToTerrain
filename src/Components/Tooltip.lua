local TextSerice = game:GetService('TextService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local Context = Plugin.Context
local PluginGuiWrapper = require(Context.PluginGuiWrapper)

local Components = Plugin.Components
local TextLabel = require(Components.TextLabel)

local useTheme = require(Plugin.Hooks.useTheme)

local PADDING = 3
local SHOW_DELAY_TIME = 0.5
local OFFSET = Vector2.new(13, 5)

local function Popup(props, hooks)
  local theme = useTheme(hooks)

  local TextSize = TextSerice:GetTextSize(props.Text, 14, Enum.Font.Gotham, Vector2.new(100, 10000))

  local tooltipWidth = TextSize.X + (2 * PADDING)
  local tooltipHeight = TextSize.Y + (2 * PADDING)

  local targetX = props.Position.X + OFFSET.X
  local targetY = props.Position.Y + OFFSET.Y

  if targetX + tooltipWidth >= props.pluginGui.AbsoluteSize.X then
    targetX = props.pluginGui.AbsoluteSize.X - tooltipWidth
  end

  if targetY + tooltipHeight >= props.pluginGui.AbsoluteSize.Y then
    targetY = props.pluginGui.AbsoluteSize.Y - tooltipHeight
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

local Tooltip = Roact.PureComponent:extend('Tooltip')

function Tooltip:init()
  self.state = {
    ShowTooltip = false
  }

  self.MousePos = Vector2.zero

  self.connectHover = function()
    self.showDelayThread = task.delay(SHOW_DELAY_TIME, function()
      self:setState({ ShowTooltip = true })
      self.showDelayThread = nil
    end)
  end

  self.disconnectHover = function()
    if self.showDelayThread then
      pcall(task.cancel, self.showDelayThread)
    end
  end

  function self.onMouseEnter(_, PosX, PosY)
    self.MousePos = Vector2.new(PosX, PosY)
    self.connectHover()
  end

  function self.onMouseMoved(_, PosX, PosY)
    if not self.state.ShowTooltip then
      self.MousePos = Vector2.new(PosX, PosY)
    end
  end
end

function Tooltip:willUnmount()
  self.disconnectHover()
end

function Tooltip:render()
  local props = self.props
  local state = self.state

  return PluginGuiWrapper.withFocus(function(pluginGui)
    local content = state.ShowTooltip and Roact.createElement(Popup, {
      pluginGui = pluginGui,
      Position = self.MousePos,
      Text = props.Text
    })

    return Roact.createElement(Roact.Portal, {
      target = pluginGui
    }, {
      TopLevelFrame = Roact.createElement('Frame', {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 100000,
        [Roact.Event.MouseEnter] = self.onMouseEnter,
        [Roact.Event.MouseMoved] = self.onMouseMoved
      }, content)
    })
  end)
end

return Tooltip
