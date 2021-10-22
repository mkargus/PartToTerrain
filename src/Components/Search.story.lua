local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Search = require(Plugin.Components.Search)

local Wrapper = Roact.Component:extend('SearchWrapper')

function Wrapper:init()
  self.state = {
    CurrentText = ''
  }

  function self.onTabSelected(tabName)
    self:setState({ CurrentTab = tabName })
  end
end

function Wrapper:render()
  return Roact.createElement('Frame', {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1)
  }, {
    Search = Roact.createElement(Search, {
      onTextChange = function(rbx)
        self:setState({ CurrentText = rbx.Text })
      end
    }),

    Test = Roact.createElement('TextLabel', {
      AutomaticSize = Enum.AutomaticSize.XY,
      Position = UDim2.new(0, 0, 0, 32),
      Text = 'Input: ' ..self.state.CurrentText
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
