local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)
local ScrollingFrame = require(Modules.ScrollingFrame)
local MaterialItem = require(script.Item)

local MaterialFrame = Roact.PureComponent:extend('MaterialFrame')

function MaterialFrame:init()
  self.state = {
    height = 0
  }
end

function MaterialFrame:render()
  local props = self.props
  return Roact.createElement(ScrollingFrame, {
    CanvasSize = UDim2.new(0,0,0,self.state.height),
    Position = UDim2.new(0,5,0,30),
    Size = props.Size
  }, {
    Grid = Roact.createElement('UIGridLayout', {
      CellPadding = UDim2.new(0,5,0,5),
      CellSize = UDim2.new(0,45,0,45),
      [Roact.Change.AbsoluteContentSize] = function(rbx)
        self:setState({
          height = rbx.AbsoluteContentSize.Y
        })
      end
    }),
    Items = Roact.createElement(MaterialItem, {
      items = props.Items
    })
  })
end

return MaterialFrame
