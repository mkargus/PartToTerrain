local StudioSettings = settings().Studio

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local StudioThemeContext = React.createContext(StudioSettings.Theme)

local function StudioThemeProvider(props)
  local theme, setTheme = React.useState(StudioSettings.Theme)

  React.useEffect(function()
    local connection = StudioSettings.ThemeChanged:Connect(function()
      setTheme(StudioSettings.Theme)
    end)

    return function()
      connection:Disconnect()
    end
  end, {})

  return React.createElement(StudioThemeContext.Provider, {
    value = theme
  }, props.children)
end

return {
  Context = StudioThemeContext,
  Provider = StudioThemeProvider
}
