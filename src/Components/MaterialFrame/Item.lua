local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Libs.Roact)
local RoactRodux = require(Modules.Libs.RoactRodux)
local Actions = require(Modules.Actions)
local Constants = require(Modules.Util.Constants)

local function MaterialItem(props)
  local elements = {}

  for i=1, #Constants.MATERIALS do
    local item = Constants.MATERIALS[i]
    elements[item.enum.Name] = Roact.createElement('ImageButton', {
      BackgroundTransparency = 1,
      Image = item.img,
      [Roact.Event.MouseButton1Click] = function()
        props.SetMaterial(item.enum)
      end
    }, {
      SelectedImage = Roact.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        Image = 'rbxassetid://4507466924',
        Size = UDim2.new(0.5,0,0.5,0),
        Position = UDim2.new(0.5,0,0,0),
        Visible = props.MaterialSelected == item.enum
      })
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
