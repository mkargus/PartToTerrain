local Studio = settings():GetService('Studio')

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local useEventConnection = require(Plugin.Hooks.useEventConnection)

local Context = React.createContext(nil)

local function StudioThemeProvider(props)
  local theme, setTheme = React.useState(Studio.Theme)

  useEventConnection(Studio.ThemeChanged, function()
    setTheme(Studio.Theme)
  end)

  return React.createElement(Context.Provider, {
    value = theme
  }, props.children)
end

return {
  Context = Context,
  Provider = StudioThemeProvider
}
