local Studio = settings():GetService('Studio')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local Context = Roact.createContext()

local function StudioThemeProvider(props, hooks)
  local theme, setTheme = hooks.useState(Studio.Theme)

  hooks.useEffect(function()
    local themeConnection = Studio.ThemeChanged:Connect(function()
      setTheme(Studio.Theme)
    end)

    return function()
      themeConnection:Disconnect()
    end
  end, {})

  return Roact.createElement(Context.Provider, {
    value = theme
  }, props[Roact.Children])
end

StudioThemeProvider = Hooks.new(Roact)(StudioThemeProvider)

return {
  Context = Context,
  Provider = StudioThemeProvider
}
