local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)
local ReactRoblox = require(Plugin.Packages.ReactRoblox)

local PluginContext = require(Plugin.Context.Plugin)

export type Props = {
  Id: string,
  Title: string,

  InitialDockState: Enum.InitialDockState?,
  Enabled: boolean?,
  OverridePreviousState: boolean,
  FloatingSize: Vector2?,
  MinSize: Vector2?,
  ZIndexBehavior: Enum.ZIndexBehavior?,
  onClose: () -> ()?,
  children: React.ReactNode,
}

local function DockWidget(props: Props)
  local plugin = React.useContext(PluginContext)

  local id = props.Id
  local title = props.Title
  local initialDockState = props.InitialDockState or Enum.InitialDockState.Float
  local enabled = props.Enabled or false
  local overridePreviousState = props.OverridePreviousState or false
  local floatingSize = props.FloatingSize or Vector2.zero
  local minSize = props.MinSize or Vector2.zero
  local zIndexBehavior = props.ZIndexBehavior or Enum.ZIndexBehavior.Sibling

  local dockWidget: DockWidgetPluginGui?, setDockWidget = React.useState(nil :: DockWidgetPluginGui?)

  local dockWidgetInfo = React.useMemo(function()
    return DockWidgetPluginGuiInfo.new(
      initialDockState,
      enabled,
      overridePreviousState,
      floatingSize.X,
      floatingSize.Y,
      minSize.X,
      minSize.Y
    )
  end, {})

  React.useEffect(function()
    local newWidget = plugin:CreateDockWidgetPluginGui(id, dockWidgetInfo)
    newWidget.Name = title
    newWidget.Title = title
    newWidget.Enabled = enabled
    newWidget.ZIndexBehavior = zIndexBehavior
    setDockWidget(newWidget)

    return function()
      newWidget:Destroy()
    end
  end, {})

  React.useEffect(function()
    if dockWidget ~= nil and props.onClose then
      dockWidget:BindToClose(props.onClose)
      return function()
        dockWidget:BindToClose()
      end
    end
  end, { props.onClose })

  React.useEffect(function()
    if dockWidget ~= nil and dockWidget.Enabled ~= enabled then
      dockWidget.Enabled = enabled
    end
  end, { enabled })

  return if dockWidget then ReactRoblox.createPortal(props.children, dockWidget) else nil
end

return DockWidget
