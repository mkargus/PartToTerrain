local StudioSettings = settings().Studio

local React = require(script.Parent.Parent.Packages.React)

local StudioThemeContext = React.createContext(StudioSettings.Theme)
StudioThemeContext.displayName = 'StudioThemeContext'

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
    value = theme,
  }, props.children)
end

local function useTheme(): StudioTheme
  return React.useContext(StudioThemeContext)
end

return {
  Provider = StudioThemeProvider,
  useTheme = useTheme,
}
