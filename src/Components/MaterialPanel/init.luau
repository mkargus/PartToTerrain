local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Constants = require(Plugin.Util.Constants)
local Store = require(Plugin.Util.Store)

local MaterialGridItem = require(script.MaterialGridItem)
local ScrollingFrame = require(Plugin.Components.ScrollingFrame)
local Search = require(Plugin.Components.Search)

local useStore = require(Plugin.Hooks.useStore)

local function MaterialPanel(_props)
  local currentMaterial: Enum.Material = useStore('Material')
  local searchTerm: string = useStore('SearchTerm')

  local content, assetCount = React.useMemo(function()
    local numberAssets = 0
    local assetsToDisplay = {}

    for _, material in Constants.MATERIALS do
      if string.find(string.lower(material.Name), string.lower(searchTerm), 1, true) then
        assetsToDisplay[material.Name] = React.createElement(MaterialGridItem, {
          Material = material,
          Selected = currentMaterial == material,
          OnClick = function()
            Store:Set('Material', material)
          end,
        })

        numberAssets += 1
      end
    end

    return assetsToDisplay, numberAssets
  end, { currentMaterial, searchTerm } :: { unknown })

  local hasAssets = assetCount ~= 0

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
        Text = Store:Get('SearchTerm'),
        OnTextChange = function(rbx)
          Store:Set('SearchTerm', rbx.Text)
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
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3),
      }),
      Items = React.createElement(React.Fragment, nil, content),
    }),
  })
end

return MaterialPanel
