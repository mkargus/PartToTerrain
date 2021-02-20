local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Util = Plugin.Util
local Constants = require(Util.Constants)

local Components = Plugin.Components
local ScrollingFrame = require(Components.ScrollingFrame)

-- Might move this to the root Components folder.
local MaterialItem = require(script.Item)

local MaterialPanel = Roact.PureComponent:extend('MaterialPanel')

function MaterialPanel:init()
  self.state = {
    height = 0
  }

  function self._createElements()
    local elements = {}

    for i=1, #Constants.MATERIALS_TABLE do
      local item = Constants.MATERIALS_TABLE[i]
      elements[item.enum.Name] = Roact.createElement(MaterialItem, {
        Id = item.enum,
        Image = item.img
      })
    end

    return Roact.createFragment(elements)
  end

  function self._gridSizeChange(rbx)
    self:setState({
      height = rbx.AbsoluteContentSize.Y
    })
  end
end

function MaterialPanel:render()
  local props = self.props
  local state = self.state

  return Roact.createElement(ScrollingFrame, {
    CanvasSize = UDim2.new(0, 0, 0, state.height),
    LayoutOrder = 2,
    Size = props.Size
  }, {
    Grid = Roact.createElement('UIGridLayout', {
      CellPadding = Constants.MATERIAL_GRID_PADDING,
      CellSize = Constants.MATERIAL_GRID_SIZE,
      FillDirectionMaxCells = 6,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      [Roact.Change.AbsoluteContentSize] = self._gridSizeChange
    }),
    Items = Roact.createElement(self._createElements)
  })
end

return MaterialPanel
