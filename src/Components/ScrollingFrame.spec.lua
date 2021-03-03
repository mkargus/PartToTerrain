local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local ScrollingFrame = require(Plugin.Components.ScrollingFrame)

return function()
  it('should mount and unmount without errors', function()
    local element = Roact.createElement(ScrollingFrame)
    local instance = Roact.mount(element)
    Roact.unmount(instance)
  end)
end
