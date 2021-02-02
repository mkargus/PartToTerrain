local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Constants = require(Plugin.Util.Constants)

local Components = Plugin.Components
local ScrollingFrame = require(Components.ScrollingFrame)
local Item = require(script.Item)
local Separator = require(script.Separator)

local SettingsPanel = Roact.PureComponent:extend('SettingsPanel')

function SettingsPanel:init()
  self.state = {
    height = 0
  }

  function self._gridSizeChange(rbx)
    self:setState({
      height = rbx.AbsoluteContentSize.Y
    })
  end
end

function SettingsPanel:ResetLayout()
  self.currentLayout = 0
end

function SettingsPanel:NextLayout()
  self.currentLayout = self.currentLayout + 1
  return self.currentLayout
end

function SettingsPanel:render()
  local props = self.props
  local state = self.state

  self:ResetLayout()

  local children = {
    UIListLayout = Roact.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Vertical,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      Padding = UDim.new(0, 3),
      SortOrder = Enum.SortOrder.LayoutOrder,
      [Roact.Change.AbsoluteContentSize] = self._gridSizeChange
    })
  }

  for key in pairs(Constants.SETTINGS_TABLE) do
    children[key] = Roact.createElement(Item, {
      LayoutOrder = self:NextLayout(),
      Title = key
    })

    children['Separator'..key] = Roact.createElement(Separator, {
      LayoutOrder = self:NextLayout()
    })
  end

  return Roact.createElement(ScrollingFrame, {
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 0, 0, state.height),
    Size = props.Size
  }, children)
end

return SettingsPanel
