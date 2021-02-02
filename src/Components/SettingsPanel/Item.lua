local TextServce = game:GetService('TextService')

local Plugin = script.Parent.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Localization = require(Plugin.Util.Localization)

local Components = Plugin.Components
local StudioTheme = require(Components.StudioTheme)
local TextLabel = require(Components.TextLabel)
local ToggleButton = require(Components.ToggleButton)
local PluginSettings = require(Components.PluginSettings)

local SettingsItem = Roact.PureComponent:extend('SettingsItem')

function SettingsItem:init()
  self._Size = TextServce:GetTextSize(Localization('Settings.'..self.props.Title), 16, "Gotham", Vector2.new(150, 1000))
end

function SettingsItem:render()
  local props = self.props

  return PluginSettings.with(function(settings)
    return StudioTheme.withTheme(function(theme)
      return Roact.createElement('Frame', {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0.95, 0, 0, 60),
        LayoutOrder = props.LayoutOrder
      }, {
        Title = Roact.createElement(TextLabel, {
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamBold,
          Text = Localization('Settings.'..props.Title),
          TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
          TextWrapped = true,
          TextSize = 16,
          TextXAlignment = Enum.TextXAlignment.Left,
          Size = UDim2.new(0, 150, 0, 24)
        }),

        Toggle = Roact.createElement(ToggleButton, {
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.new(1, 0, 0, 0),
          isEnabled = settings:Get(props.Title),
          onClick = function()
            local currentValue = settings:Get(props.Title)
            settings:Set(props.Title, not currentValue)
          end
        }),

        DESC = Roact.createElement(TextLabel, {
          BackgroundTransparency = 1,
          TextSize = 12,
          Text = Localization('Settings.'..props.Title..'Desc'),
          TextColor3 = theme:GetColor('SubText'),
          Size = UDim2.new(1, 0, 0, 14),
          Position = UDim2.new(0, 0, 0, 30),
          TextWrapped = true,
          TextXAlignment = Enum.TextXAlignment.Left
        }),

      })
    end)
  end)

end

return SettingsItem
