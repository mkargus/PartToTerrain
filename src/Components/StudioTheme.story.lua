local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local StudioTheme = require(Plugin.Components.StudioTheme)

local Wrapper = Roact.Component:extend('StudioThemeWrapper')

function Wrapper:render()
  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('TextLabel', {
      BackgroundColor3 = theme:GetColor('MainBackground'),
      BorderColor3 = theme:GetColor('Border'),
      Size = UDim2.new(0, 250, 0, 50),
      Text = 'Should change depending on Studio theme.',
      TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText)
    })
  end)
end

return function(target)
  local element = Roact.createElement(Wrapper)
  local handle = Roact.mount(element, target)
  return function()
    Roact.unmount(handle)
  end
end
