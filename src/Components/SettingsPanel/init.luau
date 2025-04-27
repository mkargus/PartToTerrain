local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Util = Plugin.Util
local createNextOrder = require(Util.createNextOrder)
local Constants = require(Util.Constants)
local Localization = require(Util.Localization)

local useTheme = require(Plugin.Hooks.useTheme)

local Components = Plugin.Components
local Item = require(script.Item)
local ScrollingFrame = require(Components.ScrollingFrame)
local Separator = require(script.Separator)
local TextLabel = require(Components.TextLabel)

local function SettingsPanel(_props)
  local theme = useTheme()
  local NextOrder = createNextOrder()

  local children = {
    UIListLayout = React.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Vertical,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      Padding = UDim.new(0, 3),
      SortOrder = Enum.SortOrder.LayoutOrder,
    }),
    VersionText = React.createElement(TextLabel, {
      BackgroundTransparency = 1,
      TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
      Text = Localization('Plugin.Version', { Constants.VERSION }),
      Size = UDim2.new(1, 0, 0, 14),
      LayoutOrder = 1000,
    }),
  }

  for _, key in Constants.SETTINGS_TABLE do
    children[key] = React.createElement(Item, {
      LayoutOrder = NextOrder(),
      Title = key,
    })

    children['Separator' .. key] = React.createElement(Separator, {
      LayoutOrder = NextOrder(),
    })
  end

  return React.createElement(ScrollingFrame, {
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Size = UDim2.fromScale(1, 1),
  }, children)
end

return SettingsPanel
