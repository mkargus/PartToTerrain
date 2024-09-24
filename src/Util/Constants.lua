local Constants = {}

----------------------------------------
-- Meta settings
----------------------------------------
Constants.PLUGIN_BUTTON_ICON = 'rbxassetid://5768049797'

Constants.OUTLINE_COLOR_ALLOW = Color3.fromRGB(56, 142, 60)
Constants.OUTLINE_COLOR_WARNING = Color3.fromRGB(245, 124, 0)
Constants.OUTLINE_COLOR_ERROR = Color3.fromRGB(211, 47, 47)

----------------------------------------
-- Update Checking
----------------------------------------
Constants.IS_DEV_CHANNEL = false
Constants.VERSION = '1.7.0'
Constants.UPDATE_CHECKER_ID = 261634767
Constants.DEV_UPDATE_CHECKER_ID = 4685764627

----------------------------------------
-- Material related
----------------------------------------
Constants.MATERIAL_GRID_PADDING = UDim2.fromOffset(5, 5)
Constants.MATERIAL_GRID_SIZE = UDim2.fromOffset(50, 50)

Constants.MATERIALS_TABLE = {
  { enum = Enum.Material.Air, img = 'mtrl_air.png' },
  { enum = Enum.Material.Asphalt, img = 'mtrl_asphalt.png' },
  { enum = Enum.Material.Basalt, img = 'mtrl_basalt.png' },
  { enum = Enum.Material.Brick, img = 'mtrl_brick.png' },
  { enum = Enum.Material.Cobblestone, img = 'mtrl_cobblestone.png' },
  { enum = Enum.Material.Concrete, img = 'mtrl_concrete.png' },
  { enum = Enum.Material.CrackedLava, img = 'mtrl_crackedlava.png' },
  { enum = Enum.Material.Glacier, img = 'mtrl_glacier.png' },
  { enum = Enum.Material.Grass, img = 'mtrl_grass.png' },
  { enum = Enum.Material.Ground, img = 'mtrl_ground.png' },
  { enum = Enum.Material.Ice, img = 'mtrl_ice.png' },
  { enum = Enum.Material.LeafyGrass, img = 'mtrl_leafygrass.png' },
  { enum = Enum.Material.Limestone, img = 'mtrl_limestone.png' },
  { enum = Enum.Material.Mud, img = 'mtrl_mud.png' },
  { enum = Enum.Material.Pavement, img = 'mtrl_pavement.png' },
  { enum = Enum.Material.Rock, img = 'mtrl_rock.png' },
  { enum = Enum.Material.Salt, img = 'mtrl_salt.png' },
  { enum = Enum.Material.Sand, img = 'mtrl_sand.png' },
  { enum = Enum.Material.Sandstone, img = 'mtrl_sandstone.png' },
  { enum = Enum.Material.Slate, img = 'mtrl_slate.png' },
  { enum = Enum.Material.Snow, img = 'mtrl_snow.png' },
  { enum = Enum.Material.Water, img = 'mtrl_water.png' },
  { enum = Enum.Material.WoodPlanks, img = 'mtrl_woodplanks.png' }
}

----------------------------------------
-- Settings related
----------------------------------------
Constants.SETTINGS_TABLE = {
  'PreserveTerrain',
  'IgnoreLockedParts',
  'IgnoreInvisibleParts',
  'DeletePart',
  'EnabledSelectionBox',
}

return table.freeze(Constants)
