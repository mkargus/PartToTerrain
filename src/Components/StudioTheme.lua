local StudioTheme = {}

local ThemeContext = require(script.Parent.Parent.Context.StudioTheme)

function StudioTheme.withTheme(callback: (theme: StudioTheme) -> any)
  -- I could have just replace all `Plugin.Components.StudioTheme` requires and avoid redirecting
  -- but I don't want to mess with several files and risk breaking stuff.
  return ThemeContext.withTheme(callback)
end

return StudioTheme
