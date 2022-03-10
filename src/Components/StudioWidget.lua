--[[
  Props:
    InitialDockState InitialDockState
    boolean Active
    boolean OverridePreviousState
    Vector2 FloatingSize
    Vector2 MinimumSize
    ZIndexBehavior ZIndexBehavior

    function onClose
]]

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local StudioWidget = Roact.PureComponent:extend('StudioWidget')

StudioWidget.defaultProps = {
  InitialDockState = Enum.InitialDockState.Float,
  Active = false,
  OverridePreviousState = false,
  FloatingSize = Vector2.new(0, 0),
  MinimumSize = Vector2.new(0, 0),
  ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}

function StudioWidget:init()
  local props = self.props

  local DockWidgetPluginGuiInfo = DockWidgetPluginGuiInfo.new(
    props.InitialDockState,
    props.Active,
    props.OverridePreviousState,
    props.FloatingSize.X, props.FloatingSize.Y,
    props.MinimumSize.X, props.MinimumSize.Y
  )

  local pluginGui = props.plugin:CreateDockWidgetPluginGui(props.Id, DockWidgetPluginGuiInfo)

  pluginGui.Name = props.Id
  pluginGui.Title = props.Title
  pluginGui.ZIndexBehavior = props.ZIndexBehavior

  pluginGui:BindToClose(function()
    pluginGui.Enabled = false
    if props.onClose then
      props.onClose()
    end
  end)

  if props[Roact.Ref] then
    props[Roact.Ref](pluginGui)
  end

  self.pluginGui = pluginGui
end

function StudioWidget:render()
  return Roact.createElement(Roact.Portal, {
    target = self.pluginGui
  }, self.props[Roact.Children])
end

function StudioWidget:didUpdate()
  self.pluginGui.Enabled = self.props.Active
end

function StudioWidget:willUnmount()
  self.pluginGui:Destroy()
end

return StudioWidget
