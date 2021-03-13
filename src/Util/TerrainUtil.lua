local TerrainEnum = require(script.Parent.TerrainEnum)
-- local TerrainConverter = require(script.Parent.TerrainConverter)

local MINIMUM_SIZE = 4

local function isTooSmallToConvert(instance)
  return instance.Size.X < MINIMUM_SIZE
      or instance.Size.Y < MINIMUM_SIZE
      or instance.Size.Z < MINIMUM_SIZE
end

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

  -- Disallow Mesh or CSG parts
  if instance:IsA('MeshPart') or instance:IsA('PartOperation') then
    return false
  end

  if isTooSmallToConvert(instance) then
    return false
  end

  return true
end

local function getPartShape(part)

  -- Add SpecialMesh support.
  -- https://github.com/CloneTrooper1019/Roblox-Client-Tracker/blob/roblox/BuiltInPlugins/TerrainToolsV2/Src/Util/PartConverterUtil.lua#L89

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

-- local function convertToTerrain(shape)
-- end

return {
  isConvertibleToTerrain = isConvertibleToTerrain,

  getPartShape = getPartShape,

  -- convertToTerrain = convertToTerrain
}
