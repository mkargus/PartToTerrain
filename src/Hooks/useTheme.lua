--!strict
local StudioTheme = require(script.Parent.Parent.Context.StudioTheme)

local function useTheme(hooks): StudioTheme
  local theme = hooks.useContext(StudioTheme.Context)
  return theme
end

return useTheme
