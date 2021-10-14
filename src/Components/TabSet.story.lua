local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local TabSet = require(Plugin.Components.TabSet)

local Wrapper = Roact.Component:extend('TabSetWrapper')

function Wrapper:init()
  self.state = {
    CurrentTab = 'Test1'
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

    MainExample = Roact.createElement(TabSet, {
      CurrentTab = self.state.CurrentTab,
      Size = UDim2.new(1, 0, 0, 28),
      Tabs = {
        { key = 'Test1', icon = 'rbxassetid://5904861868', Text = 'Lorem ipsum' },
        { key = 'Test2', icon = 'rbxassetid://5904861868', Text = 'Lorem ipsum' }
      },
      onTabSelected = self.onTabSelected
    }),

  })
end

return function(target)
  local element = Roact.createElement(Wrapper)
  local handle = Roact.mount(element, target)
  return function()
    Roact.unmount(handle)
  end
end
