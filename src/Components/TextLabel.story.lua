local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local TextLabel = require(Plugin.Components.TextLabel)

local Wrapper = Roact.Component:extend('TextLabelWrapper')

function Wrapper:render()
  return Roact.createElement(TextLabel, {
    Size = UDim2.new(0, 150, 0, 50),
    Text = 'Hello World!'
  })
end

return function(target)
  local element = Roact.createElement(Wrapper)
  local handle = Roact.mount(element, target)
  return function()
    Roact.unmount(handle)
  end
end
