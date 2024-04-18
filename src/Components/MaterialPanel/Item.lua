local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)

local Localization = require(Plugin.Util.Localization)
local Store = require(Plugin.Util.Store)

local Tooltip = require(Plugin.Components.Tooltip)

local useStore = require(Plugin.Hooks.useStore)

local function MaterialButton(props)
  local currentMaterial = useStore('Material')

  return React.createElement('ImageButton', {
    BackgroundTransparency = 1,
    Image = props.Image,
    [React.Event.MouseButton1Click] = function()
      Store:Set('Material', props.Id)
    end
  }, {
    UICorner = React.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3)
    }),

    Tooltip = React.createElement(Tooltip.Trigger, {
      Text = Localization('Materials.'..props.Id.Name)
    }),

    SelectedImage = currentMaterial == props.Id and React.createElement('ImageLabel', {
      AnchorPoint = Vector2.new(1, 0),
      BackgroundTransparency = 1,
      Image = 'rbxassetid://4507466924',
      Position = UDim2.fromScale(1, 0),
      Size = UDim2.fromScale(0.5, 0.5)
    })
  })
end

return MaterialButton
