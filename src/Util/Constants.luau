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
Constants.IS_DEV_CHANNEL = true
Constants.VERSION = '2025.06.01'
Constants.UPDATE_CHECKER_ID = 261634767
Constants.DEV_UPDATE_CHECKER_ID = 4685764627

----------------------------------------
-- Material related
----------------------------------------
Constants.MATERIAL_GRID_PADDING = UDim2.fromOffset(3, 3)
Constants.MATERIAL_GRID_SIZE = UDim2.fromOffset(55, 55)

Constants.MATERIALS = {
  Enum.Material.Air,
  Enum.Material.Asphalt,
  Enum.Material.Basalt,
  Enum.Material.Brick,
  Enum.Material.Cobblestone,
  Enum.Material.Concrete,
  Enum.Material.CrackedLava,
  Enum.Material.Glacier,
  Enum.Material.Grass,
  Enum.Material.Ground,
  Enum.Material.Ice,
  Enum.Material.LeafyGrass,
  Enum.Material.Limestone,
  Enum.Material.Mud,
  Enum.Material.Pavement,
  Enum.Material.Rock,
  Enum.Material.Salt,
  Enum.Material.Sand,
  Enum.Material.Sandstone,
  Enum.Material.Slate,
  Enum.Material.Snow,
  Enum.Material.Water,
  Enum.Material.WoodPlanks,
}

return table.freeze(Constants)
