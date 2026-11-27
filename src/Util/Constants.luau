local Constants = {}

Constants.RAYCAST_LENGTH = 15000
Constants.VOXEL_RESOLUTION = 4

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

Constants.MATERIAL_COLORS = {
  [Enum.Material.Asphalt] = Color3.fromRGB(80, 84, 84),
  [Enum.Material.Basalt] = Color3.fromRGB(75, 74, 74),
  [Enum.Material.Brick] = Color3.fromRGB(138, 97, 73),
  [Enum.Material.Cobblestone] = Color3.fromRGB(134, 134, 118),
  [Enum.Material.Concrete] = Color3.fromRGB(152, 152, 152),
  [Enum.Material.CrackedLava] = Color3.fromRGB(255, 24, 67),
  [Enum.Material.Glacier] = Color3.fromRGB(221, 228, 229),
  [Enum.Material.Grass] = Color3.fromRGB(111, 126, 62),
  [Enum.Material.Ground] = Color3.fromRGB(140, 130, 104),
  [Enum.Material.Ice] = Color3.fromRGB(204, 210, 223),
  [Enum.Material.LeafyGrass] = Color3.fromRGB(106, 134, 64),
  [Enum.Material.Limestone] = Color3.fromRGB(255, 243, 192),
  [Enum.Material.Mud] = Color3.fromRGB(121, 112, 98),
  [Enum.Material.Pavement] = Color3.fromRGB(143, 144, 135),
  [Enum.Material.Rock] = Color3.fromRGB(99, 100, 102),
  [Enum.Material.Salt] = Color3.fromRGB(255, 255, 254),
  [Enum.Material.Sand] = Color3.fromRGB(207, 203, 167),
  [Enum.Material.Sandstone] = Color3.fromRGB(148, 124, 95),
  [Enum.Material.Slate] = Color3.fromRGB(88, 89, 86),
  [Enum.Material.Snow] = Color3.fromRGB(235, 253, 255),
  [Enum.Material.WoodPlanks] = Color3.fromRGB(172, 148, 108),
}

return table.freeze(Constants)
