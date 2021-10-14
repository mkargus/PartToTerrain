local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Tooltip = require(Plugin.Components.Tooltip)

local Wrapper = Roact.Component:extend('TooltipWrapper')

function Wrapper:init()
  self.state = {
    IsHovering = false
  }
end

function Wrapper:render()
  return Roact.createElement('ImageLabel', {
    Size = UDim2.new(0, 100, 0, 100),
    [Roact.Event.MouseEnter] = function()
      self:setState({ IsHovering = true })
    end,
    [Roact.Event.MouseLeave] = function()
      self:setState({ IsHovering = false })
    end,
  }, {
    Tooltip = self.state.IsHovering and Roact.createElement(Tooltip, {
      Text = 'Lorem Ipsum'
    })
  })
end

return function(target)
  local element = Roact.createElement(Wrapper)
  local handle = Roact.mount(element, target)
  return function()
    Roact.unmount(handle)
  end
end
