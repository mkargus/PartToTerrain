local Material = require(script.Material)
local Panel = require(script.Panel)

return function(state, action)
  state = state or {}
  return {
    Material = Material(state.Material, action),
    Panel = Panel(state.Panel, action)
  }
end
