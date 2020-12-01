local Plugin = script.Parent.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Store = require(Plugin.Util.Store)

local MaterialButton = Roact.PureComponent:extend('MaterialButton')

function MaterialButton:render()
  local props = self.props
  local state = self.state

  local MatchedTerm = props.Id.Name:lower():find(state.SearchTerm:lower())

  return MatchedTerm and Roact.createElement('ImageButton', {
    BackgroundTransparency = 1,
    Image = props.Image,
    [Roact.Event.MouseButton1Click] = function()
      Store:Set('Material', props.Id)
    end
  }, {
    UICorner = Roact.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3)
    }),
    SelectedImage = state.Material == props.Id and Roact.createElement('ImageLabel', {
      AnchorPoint = Vector2.new(1, 0),
      BackgroundTransparency = 1,
      Image = 'rbxassetid://4507466924',
      Position = UDim2.new(1, 0, 0, 0),
      Size = UDim2.new(0.5, 0, 0.5, 0),
    })
  })
end

return Store:Roact(MaterialButton, { 'Material', 'SearchTerm' })
