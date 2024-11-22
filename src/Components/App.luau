local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Materials = require(Plugin.Views.Materials)

local useTheme = require(Plugin.Hooks.useTheme)

local function App()
  local theme = useTheme()

  return React.createElement(React.Fragment, nil, {
    Background = React.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
      Size = UDim2.fromScale(1, 1),
      ZIndex = 0
    }),

    Body = React.createElement(Materials)
  })
end

return App
