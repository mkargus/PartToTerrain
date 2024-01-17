local Studio = settings():GetService('Studio')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local useEventConnection = require(Plugin.Hooks.useEventConnection)

local Context = Roact.createContext(nil)

local function StudioThemeProvider(props, hooks)
  local theme, setTheme = hooks.useState(Studio.Theme)

  useEventConnection(hooks, Studio.ThemeChanged, function()
    setTheme(Studio.Theme)
  end)

  return Roact.createElement(Context.Provider, {
    value = theme
  }, props[Roact.Children])
end

StudioThemeProvider = Hooks.new(Roact)(StudioThemeProvider)

return {
  Context = Context,
  Provider = StudioThemeProvider
}
