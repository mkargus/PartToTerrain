local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local TextLabel = require(Plugin.Components.TextLabel)

return function()
  it('should mount and unmount without errors', function()
    local element = Roact.createElement(TextLabel)
    local instance = Roact.mount(element)
    Roact.unmount(instance)
  end)
end
