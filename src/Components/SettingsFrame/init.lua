local Modules = script.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local ScrollingFrame = require(Modules.ScrollingFrame)
local List = require(script.List)
local Constants = require(Modules.Parent.Util.Constants)

local SettingsFrame = Roact.PureComponent:extend('SettingsFrame')

function SettingsFrame:init()
  self.state = {
    height = 0
  }
end

function SettingsFrame:render()
  local props = self.props

  return Roact.createElement(ScrollingFrame, {
    CanvasSize = UDim2.new(0,0,0,self.state.height),
    Position = UDim2.new(0,5,0,30),
    Size = props.Size
  }, {
    Grid = Roact.createElement('UIListLayout', {
      Padding = UDim.new(0,5),
      [Roact.Change.AbsoluteContentSize] = function(rbx)
        self:setState({
          height = rbx.AbsoluteContentSize.Y
        })
      end
    }),
    Items = Roact.createElement(List, {
      items = Constants.SETTINGS,
      plugin = props.plugin
    })
  })
end

return SettingsFrame
