local TerrainEnum = require(script.Parent.TerrainEnum)
local TerrainConverter = require(script.Parent.TerrainConverter)

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

local function convertToTerrain(shape, material, cframe: CFrame, size: Vector3)

  local success, errorCode = (function()

    if shape == TerrainEnum.Shape.Ball then
      local center = cframe.Position
      local radius = math.min(size.X, size.Y, size.Z) / 2
      return TerrainConverter:FillBall(material, center, radius)

    elseif shape == TerrainEnum.Shape.Block then
      return TerrainConverter:FillBlock(material, cframe, size)

    -- elseif shape == TerrainEnum.Shape.Cylinder then

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
