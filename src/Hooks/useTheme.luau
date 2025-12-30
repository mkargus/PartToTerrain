local React = require(script.Parent.Parent.Packages.React)

local StudioTheme = require(script.Parent.Parent.Context.StudioTheme)

local function useTheme(): StudioTheme
  local theme = React.useContext(StudioTheme.Context)
  return theme
end

return useTheme
