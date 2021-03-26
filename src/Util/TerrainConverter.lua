local TerrainConverter = {}

function TerrainConverter:FillBall(material, center, radius)
  workspace.Terrain:FillBall(center, radius, material)
  return true
end

function TerrainConverter:FillBlock(material, cframe, size)
  workspace.Terrain:FillBlock(cframe, size, material)
  return true
end

function TerrainConverter:FillCylinder(material, cframe, height, radius)
  workspace.Terrain:FillCylinder(cframe, height, radius, material)
  return true
end

function TerrainConverter:FillWedge(material, cframe, size)
  workspace.Terrain:FillWedge(cframe, size, material)
  return true
end

return TerrainConverter
