local TerrainEnum = require(script.Parent.TerrainEnum)
local TerrainConverter = require(script.Parent.TerrainConverter)

local function isConvertibleToTerrain(instance)
  if not instance then
    return false
  end

  -- The Terrain class should not be converted to Terrain.
  if instance:IsA('Terrain') then
    return false
  end

  if not instance:IsA('BasePart') then
    return false
  end

  -- Block attepments against NPCs.
  if instance.Parent:IsA('Model') and instance.Parent:FindFirstChildOfClass('Humanoid') then
    return false
  end

  -- Disallow Mesh, CSG or CornerWedge parts
  if instance:IsA('MeshPart') or instance:IsA('PartOperation') or instance:IsA('CornerWedgePart') then
    return false
  end

  return true
end

local function getPartShape(part)

  -- If the part has a mesh parented to it, then use the mesh shape instead
  for _, obj in ipairs(part:GetChildren()) do
    if obj:IsA('DataModelMesh') then

      if obj:IsA('SpecialMesh') then
        if obj.MeshType == Enum.MeshType.Cylinder then
          return TerrainEnum.Shape.CylinderRotate
        elseif obj.MeshType == Enum.MeshType.Head then
          return TerrainEnum.Shape.Cylinder
        elseif obj.MeshType == Enum.MeshType.Sphere then
          return TerrainEnum.Shape.Ball
        elseif obj.MeshType == Enum.MeshType.Wedge then
          return TerrainEnum.Shape.Wedge
        end

      elseif obj:IsA('CylinderMesh') then
        return TerrainEnum.Shape.Cylinder
      end

      -- Fallback to a block
      return TerrainEnum.Shape.Block

    end

  end

  if part:IsA('Part') then
    if part.Shape == Enum.PartType.Cylinder then
      return TerrainEnum.Shape.CylinderRotate
    elseif part.Shape == Enum.PartType.Ball then
      return TerrainEnum.Shape.Ball
    else
      return TerrainEnum.Shape.Block
    end

  elseif part:IsA('WedgePart') then
    return TerrainEnum.Shape.Wedge
  end

  return TerrainEnum.Shape.Block
end

local function convertToTerrain(shape, material, cframe: CFrame, size: Vector3, preserceTerrain)

  local success, errorCode = (function()
    if shape == TerrainEnum.Shape.Ball then
      local center = cframe.Position
      local radius = math.min(size.X, size.Y, size.Z) / 2
      return TerrainConverter:FillBall(material, center, radius)

    elseif shape == TerrainEnum.Shape.Block then
      return TerrainConverter:FillBlock(material, cframe, size, preserceTerrain)

    elseif shape == TerrainEnum.Shape.Cylinder then
      local height = size.Y
      local radius = math.min(size.X, size.Z) / 2
      return TerrainConverter:FillCylinder(material, cframe, height, radius)

    elseif shape == TerrainEnum.Shape.CylinderRotate then
      local cframe_fix = cframe * CFrame.Angles(0, 0, math.rad(90))
      local height = size.X
      local radius = math.min(size.Y, size.Z) / 2
      return TerrainConverter:FillCylinder(material, cframe_fix, height, radius)

    elseif shape == TerrainEnum.Shape.Wedge then
      return TerrainConverter:FillWedge(material, cframe, size)
    end

    return false, TerrainEnum.ConvertError.UnknownShape
  end)()

  return success, errorCode
end

return {
  isConvertibleToTerrain = isConvertibleToTerrain,

  getPartShape = getPartShape,

  convertToTerrain = convertToTerrain
}
