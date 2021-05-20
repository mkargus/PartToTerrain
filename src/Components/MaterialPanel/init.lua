local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)
local Localization = require(Util.Localization)
local Store = require(Util.Store)

local Components = Plugin.Components
local ScrollingFrame = require(Components.ScrollingFrame)
local TextLabel = require(Components.TextLabel)
local StudioTheme = require(Components.StudioTheme)
local MaterialItem = require(Components.MaterialPanel.Item)

local MaterialPanel = Roact.PureComponent:extend('MaterialPanel')

function MaterialPanel:init()
  self.state = {
    height = 0
  }

  function self._OnContentSizeChange(rbx)
    self:setState({
      height = rbx.AbsoluteContentSize.Y
    })
  end
end

function MaterialPanel:createMaterialButtons(searchTerm)
  local numberAssets = 0

  local assetsToDisplay = {
    UIGridLayout = Roact.createElement('UIGridLayout', {
      CellPadding = Constants.MATERIAL_GRID_PADDING,
      CellSize = Constants.MATERIAL_GRID_SIZE,
      FillDirectionMaxCells = 6,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      [Roact.Change.AbsoluteContentSize] = self._OnContentSizeChange
    })
  }

  for i=1, #Constants.MATERIALS_TABLE do
    local item = Constants.MATERIALS_TABLE[i]

    if string.find(item.enum.Name:lower(), searchTerm:lower(), 1, true) then
      assetsToDisplay[item.enum.Name] = Roact.createElement(MaterialItem, {
        Id = item.enum,
        Image = item.img
      })

      numberAssets = numberAssets + 1
    end

  end

  return assetsToDisplay, numberAssets
end

function MaterialPanel:render()
  local props = self.props
  local state = self.state

  local content, assetCount = self:createMaterialButtons(state.SearchTerm)

  local hasAssets = assetCount ~= 0

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundTransparency = 1,
      LayoutOrder = 2,
      Size = props.Size
    }, {

      MaterialGrid = hasAssets and Roact.createElement(ScrollingFrame, {
        CanvasSize = UDim2.new(0, 0, 0, state.height),
        Size = UDim2.new(1, 0, 1, 0)
      }, content),

      NoResults = not hasAssets and Roact.createElement(TextLabel, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Text = Localization('Notice.NoResultsFound'),
        TextColor3 = theme:GetColor('SubText')
      })

    })
  end)
end

return Store:Roact(MaterialPanel, { 'SearchTerm' })
