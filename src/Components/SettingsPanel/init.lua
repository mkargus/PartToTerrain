local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Constants = require(Plugin.Util.Constants)

local Components = Plugin.Components
local Item = require(script.Item)
local ScrollingFrame = require(Components.ScrollingFrame)
local Separator = require(script.Separator)

local function CreateNextOrder(): () -> number
  local LayoutOrder = 0

  return function()
    LayoutOrder += 1
    return LayoutOrder
  end
end

local function SettingsPanel(props)
  local NextOrder = CreateNextOrder()

  local children = {
    UIListLayout = React.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Vertical,
      HorizontalAlignment = Enum.HorizontalAlignment.Center,
      Padding = UDim.new(0, 3),
      SortOrder = Enum.SortOrder.LayoutOrder
    })
  }

  for _, key in Constants.SETTINGS_TABLE do
    children[key] = React.createElement(Item, {
      LayoutOrder = NextOrder(),
      Title = key
    })

    children['Separator'..key] = React.createElement(Separator, {
      LayoutOrder = NextOrder()
    })
  end

  return React.createElement(ScrollingFrame, {
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    Size = props.Size
  }, children)
end

return SettingsPanel
