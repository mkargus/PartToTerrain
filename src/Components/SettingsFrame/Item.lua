local Modules = script.Parent.Parent
local Roact = require(Modules.Parent.Roact)
local StudioTheme = require(Modules.StudioTheme)
-- local TextLabel = require(Modules.TextLabel)
local ThemedTextLabel = require(Modules.ThemedTextLabel)
local Localization = require(Modules.Localization)
local TextButton = require(Modules.TextButton)

local TextService = game:GetService("TextService")

local SettingsItem = Roact.PureComponent:extend('SettingsItem')

function SettingsItem:init()
  self.state = {
    height = 120,
    isExpanded = false
  }

  self._expand = function()
    self:setState({
      isExpanded = not self.state.isExpanded
    })
  end

  self._autoSize = function(rbx)
    local width = rbx.AbsoluteSize.X
    local tb = TextService:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(width, 100000))
    rbx.Size = UDim2.new(1,0,0,tb.Y+5)

    self:setState({
      height = 30 + rbx.AbsoluteSize.Y + 45
    })
  end

end

function SettingsItem:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BorderSizePixel = 0,
      ClipsDescendants = true,
      Size = state.isExpanded and UDim2.new(1,0,0,state.height) or UDim2.new(1,0,0,30)
    }, {
      Button = Roact.createElement(TextButton, {
        Text = '',
        Size = UDim2.new(1,0,0,30),
        MouseClick = self._expand
      }),
      Title = Roact.createElement(ThemedTextLabel, {
        BackgroundTransparency = 1,
        Position = UDim2.new(0,2,0,2),
        Size = UDim2.new(1,-30,0,26),
        Text = Localization('Settings.'..props.item),
        -- TextColor3 = theme:GetColor('MainText'),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = 'Left',
        ZIndex = 2
      }),
      -- ! Image clips through the scrollbar.
      Image = Roact.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(1,-26,0,2),
        Size = UDim2.new(0,24,0,24),
        Image = 'rbxasset://textures/ui/LuaChat/icons/ic-back@2x.png',
        ImageColor3 = theme:GetColor('SubText'),
        Rotation = state.isExpanded and 90 or 270,
        ZIndex = 2
      }),
      -- Desc = Roact.createElement('TextLabel', {
      --   BackgroundColor3 = theme:GetColor('CategoryItem'),
      --   BackgroundTransparency = 0,
      --   BorderSizePixel = 0,
      --   Font = 'SourceSans',
      --   Position = UDim2.new(0,0,0,30),
      --   Size = UDim2.new(1,0,0,0),
      --   Text = Localization('Settings.'..props.item..'Desc'),
      --   TextColor3 = theme:GetColor('MainText'),
      --   TextSize = 14,
      --   TextWrapped = true,
      --   TextXAlignment = 'Left',
      --   [Roact.Change.AbsoluteSize] = self._autoSize,
      --   [Roact.Change.TextBounds] = self._autoSize
      -- }),

      Desc2 = Roact.createElement(ThemedTextLabel, {
        AutoSize = true,
        BackgroundColor3 = theme:GetColor('CategoryItem'),
        Position = UDim2.new(0,0,0,30),
        Size = UDim2.new(1,0,0,0),
        Text = Localization('Settings.'..props.item..'Desc'),
        -- TextColor3 = theme:GetColor('MainText'),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = 'Left',
      }),

    })
  end)
end

return SettingsItem
