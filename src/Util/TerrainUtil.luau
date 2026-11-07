local TerrainConverter = require(script.Parent.TerrainConverter)
local TerrainEnum = require(script.Parent.TerrainEnum)

local TerrainShape = TerrainEnum.Shape
local ConvertError = TerrainEnum.ConvertError

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

local MESH_TYPE_MAP = {
  [Enum.MeshType.Cylinder] = TerrainShape.CylinderRotate,
  [Enum.MeshType.Head] = TerrainShape.Cylinder,
  [Enum.MeshType.Sphere] = TerrainShape.Ball,
  [Enum.MeshType.Wedge] = TerrainShape.Wedge,
}

local PART_SHAPE_MAP = {
  [Enum.PartType.Cylinder] = TerrainShape.CylinderRotate,
  [Enum.PartType.Ball] = TerrainShape.Ball,
  [Enum.PartType.Wedge] = TerrainShape.Ball,
}

--[[
  Returns info about the part such as what shape it is, cframe and size.
]]
function TerrainUtil:GetPartInfo(part: BasePart): (string, CFrame, Vector3)
  local shape = TerrainShape.Block
  local cframe = part.CFrame
  local size = part.Size

  local mesh = part:FindFirstChildWhichIsA('DataModelMesh')
  if mesh then
    cframe += part.CFrame:VectorToWorldSpace(mesh.Offset)
    size *= mesh.Scale:Abs()

    if mesh:IsA('SpecialMesh') then
      shape = MESH_TYPE_MAP[mesh.MeshType] or TerrainShape.Block
    elseif mesh:IsA('CylinderMesh') then
      shape = TerrainShape.Cylinder
    end
  elseif part:IsA('Part') then
    shape = PART_SHAPE_MAP[part.Shape] or TerrainShape.Block
  elseif part:IsA('WedgePart') then
    shape = TerrainShape.Wedge
  end

  return shape, cframe, size
end

function TerrainUtil:ConvertToTerrain(
  shape: string,
  material: Enum.Material,
  cframe: CFrame,
  size: Vector3,
  preserveTerrain: boolean?
): (boolean, string?)
  if size.X <= 0 or size.Y <= 0 or size.Z <= 0 then
    return false, ConvertError.InvalidSize
  end

  local success, errorCode = xpcall(function()
    if shape == TerrainShape.Ball then
      local radius = math.min(size.X, size.Y, size.Z) / 2
      TerrainConverter:FillBall(material, cframe, radius, preserveTerrain)
    elseif shape == TerrainShape.Block then
      TerrainConverter:FillBlock(material, cframe, size, preserveTerrain)
    elseif shape == TerrainShape.Cylinder then
      local height = size.Y
      local radius = math.min(size.X, size.Z) / 2
      TerrainConverter:FillCylinder(material, cframe, height, radius)
    elseif shape == TerrainShape.CylinderRotate then
      cframe *= CFrame.Angles(0, 0, math.rad(90))
      local height = size.X
      local radius = math.min(size.Y, size.Z) / 2
      TerrainConverter:FillCylinder(material, cframe, height, radius)
    elseif shape == TerrainShape.Wedge then
      TerrainConverter:FillWedge(material, cframe, size)
    else
      error(ConvertError.UnknownShape, 0)
    end

    return nil
  end, function(err)
    if string.find(err, 'too large') then
      return ConvertError.RegionTooLarge
    end

    if err == ConvertError.UnknownShape then
      return ConvertError.UnknownShape
    end

    warn(debug.traceback(err, 2))
    return ConvertError.UnknownError
  end)

  return success, errorCode
end

return TerrainUtil
