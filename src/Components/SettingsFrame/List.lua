local Modules = script.Parent.Parent
local Roact = require(Modules.Parent.Libs.Roact)
local Item = require(script.Parent.Item)
local Constants = require(Modules.Parent.Util.Constants)

return function(props)
  local elements = {}

  for i=1, #Constants.SETTINGS do
    local item = Constants.SETTINGS[i]
    elements[item.id] = Roact.createElement(Item, {
      item = item.id,
      plugin = props.plugin,
      isScrollbarShowing = props.isScrollbarShowing
    })
  end

  return Roact.createFragment(elements)
end
