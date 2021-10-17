local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local ScrollingFrame = require(Plugin.Components.ScrollingFrame)

local Wrapper = Roact.Component:extend('ScrollingFrameWrapper')

function Wrapper:CreateTestBoxes()
  local assetsToDisplay = {
    UIGridLayout = Roact.createElement('UIGridLayout', {
      CellSize = UDim2.new(0, 50, 0, 50),
      [Roact.Change.AbsoluteContentSize] = self._OnContentSizeChange
    })
  }

  for i = 1, 200 do
    assetsToDisplay[i] = Roact.createElement('TextLabel', {
      Text = i
    })
  end

  return assetsToDisplay
end

function Wrapper:render()
  local content = self:CreateTestBoxes()
  return Roact.createElement(ScrollingFrame, {
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0, 0, 0, self.state.height),
    Size = UDim2.new(0, 400, 0, 400)
  }, content)
end

return function(target)
  local element = Roact.createElement(Wrapper)
  local handle = Roact.mount(element, target)
  return function()
    Roact.unmount(handle)
  end
end
