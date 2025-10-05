local React = require(script.Parent.Parent.Packages.React)

local PluginContext: React.Context<Plugin> = React.createContext(script:FindFirstAncestorOfClass('Plugin')) :: any

return PluginContext
