local BasicState = require(script.Parent.Parent.Libs.BasicState)

local State = BasicState.new({
  Material = Enum.Material.Grass,
  Panel = 'Materials'
})

State.ProtectType = true

return State
