local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Search = require(Plugin.Components.Search)

local useTheme = require(Plugin.Hooks.useTheme)

local function App(props)
  local theme = useTheme()

  return React.createElement(React.Fragment, nil, {
    Background = React.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
      Size = UDim2.fromScale(1, 1),
      ZIndex = 0
    }),

    Search = React.createElement(Search, {
      PlaceholderText = 'Search',
      Position = UDim2.fromOffset(3, 3)
    })
  })
end

return App
