local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local TabSet = require(Plugin.Components.TabSet)

return function()
  it('should mount and unmount without errors', function()
    local element = Roact.createElement(TabSet, {
      Tabs = {
        { key = 'Test1' },
        { key = 'Test2' }
      }
    })

    local instance = Roact.mount(element)
    Roact.unmount(instance)
  end)
end
