local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)
local ScrollingFrame = require(Modules.ScrollingFrame)
local SettingItem = require(Modules.Item)

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
    Size = UDim2.new(1,-10,1,-35)
  }, {
    Grid = Roact.createElement('UIListLayout', {
      [Roact.Change.AbsoluteContentSize] = function(rbx)
        self:setState({
          height = rbx.AbsoluteContentSize.Y
        })
      end
    }),
    Items = Roact.createElement(SettingItem, {
      items = props.Items
    })
  })
end

return SettingsFrame
