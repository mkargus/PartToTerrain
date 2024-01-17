local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local Localization = require(Util.Localization)

local Components = Plugin.Components
local MaterialItem = require(Components.MaterialPanel.Item)
local ScrollingFrame = require(Components.ScrollingFrame)
local TextLabel = require(Components.TextLabel)

local useStore = require(Plugin.Hooks.useStore)
local useTheme = require(Plugin.Hooks.useTheme)

local function MaterialPanel(props, hooks)
  local theme = useTheme(hooks)
  local SearchTerm = useStore(hooks, 'SearchTerm')

  local content, assetCount = hooks.useMemo(function()
    local numberAssets = 0
    local assetsToDisplay = {}

    for _, item in Constants.MATERIALS_TABLE do
      if string.find(string.lower(item.enum.Name), string.lower(SearchTerm), 1, true) then
        assetsToDisplay[item.enum.Name] = Roact.createElement(MaterialItem, {
          Id = item.enum,
          Image = item.img
        })

        numberAssets += 1
      end
    end

    return assetsToDisplay, numberAssets
  end, { SearchTerm })

  local hasAssets = assetCount ~= 0

  return Roact.createElement('Frame', {
    BackgroundTransparency = 1,
    LayoutOrder = 2,
    Size = props.Size
  }, {
    MaterialGrid = hasAssets and Roact.createElement(ScrollingFrame, {
      AutomaticCanvasSize = Enum.AutomaticSize.Y,
      ScrollingDirection = Enum.ScrollingDirection.Y,
      Size = UDim2.fromScale(1, 1)
    }, {
      UIGridLayout = Roact.createElement('UIGridLayout', {
        CellPadding = Constants.MATERIAL_GRID_PADDING,
        CellSize = Constants.MATERIAL_GRID_SIZE,
        FillDirectionMaxCells = 6,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
      }),
      Items = Roact.createFragment(content)
    }),
    NoResults = not hasAssets and Roact.createElement(TextLabel, {
      BackgroundTransparency = 1,
      Size = UDim2.new(1, 0, 0, 30),
      Text = Localization('Notice.NoResultsFound'),
      TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText)
    })
  })
end

MaterialPanel = Hooks.new(Roact)(MaterialPanel)

return MaterialPanel
