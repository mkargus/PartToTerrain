local Plugin = script.Parent.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Util = Plugin.Util
local Localization = require(Util.Localization)
local Settings = require(Util.Settings)

local StudioTheme = require(Plugin.Context.StudioTheme)

local Components = Plugin.Components
local TextLabel = require(Components.TextLabel)
local ToggleButton = require(Components.ToggleButton)

local SettingsItem = Roact.PureComponent:extend('SettingsItem')

function SettingsItem:init()
  self.state = {
    setting = Settings:Get(self.props.Title)
  }

  self.updatedCleanup = Settings:onUpdate(self.props.Title, function(value)
    self:setState({ setting = value })
  end)
end

function SettingsItem:render()
  local props = self.props
  local currentSettingValue = self.state.setting

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      BorderSizePixel = 0,
      LayoutOrder = props.LayoutOrder,
      Size = UDim2.fromScale(0.95, 0),
    }, {
      UIListLayout = Roact.createElement('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder
      }),

      Top = Roact.createElement('Frame', {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0)
      }, {
        Title = Roact.createElement(TextLabel, {
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamBold,
          Size = UDim2.new(1, -43, 0, 24),
          Text = Localization('Settings.'..props.Title),
          TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
          TextSize = 16,
          TextWrapped = true,
          TextXAlignment = Enum.TextXAlignment.Left,
        }),

        Toggle = Roact.createElement(ToggleButton, {
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.fromScale(1, 0),
          isEnabled = currentSettingValue,
          onClick = function()
            Settings:Set(props.Title, not currentSettingValue)
          end
        })
      }),

      Description = Roact.createElement(TextLabel, {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LineHeight = 1.2,
        LayoutOrder = 1,
        Position = UDim2.fromOffset(0, 30),
        Size = UDim2.fromScale(1, 0),
        Text = Localization('Settings.'..props.Title..'Desc'),
        TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true
      })
    })
  end)
end

function SettingsItem:willUnmount()
  self.updatedCleanup()
end

return SettingsItem
