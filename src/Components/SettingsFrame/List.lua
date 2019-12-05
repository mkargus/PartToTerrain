local Modules = script.Parent.Parent
local Roact = require(Modules.Parent.Roact)
local Item = require(script.Parent.Item)

return function(props)
  local items = props.items
  local elements = {}

  for i=1, #items do
    local item = items[i]
    elements[item.id] = Roact.createElement(Item, {
      item = item.id,
      plugin = props.plugin
    })
  end

  return Roact.createFragment(elements)
end
