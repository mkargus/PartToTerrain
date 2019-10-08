local Frame = require(script.Frame)
local Material = require(script.Material)

return function(state, action)
  state = state or {}
  return {
    Frame = Frame(state.Frame, action),
    Material = Material(state.Material, action)
  }
end
