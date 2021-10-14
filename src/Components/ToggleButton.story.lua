local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local ToggleButton = require(Plugin.Components.ToggleButton)

local Wrapper = Roact.Component:extend('ToggleButtonWrapper')

function Wrapper:init()
  self.state = {
    enabled = false
  }
end

function Wrapper:render()
  return Roact.createElement(ToggleButton, {
    isEnabled = self.state.enabled,
    onClick = function()
      self:setState({ enabled = not self.state.enabled })
    end
  })
end

return function(target)
  local element = Roact.createElement(Wrapper)
  local handle = Roact.mount(element, target)
  return function()
    Roact.unmount(handle)
  end
end
