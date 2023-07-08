local TerrainEnum = require(script.Parent.TerrainEnum)
local TerrainConverter = require(script.Parent.TerrainConverter)

local TerrainUtil = {}

function TerrainUtil:IsConvertibleToTerrain(instance: Instance): boolean
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

  -- Disallow Mesh, CSG, CornerWedge or SpawnLocation parts
  if instance:IsA('TriangleMeshPart') or instance:IsA('CornerWedgePart') or instance:IsA('SpawnLocation') then
    return false
  end

  -- Block attepments against NPCs.
  if instance.Parent and instance.Parent:IsA('Model') and instance.Parent:FindFirstChildOfClass('Humanoid') then
    return false
  end

  return true
end

--[[
  Returns info about the part such as what shape it is, cframe and size.
]]
function TerrainUtil:GetPartInfo(part: BasePart): (string, CFrame, Vector3)
  local cframe = part.CFrame
  local size = part.Size

  local obj = part:FindFirstChildWhichIsA('DataModelMesh')

  -- If the part has a mesh parented to it, then use the mesh shape instead
  if obj then
    cframe += part.CFrame:VectorToWorldSpace(obj.Offset)
    size *= obj.Scale

    if obj:IsA('SpecialMesh') then
      if obj.MeshType == Enum.MeshType.Cylinder then
        return TerrainEnum.Shape.CylinderRotate, cframe, size
      elseif obj.MeshType == Enum.MeshType.Head then
        return TerrainEnum.Shape.Cylinder, cframe, size
      elseif obj.MeshType == Enum.MeshType.Sphere then
        return TerrainEnum.Shape.Ball, cframe, size
      elseif obj.MeshType == Enum.MeshType.Wedge then
        return TerrainEnum.Shape.Wedge, cframe, size
      end

    elseif obj:IsA('CylinderMesh') then
      return TerrainEnum.Shape.Cylinder, cframe, size
    end

    -- Fallback to a block
    return TerrainEnum.Shape.Block, cframe, size
  end

  if part:IsA('Part') then
    if part.Shape == Enum.PartType.Cylinder then
      return TerrainEnum.Shape.CylinderRotate, cframe, size
    elseif part.Shape == Enum.PartType.Ball then
      return TerrainEnum.Shape.Ball, cframe, size
    elseif part.Shape == Enum.PartType.Wedge then
      return TerrainEnum.Shape.Wedge, cframe, size
    else
      return TerrainEnum.Shape.Block, cframe, size
    end

  elseif part:IsA('WedgePart') then
    return TerrainEnum.Shape.Wedge, cframe, size
  end

  return TerrainEnum.Shape.Block, cframe, size
end

function TerrainUtil:ConvertToTerrain(shape: string, material: Enum.Material, cframe: CFrame, size: Vector3, preserveTerrain: boolean?): (boolean, string?)
  if size.X <= 0 or size.Y <= 0 or size.Z <= 0 then
    return false, TerrainEnum.ConvertError.InvalidSize
  end

  local success, errorCode = (function()
    if shape == TerrainEnum.Shape.Ball then
      local radius = math.min(size.X, size.Y, size.Z) / 2
      return TerrainConverter:FillBall(material, cframe, radius, preserveTerrain)

    elseif shape == TerrainEnum.Shape.Block then
      return TerrainConverter:FillBlock(material, cframe, size, preserveTerrain)

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

return TerrainUtil
