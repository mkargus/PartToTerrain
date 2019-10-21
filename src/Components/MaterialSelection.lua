local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)
local ScrollingFrame = require(Modules.ScrollingFrame)

local MaterialSelection = Roact.PureComponent:extend('MaterialSelection')

function MaterialSelection:init()
  self.state = {
    height = 0
  }
end

function MaterialSelection:render()
  return Roact.createElement(ScrollingFrame, {
    CanvasSize = UDim2.new(0,0,0,self.state.height),
    Position = UDim2.new(0,5,0,30),
    Size = UDim2.new(1,-10,1,-35)
  }, {
    Grid = Roact.createElement('UIGridLayout', {
      CellPadding = UDim2.new(0,5,0,5),
      CellSize = UDim2.new(0,45,0,45),
      [Roact.Change.AbsoluteContentSize] = function(rbx)
        self:setState({
          height = rbx.AbsoluteContentSize.Y
        })
      end
    })
  })
end

return MaterialSelection
