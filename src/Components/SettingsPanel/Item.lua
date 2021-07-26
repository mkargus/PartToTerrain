local Plugin = script.Parent.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Localization = require(Plugin.Util.Localization)

local PluginSettings = require(Plugin.Context.PluginSettings)

local Components = Plugin.Components
local StudioTheme = require(Components.StudioTheme)
local TextLabel = require(Components.TextLabel)
local ToggleButton = require(Components.ToggleButton)

local SettingsItem = Roact.PureComponent:extend('SettingsItem')

function SettingsItem:render()
  local props = self.props

  return PluginSettings.with(function(settings)
    return StudioTheme.withTheme(function(theme)
      return Roact.createElement('Frame', {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0.95, 0, 0, 0),
        LayoutOrder = props.LayoutOrder
      }, {
        Title = Roact.createElement(TextLabel, {
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          Font = Enum.Font.GothamBold,
          Size = UDim2.new(0.8, 0, 0, 24),
          Text = Localization('Settings.'..props.Title),
          TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
          TextSize = 16,
          TextWrapped = true,
          TextXAlignment = Enum.TextXAlignment.Left,
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

        Description = Roact.createElement(TextLabel, {
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          LineHeight = 1.2,
          Position = UDim2.new(0, 0, 0, 30),
          Size = UDim2.new(1, 0, 0, 0),
          Text = Localization('Settings.'..props.Title..'Desc'),
          TextColor3 = theme:GetColor('SubText'),
          TextSize = 12,
          TextWrapped = true,
          TextXAlignment = Enum.TextXAlignment.Left,
          RichText = true
        })

      })
    end)
  end)

end

return SettingsItem
