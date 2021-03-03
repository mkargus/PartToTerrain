local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local ToggleButton = require(Plugin.Components.ToggleButton)

return function()
  it('should mount and unmount without errors', function()
    local element = Roact.createElement(ToggleButton)
    local instance = Roact.mount(element)
    Roact.unmount(instance)
  end)
end
