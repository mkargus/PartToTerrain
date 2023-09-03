local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Constants = require(Plugin.Util.Constants)

local Components = Plugin.Components
local Item = require(script.Item)
local ScrollingFrame = require(Components.ScrollingFrame)
local Separator = require(script.Separator)

local SettingsPanel = Roact.PureComponent:extend('SettingsPanel')

function SettingsPanel:ResetLayout()
  self.currentLayout = 0
end

function SettingsPanel:NextLayout()
  self.currentLayout = self.currentLayout + 1
  return self.currentLayout
end

function SettingsPanel:render()
  local props = self.props

  self:ResetLayout()

  local children = {
    UIListLayout = Roact.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Vertical,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      Padding = UDim.new(0, 3),
      SortOrder = Enum.SortOrder.LayoutOrder
    })
  }

  for _, key in Constants.SETTINGS_TABLE do
    children[key] = Roact.createElement(Item, {
      LayoutOrder = self:NextLayout(),
      Title = key
    })

    children['Separator'..key] = Roact.createElement(Separator, {
      LayoutOrder = self:NextLayout()
    })
  end

  return Roact.createElement(ScrollingFrame, {
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Size = props.Size
  }, children)
end

return SettingsPanel
