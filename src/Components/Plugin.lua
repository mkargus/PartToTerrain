-- All plugin stuff should be moved to this script.
-- See XAXA's BrushtoolPlugin as an example.
local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)
local Constants = require(Modules.Parent.Constants)
local Localization = require(Modules.Localization)

local TerrainPlugin = Roact.PureComponent:extend('Plugin')

function TerrainPlugin:init(props)
  self.state = {
    isEnabled = false
  }

  self.plugin = props.plugin
  self.toolbar = self.plugin:CreateToolbar('Fasty48')

  if Constants.IS_DEV_CHANNEL then
    self.button = self.toolbar:CreateButton("PTT DEV", Localization('Plugin.Desc'), Constants.PLUGIN_BUTTON_ICON)
  else
    self.button = self.toolbar:CreateButton(Localization('Plugin.Name'), Localization('Plugin.Desc'), Constants.PLUGIN_BUTTON_ICON)
  end

end

-- function TerrainPlugin:didUpdate()

-- end

function TerrainPlugin:render()
  local props = self.props
  local state = self.state
end

return TerrainPlugin
