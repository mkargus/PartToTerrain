local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Roact)
local RoactRodux = require(Modules.RoactRodux)
local Actions = require(Modules.Actions)

local function MaterialItem(props)
  local items = props.items
  local elements = {}

  for i=1, #items do
    local item = items[i]
    elements[item.enum.Name] = Roact.createElement('ImageButton', {
      BackgroundTransparency = 1,
      Image = item.img,
      [Roact.Event.MouseButton1Click] = function()
        props.SetMaterial(item.enum)
      end
    })
  end

  return Roact.createFragment(elements)
end

local function mapStateToProps(state)
  return {}
end

local function mapDispatchToProps(dispatch)
  return {
    SetMaterial = function(mat)
      dispatch(Actions.SetMaterial(mat))
    end
  }
end

return RoactRodux.connect(mapStateToProps,mapDispatchToProps)(MaterialItem)
