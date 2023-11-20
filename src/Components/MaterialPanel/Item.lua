local Plugin = script.Parent.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local Localization = require(Plugin.Util.Localization)
local Store = require(Plugin.Util.Store)

local Tooltip = require(Plugin.Components.Tooltip)

local useStore = require(Plugin.Hooks.useStore)

local function MaterialButton(props, hooks)
  local isHovering, setHovering = hooks.useState(false)
  local currentMaterial = useStore(hooks, 'Material')

  return Roact.createElement('ImageButton', {
    BackgroundTransparency = 1,
    Image = props.Image,
    [Roact.Event.MouseButton1Click] = function()
      Store:Set('Material', props.Id)
    end,
    [Roact.Event.MouseEnter] = function()
      setHovering(true)
    end,
    [Roact.Event.MouseLeave] = function()
      setHovering(false)
    end,
  }, {
    UICorner = Roact.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3)
    }),

    Tooltip = isHovering and Roact.createElement(Tooltip, {
      Text = Localization('Materials.'..props.Id.Name)
    }),

    SelectedImage = currentMaterial == props.Id and Roact.createElement('ImageLabel', {
      AnchorPoint = Vector2.new(1, 0),
      BackgroundTransparency = 1,
      Image = 'rbxassetid://4507466924',
      Position = UDim2.fromScale(1, 0),
      Size = UDim2.fromScale(0.5, 0.5)
    })
  })
end

MaterialButton = Hooks.new(Roact)(MaterialButton)

return MaterialButton
