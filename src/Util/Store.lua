local BasicState = require(script.Parent.Parent.Packages.BasicState)

local State = BasicState.new({
  Material = Enum.Material.Grass,
  Panel = 'Materials',
  SearchTerm = ''
})

State.ProtectType = true

return State
