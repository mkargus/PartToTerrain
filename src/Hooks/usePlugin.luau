local React = require(script.Parent.Parent.Packages.React)

local PluginContext = require(script.Parent.Parent.Context.Plugin)

local function usePlugin(): Plugin
  return React.useContext(PluginContext)
end

return usePlugin
