local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Util = Plugin.Util
local Localization = require(Util.Localization)

local Components = Plugin.Components
local MaterialPanel = require(Components.MaterialPanel)
local SettingsPanel = require(Components.SettingsPanel)
local TextLabel = require(Components.TextLabel)
local Header = require(Components.Header)

local useStore = require(Plugin.Hooks.useStore)
local useTheme = require(Plugin.Hooks.useTheme)

local function App(props)
  local theme = useTheme()
  local CurrentPanel = useStore('Panel')

  local PanelElement = React.useMemo(function()
    if CurrentPanel == 'Materials' then
      return React.createElement(MaterialPanel, {
        Size = props.IsOutdated and UDim2.new(1, 0, 1, -78) or UDim2.new(1, 0, 1, -60)
      })
    elseif CurrentPanel == 'Settings' then
      return React.createElement(SettingsPanel, {
        Size = props.IsOutdated and UDim2.new(1, 0, 1, -53) or UDim2.new(1, 0, 1, -28)
      })
    else
      return React.createElement('TextLabel', {
        Size = UDim2.fromScale(1, 1),
        Text = "You shouldn't be able to see this."
      })
    end
  end, { CurrentPanel })

  return React.createElement('Frame', {
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1)
  }, {
    Header = React.createElement(Header, {
      CurrentPanel = CurrentPanel,
      IsSearchEnabled = CurrentPanel == 'Materials'
    }),

    UIListLayout = React.createElement('UIListLayout', {
      SortOrder = Enum.SortOrder.LayoutOrder
    }),

    Body = PanelElement,

    update = props.IsOutdated and React.createElement(TextLabel, {
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Titlebar),
      LayoutOrder = -1,
      Text = Localization('Notice.Outdated'),
      TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
      TextSize = 12,
      TextWrapped = true,
      Size = UDim2.fromScale(1, 0)
    }, {
      UIPadding = React.createElement('UIPadding', {
        PaddingBottom = UDim.new(0, 3),
        PaddingTop = UDim.new(0, 3)
      })
    })
  })
end

return App
