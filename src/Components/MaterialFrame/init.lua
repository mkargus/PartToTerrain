local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)
local ScrollingFrame = require(Modules.ScrollingFrame)
local MaterialItem = require(script.Item)
local Constants = require(Modules.Parent.Util.Constants)

local MaterialFrame = Roact.PureComponent:extend('MaterialFrame')

function MaterialFrame:init()
  self.state = {
    height = 0
  }

  self._gridSizeChange = function(rbx)
    self:setState({
      height = rbx.AbsoluteContentSize.Y
    })
  end

end

function MaterialFrame:render()
  local props = self.props

  return Roact.createElement(ScrollingFrame, {
    CanvasSize = UDim2.new(0,0,0,self.state.height),
    Position = UDim2.new(0,5,0,30),
    Size = props.Size
  }, {
    Grid = Roact.createElement('UIGridLayout', {
      CellPadding = Constants.MATERIAL_GRID_PADDING,
      CellSize = Constants.MATERIAL_GRID_SIZE,
      [Roact.Change.AbsoluteContentSize] = self._gridSizeChange
    }),
    Items = Roact.createElement(MaterialItem, {
      MaterialSelected = props.MaterialSelected
    })
  })
end

return MaterialFrame
