local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Constants = require(Plugin.Util.Constants)
local Localization = require(Plugin.Util.Localization)

local MaterialGridItem = require(script.MaterialGridItem)
local ScrollingFrame = require(Plugin.Components.ScrollingFrame)
local Search = require(Plugin.Components.Search)

local useStore = require(Plugin.Hooks.useStore)
local useTheme = require(Plugin.Contexts.StudioTheme).useTheme

local function MaterialPanel()
  local theme = useTheme()
  local currentMaterial: Enum.Material, setCurrentMaterial = useStore('Material')
  local searchTerm, setSearchTerm = useStore('SearchTerm')

  local filteredMaterials = React.useMemo(function()
    local results = {}
    local normalizedSearch = string.lower(searchTerm)

    for _, material in Constants.MATERIALS do
      if normalizedSearch == '' or string.find(string.lower(material.Name), normalizedSearch, 1, true) then
        table.insert(results, material)
      end
    end

    return results
  end, { searchTerm })

  local items = React.useMemo(function()
    local assetsToDisplay: { [string]: React.ReactNode } = {}

    for _, material in filteredMaterials do
      assetsToDisplay[material.Name] = React.createElement(MaterialGridItem, {
        Material = material,
        Selected = currentMaterial == material,
        OnClick = function()
          setCurrentMaterial(material)
        end,
      })
    end

    return assetsToDisplay
  end, { currentMaterial, filteredMaterials } :: { unknown })

  local hasAssets = #filteredMaterials ~= 0

  return React.createElement(React.Fragment, nil, {
    UIListLayout = React.createElement('UIListLayout', {
      SortOrder = Enum.SortOrder.LayoutOrder,
    }),

    Header = React.createElement('Frame', {
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      LayoutOrder = 1,
      Size = UDim2.fromScale(1, 0),
    }, {
      UIPadding = React.createElement('UIPadding', {
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3),
        PaddingTop = UDim.new(0, 3),
      }),
      Search = React.createElement(Search, {
        PlaceholderText = Localization('Plugin.Search'),
        Text = searchTerm,
        OnTextChange = function(text)
          setSearchTerm(text)
        end,
      }),
    }),

    MaterialSelector = hasAssets and React.createElement(ScrollingFrame, {
      AutomaticCanvasSize = Enum.AutomaticSize.Y,
      LayoutOrder = 3,
      Size = UDim2.fromScale(1, 1),
    }, {
      UIGridLayout = React.createElement('UIGridLayout', {
        CellPadding = Constants.MATERIAL_GRID_PADDING,
        CellSize = Constants.MATERIAL_GRID_SIZE,
        FillDirectionMaxCells = 5,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
      }),

      UIFlexItem = React.createElement('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Shrink,
      }),

      UIPadding = React.createElement('UIPadding', {
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3),
      }),

      Items = React.createElement(React.Fragment, nil, items),
    }),

    NoResultsFound = not hasAssets and React.createElement('TextLabel', {
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      FontFace = Font.fromEnum(Enum.Font.BuilderSans),
      LayoutOrder = 3,
      Size = UDim2.new(1, 0, 0, 30),
      Text = Localization('Notice.NoResultsFound'),
      TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText),
      TextSize = 16,
      TextWrapped = true,
    }),
  })
end

return MaterialPanel
