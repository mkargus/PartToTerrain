local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)

local Settings = require(Plugin.Util.Settings)

local ToggleButton = require(Plugin.Components.ToggleButton)

local useTheme = require(Plugin.Hooks.useTheme)

type Props = {
  Title: string,
  SettingKey: string,
  Description: string?,
  Disabled: boolean?,
  LayoutOrder: number?,
}

local function SettingsToggleItem(props: Props)
  local theme = useTheme()
  local currentSettingValue, setSettingValue = React.useState(Settings:Get(props.SettingKey))

  local modifier = Enum.StudioStyleGuideModifier.Default
  if props.Disabled then
    modifier = Enum.StudioStyleGuideModifier.Disabled
  end

  return React.createElement('Frame', {
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    LayoutOrder = props.LayoutOrder,
    Size = UDim2.fromScale(1, 0),
  }, {

    Container = React.createElement('Frame', {
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      Size = UDim2.fromScale(1, 0),
    }, {
      UIListLayout = React.createElement('UIListLayout', {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
      }),

      Toggle = React.createElement(ToggleButton, {
        Disabled = props.Disabled,
        LayoutOrder = 1,
        Selected = currentSettingValue,
        OnClick = function(newState)
          Settings:Set(props.SettingKey, newState)
          setSettingValue(newState)
        end
      }),

      TextContainer = React.createElement('Frame', {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
      }, {
        UIListLayout = React.createElement('UIListLayout', {
          Padding = UDim.new(0, 3),
          SortOrder = Enum.SortOrder.LayoutOrder,
        }),

        UIFlexItem = React.createElement('UIFlexItem', {
          FlexMode = Enum.UIFlexMode.Fill,
        }),

        Header = React.createElement('TextLabel', {
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          FontFace = Font.fromEnum(Enum.Font.BuilderSansBold),
          LayoutOrder = 1,
          Size = UDim2.new(1, 0, 0, 18),
          Text = props.Title,
          TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText, modifier),
          TextSize = 16,
          TextWrapped = true,
          TextXAlignment = Enum.TextXAlignment.Left,
          TextYAlignment = Enum.TextYAlignment.Top,
        }),

        Description = props.Description and React.createElement('TextLabel', {
          AutomaticSize = Enum.AutomaticSize.Y,
          BackgroundTransparency = 1,
          FontFace = Font.fromEnum(Enum.Font.BuilderSans),
          LayoutOrder = 2,
          RichText = true,
          Size = UDim2.new(1, 0, 0, 20),
          Text = props.Description,
          TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText, modifier),
          TextSize = 16,
          TextWrapped = true,
          TextXAlignment = Enum.TextXAlignment.Left,
        }),
      }),
    }),
  })
end

return SettingsToggleItem
