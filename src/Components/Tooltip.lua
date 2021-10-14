local RunService = game:GetService('RunService')
local TextSerice = game:GetService('TextService')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local PluginGuiWrapper = require(Plugin.Context.PluginGuiWrapper)

local Components = Plugin.Components
local TextLabel = require(Components.TextLabel)
local StudioTheme = require(Components.StudioTheme)

local Tooltip = Roact.PureComponent:extend('Tooltip')

local PADDING = 3
local SHOW_DELAY_TIME = 0.5
local OFFSET = Vector2.new(13, 5)

function Tooltip:init()
  self.state = {
    ShowTooltip = false,
    MousePos = nil
  }

  self.targetTime = nil

  self.connectHover = function()
    self.hoverConnection = RunService.Heartbeat:Connect(function()
      if tick() >= self.targetTime then
        self.disconnectHover()
        self:setState({ ShowTooltip = true })
      end
    end)
  end

  self.disconnectHover = function()
    if self.hoverConnection then
      self.hoverConnection:Disconnect()
    end
  end

  function self.onMouseEnter(_, PosX, PosY)
    self:setState({ MousePos = Vector2.new(PosX, PosY) })
    self.targetTime = tick() + SHOW_DELAY_TIME
    self.connectHover()
  end

  function self.onMouseMoved(_, PosX, PosY)
    if not self.state.ShowTooltip then
      self:setState({ MousePos = Vector2.new(PosX, PosY) })
      self.targetTime = tick() + SHOW_DELAY_TIME
    end
  end

end

function Tooltip:willUnmount()
  self.disconnectHover()
end

function Tooltip:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(theme)
    return PluginGuiWrapper.withFocus(function(pluginGui)

      local content = {}

      if pluginGui and state.MousePos and state.ShowTooltip then

        local targetX = state.MousePos.X + OFFSET.X
        local targetY = state.MousePos.Y + OFFSET.Y

        local TextBound = TextSerice:GetTextSize(props.Text, 14, 'Gotham', Vector2.new(100, 10000))

        local tooltipWidth = TextBound.X + (2 * PADDING)
        local tooltipHeight = TextBound.Y + (2 * PADDING)

        if targetX + tooltipWidth >= pluginGui.AbsoluteSize.X then
          targetX = pluginGui.AbsoluteSize.X - tooltipWidth
        end

        if targetY + tooltipHeight >= pluginGui.AbsoluteSize.Y then
          targetY = pluginGui.AbsoluteSize.Y - tooltipHeight
        end

        content.Tooltip = Roact.createElement(TextLabel, {
          BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Tooltip),
          Position = UDim2.fromOffset(targetX, targetY),
          Size = UDim2.new(0, tooltipWidth, 0, tooltipHeight),
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

          -- selene: allow(roblox_incorrect_roact_usage)
          UIStroke = Roact.createElement('UIStroke', {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = theme:GetColor('Border')
          })
        })

      end

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
  end)
end

return Tooltip
