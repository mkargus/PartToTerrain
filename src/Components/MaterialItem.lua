local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)

return function(props)

  local items = props.items
  local elements = {}

  for i=1, #items do
    local item = items[i]

    elements[item.enum] = Roact.createElement('ImageButton', {
      BackgroundTransparency = 1,
      Image = item.img
    })
  end

  return Roact.createFragment(elements)

end
