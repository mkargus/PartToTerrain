-- http://lua-users.org/wiki/ReadOnlyTables
local function readOnlyTable(table)
  return setmetatable({}, {
    __index = table,
    __newindex = function() error('Attempted to modify read-only table') end,
    __metatable = false
  })
end

local Constants = {}

----------------------------------------
-- Meta settings
----------------------------------------
Constants.PLUGIN_BUTTON_ICON = 'rbxassetid://5768049797'

Constants.DOCK_WIDGET_INFO = DockWidgetPluginGuiInfo.new(
  Enum.InitialDockState.Float,
  false, true,
  250, 330,
  250, 200
)

Constants.OUTLINE_COLOR_ALLOW = Color3.fromRGB(67, 160, 71)
Constants.OUTLINE_COLOR_WARNING = Color3.new(1, 1, 0)
Constants.OUTLINE_COLOR_ERROR = Color3.fromRGB(229, 57, 53)

----------------------------------------
-- Update Checking
----------------------------------------
Constants.IS_DEV_CHANNEL = false
Constants.VERSION = '1.4.0'
Constants.UPDATE_CHECKER_ID = 2673110695
Constants.DEV_UPDATE_CHECKER_ID = 4685764627

----------------------------------------
-- Material related
----------------------------------------
Constants.MATERIAL_GRID_PADDING = UDim2.new(0, 5, 0, 5)
Constants.MATERIAL_GRID_SIZE = UDim2.new(0, 50, 0, 50)
Constants.MATERIAL_SELECTED_IMAGE = 'rbxassetid://4507466924'

Constants.MATERIALS_TABLE = {
  { enum = Enum.Material.Air, img = 'rbxasset://textures/TerrainTools/mtrl_air.png' },
  { enum = Enum.Material.Asphalt, img = 'rbxasset://textures/TerrainTools/mtrl_asphalt.png' },
  { enum = Enum.Material.Basalt, img = 'rbxasset://textures/TerrainTools/mtrl_basalt.png' },
  { enum = Enum.Material.Brick, img = 'rbxasset://textures/TerrainTools/mtrl_brick.png' },
  { enum = Enum.Material.Cobblestone, img = 'rbxasset://textures/TerrainTools/mtrl_cobblestone.png' },
  { enum = Enum.Material.Concrete, img = 'rbxasset://textures/TerrainTools/mtrl_concrete.png' },
  { enum = Enum.Material.CrackedLava, img = 'rbxasset://textures/TerrainTools/mtrl_crackedlava.png' },
  { enum = Enum.Material.Glacier, img = 'rbxasset://textures/TerrainTools/mtrl_glacier.png' },
  { enum = Enum.Material.Grass, img = 'rbxasset://textures/TerrainTools/mtrl_grass.png' },
  { enum = Enum.Material.Ground, img = 'rbxasset://textures/TerrainTools/mtrl_ground.png' },
  { enum = Enum.Material.Ice, img = 'rbxasset://textures/TerrainTools/mtrl_ice.png' },
  { enum = Enum.Material.LeafyGrass, img = 'rbxasset://textures/TerrainTools/mtrl_leafygrass.png' },
  { enum = Enum.Material.Limestone, img = 'rbxasset://textures/TerrainTools/mtrl_limestone.png' },
  { enum = Enum.Material.Mud, img = 'rbxasset://textures/TerrainTools/mtrl_mud.png' },
  { enum = Enum.Material.Pavement, img = 'rbxasset://textures/TerrainTools/mtrl_pavement.png' },
  { enum = Enum.Material.Rock, img = 'rbxasset://textures/TerrainTools/mtrl_rock.png' },
  { enum = Enum.Material.Salt, img = 'rbxasset://textures/TerrainTools/mtrl_salt.png' },
  { enum = Enum.Material.Sand, img = 'rbxasset://textures/TerrainTools/mtrl_sand.png' },
  { enum = Enum.Material.Sandstone, img = 'rbxasset://textures/TerrainTools/mtrl_sandstone.png' },
  { enum = Enum.Material.Slate, img = 'rbxasset://textures/TerrainTools/mtrl_slate.png' },
  { enum = Enum.Material.Snow, img = 'rbxasset://textures/TerrainTools/mtrl_snow.png' },
  { enum = Enum.Material.Water, img = 'rbxasset://textures/TerrainTools/mtrl_water.png' },
  { enum = Enum.Material.WoodPlanks, img = 'rbxasset://textures/TerrainTools/mtrl_woodplanks.png' }
}

----------------------------------------
-- Settings related
----------------------------------------
Constants.SETTINGS_TABLE = {
  CheckUpdates = { defaultValue = true },
  DeletePart = { defaultValue = true },
  EnabledSelectionBox = { defaultValue = true },
  IgnoreLockedParts = { defaultValue = false }
}

----------------------------------------
-- Navbar related
----------------------------------------
Constants.TAB_ICON_SIZE = 24
Constants.TAB_INNER_PADDING = 3

Constants.NAVBAR_TABS = {
  { key = 'Materials', icon = 'rbxassetid://5741677639' },
  { key = 'Settings', icon = 'rbxassetid://5747147099' }
}

return readOnlyTable(Constants)
