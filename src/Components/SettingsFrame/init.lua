local Modules = script.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local ScrollingFrame = require(Modules.ScrollingFrame)
local List = require(script.List)

local SettingsFrame = Roact.PureComponent:extend('SettingsFrame')

function SettingsFrame:init()
  self.state = {
    height = 0,
    isScrollbarShowing = false
  }

  function self._gridSizeChange(rbx)
    self:setState({
      height = rbx.AbsoluteContentSize.Y
    })

    -- For some reason, the main body won't listen to events. I'll look for a fix later.
    local bodyFrame = rbx.Parent
    self:setState({
      isScrollbarShowing = (bodyFrame.CanvasSize.Y.Offset > bodyFrame.AbsoluteSize.Y)
    })
  end

end

function SettingsFrame:render()
  local props = self.props
  local state = self.state

  return Roact.createElement(ScrollingFrame, {
    CanvasSize = UDim2.new(0,0,0,state.height),
    Position = UDim2.new(0,5,0,30),
    Size = props.Size
  }, {
    Grid = Roact.createElement('UIListLayout', {
      Padding = UDim.new(0,5),
      [Roact.Change.AbsoluteContentSize] = self._gridSizeChange
    }),
    Items = Roact.createElement(List, {
      plugin = props.plugin,
      isScrollbarShowing = state.isScrollbarShowing
    })
  })
end

return SettingsFrame
