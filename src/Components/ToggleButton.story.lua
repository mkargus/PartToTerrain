local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local ToggleButton = require(Plugin.Components.ToggleButton)

local Wrapper = Roact.Component:extend('ToggleButtonWrapper')

function Wrapper:init()
  self.state = {
    enabled = false
  }

  function self.OnClick()
    self:setState({ enabled = not self.state.enabled })
  end
end

function Wrapper:render()
  return Roact.createElement(ToggleButton, {
    isEnabled = self.state.enabled,
    onClick = self.OnClick
  })
end

return function(target)
  local element = Roact.createElement(Wrapper)
  local handle = Roact.mount(element, target)
  return function()
    Roact.unmount(handle)
  end
end
