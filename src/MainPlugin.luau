local Plugin = script.Parent

local React = require(Plugin.Packages.React)

local App = require(Plugin.Components.App)
local DockWidget = require(Plugin.Components.Plugin.DockWidget)
local Toolbar = require(Plugin.Components.Plugin.Toolbar)
local ToolbarButton = require(Plugin.Components.Plugin.ToolbarButton)

local Utils = Plugin.Util
local Constants = require(Utils.Constants)
local Localization = require(Utils.Localization)

local function MainPlugin()
  local enabled, setEnabled = React.useState(false)
  local function toggleEnabled()
    setEnabled(function(enabled)
      return not enabled
    end)
  end

  local pluginName = Localization('Plugin.Name')
  local tooltip = Localization('Plugin.Desc')
  if Constants.IS_DEV_CHANNEL then
    pluginName ..= '[DEV]'
  end

  return React.createElement(React.Fragment, nil, {
    Toolbar = React.createElement(Toolbar, {
      Name = 'mkargus'
    }, {
      Toggle = React.createElement(ToolbarButton, {
        Id = 'PartToTerrain',
        Text = pluginName,
        Tooltip = tooltip,
        Icon = 'rbxassetid://5768049797',

        OnClick = function()
          toggleEnabled()
        end
      })
    }),

    DockWidget = React.createElement(DockWidget, {
      Id = 'PartToTerrain',
      Title = pluginName,
      Enabled = enabled,
      onClose = function()
        setEnabled(false)
      end
    }, {
      App = React.createElement(App)
    })

  })
end

return MainPlugin
