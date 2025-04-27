local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)

local Util = Plugin.Util
local Localization = require(Util.Localization)
local Settings = require(Util.Settings)

local Components = Plugin.Components
local TextLabel = require(Components.TextLabel)
local ToggleButton = require(Components.ToggleButton)

local useTheme = require(Plugin.Hooks.useTheme)

local function SettingsItem(props)
  local theme = useTheme()
  local currentSettingValue, setSettingValue = React.useState(Settings:Get(props.Title))

  React.useEffect(function()
    local updatedCleanup = Settings:onUpdate(props.Title, function(value)
      setSettingValue(value)
    end)

    return function()
      updatedCleanup()
    end
  end, {})

  return React.createElement('Frame', {
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    LayoutOrder = props.LayoutOrder,
    Size = UDim2.fromScale(0.95, 0),
  }, {
    UIListLayout = React.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Vertical,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      Padding = UDim.new(0, 3),
      SortOrder = Enum.SortOrder.LayoutOrder,
    }),

    Top = React.createElement('Frame', {
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      Size = UDim2.fromScale(1, 0),
    }, {
      Title = React.createElement(TextLabel, {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        Size = UDim2.new(1, -43, 0, 24),
        Text = Localization('Settings.' .. props.Title),
        TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
        TextSize = 16,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
      }),

      Toggle = React.createElement(ToggleButton, {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Selected = currentSettingValue,
        OnClick = function()
          Settings:Set(props.Title, not currentSettingValue)
        end,
      }),
    }),

    Description = React.createElement(TextLabel, {
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      LineHeight = 1.2,
      LayoutOrder = 1,
      Position = UDim2.fromOffset(0, 30),
      Size = UDim2.fromScale(1, 0),
      Text = Localization('Settings.' .. props.Title .. 'Desc'),
      TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText),
      TextSize = 14,
      TextWrapped = true,
      TextXAlignment = Enum.TextXAlignment.Left,
      RichText = true,
    }),
  })
end

return SettingsItem
