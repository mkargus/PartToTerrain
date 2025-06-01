local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Util = Plugin.Util
local createNextOrder = require(Util.createNextOrder)
local Constants = require(Util.Constants)
local Localization = require(Util.Localization)

local useTheme = require(Plugin.Hooks.useTheme)

local Components = Plugin.Components
local ScrollingFrame = require(Components.ScrollingFrame)

local SettingsToggleItem = require(script.SettingsToggleItem)

local function SettingsPanel()
  local theme = useTheme()
  local nextOrder = createNextOrder()

  return React.createElement(ScrollingFrame, {
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Size = UDim2.fromScale(1, 1),
  }, {
    UIListLayout = React.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Vertical,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      Padding = UDim.new(0, 6),
      SortOrder = Enum.SortOrder.LayoutOrder,
    }),

    UIPadding = React.createElement('UIPadding', {
      PaddingLeft = UDim.new(0, 3),
      PaddingRight = UDim.new(0, 3),
      PaddingTop = UDim.new(0, 3),
    }),

    PreserveTerrain = React.createElement(SettingsToggleItem, {
      Title = Localization('Settings.PreserveTerrain'),
      LayoutOrder = nextOrder(),
      Description = Localization('Settings.PreserveTerrainDesc'),
      SettingKey = 'PreserveTerrain'
    }),

    DeletePart = React.createElement(SettingsToggleItem, {
      Title = Localization('Settings.DeletePart'),
      LayoutOrder = nextOrder(),
      Description = Localization('Settings.DeletePartDesc'),
      SettingKey = 'DeletePart'
    }),

    EnabledSelectionBox = React.createElement(SettingsToggleItem, {
      Title = Localization('Settings.EnabledSelectionBox'),
      LayoutOrder = nextOrder(),
      Description = Localization('Settings.EnabledSelectionBoxDesc'),
      SettingKey = 'EnabledSelectionBox'
    }),

    IgnoreLockedParts = React.createElement(SettingsToggleItem, {
      Title = Localization('Settings.IgnoreLockedParts'),
      LayoutOrder = nextOrder(),
      Description = Localization('Settings.IgnoreLockedPartsDesc'),
      SettingKey = 'IgnoreLockedParts'
    }),

    IgnoreInvisibleParts = React.createElement(SettingsToggleItem, {
      Title = Localization('Settings.IgnoreInvisibleParts'),
      LayoutOrder = nextOrder(),
      Description = Localization('Settings.IgnoreInvisiblePartsDesc'),
      SettingKey = 'IgnoreInvisibleParts'
    }),

    VersionText = React.createElement('TextLabel', {
      BackgroundTransparency = 1,
      FontFace = Font.fromEnum(Enum.Font.BuilderSans),
      TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
      Text = Localization('Plugin.Version', { Constants.VERSION }),
      TextSize = 16,
      Size = UDim2.new(1, 0, 0, 20),
      LayoutOrder = nextOrder(),
    }),
  })
end

return SettingsPanel
