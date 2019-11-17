local Modules = script.Parent.Parent
local Roact = require(Modules.Parent.Roact)
local Localization = require(Modules.Localization)
local TextButton = require(Modules.TextButton)

return function(props)
  local items = props.items
  local elements = {}

  for i=1, #items do
    local item = items[i]
    elements[item.id] = Roact.createElement(TextButton, {
      Text = Localization('Settings.'..item.id),
      Size = UDim2.new(1,0,0,30),
    })
  end

  return Roact.createFragment(elements)
end
