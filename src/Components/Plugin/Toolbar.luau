local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)

local PluginContext = require(Plugin.Context.Plugin)
local ToolbarContext = require(Plugin.Context.Toolbar)

export type Props = {
  Name: string,
  children: React.ReactNode,
}

local function Toolbar(props: Props)
  local plugin = React.useContext(PluginContext)

  local toolbar: PluginToolbar?, setToolbar = React.useState(nil :: PluginToolbar?)

  React.useEffect(function()
    local newToolbar = plugin:CreateToolbar(props.Name)
    setToolbar(newToolbar)
    return function()
      newToolbar:Destroy()
    end
  end, {})

  React.useEffect(function()
    if toolbar ~= nil and toolbar.Name ~= props.Name then
      toolbar.Name = props.Name
    end
  end, { props.Name })

  return React.createElement(ToolbarContext.Provider, { value = toolbar }, if toolbar then props.children else nil)
end

return Toolbar
