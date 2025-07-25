--[[
  Props:
    InitialDockState InitialDockState
    boolean Enabled
    boolean OverridePreviousState
    Vector2 FloatingSize
    Vector2 MinimumSize
    ZIndexBehavior ZIndexBehavior

    function onClose
]]

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)
local ReactRoblox = require(Plugin.Packages.ReactRoblox)

local StudioWidget = React.PureComponent:extend('StudioWidget')

StudioWidget.defaultProps = {
  InitialDockState = Enum.InitialDockState.Float,
  Enabled = false,
  OverridePreviousState = false,
  FloatingSize = Vector2.zero,
  MinimumSize = Vector2.zero,
  ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}

function StudioWidget:init()
  local props = self.props

  local DockWidgetPluginGuiInfo = DockWidgetPluginGuiInfo.new(
    props.InitialDockState,
    props.Enabled,
    props.OverridePreviousState,
    props.FloatingSize.X,
    props.FloatingSize.Y,
    props.MinimumSize.X,
    props.MinimumSize.Y
  )

  local pluginGui = props.plugin:CreateDockWidgetPluginGui(props.Id, DockWidgetPluginGuiInfo)

  pluginGui.Name = props.Id
  pluginGui.Title = props.Title
  pluginGui.ZIndexBehavior = props.ZIndexBehavior

  pluginGui:BindToClose(props.onClose)

  self.pluginGui = pluginGui
end

function StudioWidget:render()
  return ReactRoblox.createPortal(self.props.children, self.pluginGui)
end

function StudioWidget:componentDidUpdate(lastProps)
  if lastProps.Enabled ~= self.props.Enabled then
    self.pluginGui.Enabled = self.props.Enabled
  end
end

function StudioWidget:componentWillUnmount()
  self.pluginGui:Destroy()
end

return StudioWidget
