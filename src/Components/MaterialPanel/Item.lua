local Plugin = script.Parent.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Localization = require(Plugin.Util.Localization)
local Store = require(Plugin.Util.Store)

local Tooltip = require(Plugin.Components.Tooltip)

local MaterialButton = Roact.PureComponent:extend('MaterialButton')

function MaterialButton:init()
  self.state = {
    isHovering = false
  }
end

function MaterialButton:render()
  local props = self.props
  local state = self.state

  return Roact.createElement('ImageButton', {
    BackgroundTransparency = 1,
    Image = props.Image,
    [Roact.Event.MouseButton1Click] = function()
      Store:Set('Material', props.Id)
    end,
    [Roact.Event.MouseEnter] = function()
      self:setState({ isHovering = true })
    end,
    [Roact.Event.MouseLeave] = function()
      self:setState({ isHovering = false })
    end,
  }, {
    UICorner = Roact.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3)
    }),

    Tooltip = state.isHovering and Roact.createElement(Tooltip, {
      Text = Localization('Materials.'..props.Id.Name)
    }),

    SelectedImage = state.Material == props.Id and Roact.createElement('ImageLabel', {
      AnchorPoint = Vector2.new(1, 0),
      BackgroundTransparency = 1,
      Image = 'rbxassetid://4507466924',
      Position = UDim2.fromScale(1, 0),
      Size = UDim2.fromScale(0.5, 0.5)
    })
  })
end

function MaterialButton:shouldUpdate(_, newState)
  -- Allow re-rendering only if the Material state is selected or deselected.
  -- * Removing this would cause ALL materials button, whether or not selected, to re-rendering. (23 materials => 23 re-renders)
  if newState.Material == self.props.Id or self.state.Material == self.props.Id then
    return true
  end

  -- Allows re-rendering for the `isHovering` state that is used for the tooltip.
  if newState.isHovering ~= self.state.isHovering then
    return true
  end

  -- For any other reason, don't re-render the element.
  return false
end

return Store:Roact(MaterialButton, { 'Material' })
