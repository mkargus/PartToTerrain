local sp = script.Parent

return {
  Version = '1.3.1',
  UpdateCheckerID = 2673110695,

  Materials = {
    {enum = Enum.Material.Air, img = 'rbxasset://textures/CollisionGroupsEditor/delete-hover.png'},
    {enum = Enum.Material.Asphalt, img = 'rbxasset://textures/TerrainTools/mtrl_asphalt.png'},
    {enum = Enum.Material.Basalt, img = 'rbxasset://textures/TerrainTools/mtrl_basalt.png'},
    {enum = Enum.Material.Brick, img = 'rbxasset://textures/TerrainTools/mtrl_brick.png'},
    {enum = Enum.Material.Cobblestone, img = 'rbxasset://textures/TerrainTools/mtrl_cobblestone.png'},
    {enum = Enum.Material.Concrete, img = 'rbxasset://textures/TerrainTools/mtrl_concrete.png'},
    {enum = Enum.Material.CrackedLava, img = 'rbxasset://textures/TerrainTools/mtrl_crackedlava.png'},
    {enum = Enum.Material.Glacier, img = 'rbxasset://textures/TerrainTools/mtrl_glacier.png'},
    {enum = Enum.Material.Grass, img = 'rbxasset://textures/TerrainTools/mtrl_grass.png'},
    {enum = Enum.Material.Ground, img = 'rbxasset://textures/TerrainTools/mtrl_ground.png'},
    {enum = Enum.Material.Ice, img = 'rbxasset://textures/TerrainTools/mtrl_ice.png'},
    {enum = Enum.Material.LeafyGrass, img = 'rbxasset://textures/TerrainTools/mtrl_leafygrass.png'},
    {enum = Enum.Material.Limestone, img = 'rbxasset://textures/TerrainTools/mtrl_limestone.png'},
    {enum = Enum.Material.Mud, img = 'rbxasset://textures/TerrainTools/mtrl_mud.png'},
    {enum = Enum.Material.Pavement, img = 'rbxasset://textures/TerrainTools/mtrl_pavement.png'},
    {enum = Enum.Material.Rock, img = 'rbxasset://textures/TerrainTools/mtrl_rock.png'},
    {enum = Enum.Material.Salt, img = 'rbxasset://textures/TerrainTools/mtrl_salt.png'},
    {enum = Enum.Material.Sand, img = 'rbxasset://textures/TerrainTools/mtrl_sand.png'},
    {enum = Enum.Material.Sandstone, img = 'rbxasset://textures/TerrainTools/mtrl_sandstone.png'},
    {enum = Enum.Material.Slate, img = 'rbxasset://textures/TerrainTools/mtrl_slate.png'},
    {enum = Enum.Material.Snow, img = 'rbxasset://textures/TerrainTools/mtrl_snow.png'},
    {enum = Enum.Material.Water, img = 'rbxasset://textures/TerrainTools/mtrl_water.png'},
    {enum = Enum.Material.WoodPlanks, img = 'rbxasset://textures/TerrainTools/mtrl_woodplanks.png'}
  },

  Settings = {
    {id = 'CheckUpdates', defaultValue = true},
    {id = 'DeletePart', defaultValue = true},
    {id = 'EnabledSelectionBox', defaultValue = true},
    {id = 'IgnoreLockedParts', defaultValue = false}
  }

}
