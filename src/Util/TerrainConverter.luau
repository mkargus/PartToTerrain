--!native
local Constants = require(script.Parent.Constants)
local GetAABBRegion = require(script.Parent.GetAABBRegion)
local TerrainEnum = require(script.Parent.TerrainEnum)

local RESOLUTION = Constants.VOXEL_RESOLUTION
local MAX_VOXEL_LIMIT_READWRITE = 4194304
local MAX_VOXEL_LIMIT_FILLAPIS = 67108864

local TerrainConverter = {}

function TerrainConverter:FillBall(material: Enum.Material, cframe: CFrame, radius: number, preserveTerrain: boolean?): (boolean, string?)
  local center = cframe.Position
  local diameter3 = Vector3.new(radius, radius, radius) * 2
  local region, regionVolume = GetAABBRegion(cframe, diameter3)

  if not preserveTerrain or material == Enum.Material.Air then
    if MAX_VOXEL_LIMIT_FILLAPIS < regionVolume then
      return false, TerrainEnum.ConvertError.RegionTooLarge
    end

    workspace.Terrain:FillBall(center, radius, material)
    return true
  end

  if MAX_VOXEL_LIMIT_READWRITE < regionVolume then
    return false, TerrainEnum.ConvertError.RegionTooLarge
  end

  local materialVoxels, occupancyVoxels = workspace.Terrain:ReadVoxels(region, RESOLUTION)
  local regionSize = materialVoxels.Size

  local min = region.CFrame.Position - region.Size / 2

  for x = 1, regionSize.X do
    local cellX = min.X + (x - 0.5) * RESOLUTION - center.X

    for y = 1, regionSize.Y do
      local cellY = min.Y + (y - 0.5) * RESOLUTION - center.Y

      for z = 1, regionSize.Z do
        local cellZ = min.Z + (z - 0.5) * RESOLUTION - center.Z

        local cellMaterial = materialVoxels[x][y][z]
        local cellOccupancy = occupancyVoxels[x][y][z]

        local distance = math.sqrt(cellX * cellX + cellY * cellY + cellZ * cellZ)
        local brushOcc = math.max(0, math.min(1, (radius + 0.5 * RESOLUTION - distance) / RESOLUTION))

        if brushOcc > cellOccupancy then
          occupancyVoxels[x][y][z] = brushOcc
        end

        if brushOcc >= 0.1 and cellMaterial == Enum.Material.Air then
          materialVoxels[x][y][z] = material
        end

      end
    end
  end

  workspace.Terrain:WriteVoxels(region, RESOLUTION, materialVoxels, occupancyVoxels)
  return true
end

function TerrainConverter:FillBlock(material: Enum.Material, cframe: CFrame, size: Vector3, preserveTerrain: boolean?): (boolean, string?)
  local region, regionVolume = GetAABBRegion(cframe, size)

  if not preserveTerrain or material == Enum.Material.Air then
    if MAX_VOXEL_LIMIT_FILLAPIS < regionVolume then
      return false, TerrainEnum.ConvertError.RegionTooLarge
    end

    workspace.Terrain:FillBlock(cframe, size, material)
    return true
  end

  if MAX_VOXEL_LIMIT_READWRITE < regionVolume then
    return false, TerrainEnum.ConvertError.RegionTooLarge
  end

  local min = region.CFrame.Position - region.Size / 2
  local materialVoxels, occupancyVoxels = workspace.Terrain:ReadVoxels(region, RESOLUTION)

  local regionSize = materialVoxels.Size

  local sizeCellClamped = (size / RESOLUTION):Min(Vector3.one)
  local sizeCellsHalfOffset = size * (0.5 / RESOLUTION) + Vector3.new(0.5, 0.5, 0.5)

  for x = 1, regionSize.X do
    local cellPosX = min.X + (x - 0.5) * RESOLUTION

    for y = 1, regionSize.Y do
      local cellPosY = min.Y + (y - 0.5) * RESOLUTION

      for z = 1, regionSize.Z do
        local cellPosZ = min.Z + (z - 0.5) * RESOLUTION

        local cellPosition = Vector3.new(cellPosX, cellPosY, cellPosZ)
        local offset = cframe:PointToObjectSpace(cellPosition) / RESOLUTION

        local distX = sizeCellsHalfOffset.X - math.abs(offset.X)
        local distY = sizeCellsHalfOffset.Y - math.abs(offset.Y)
        local distZ = sizeCellsHalfOffset.Z - math.abs(offset.Z)

        local factorX = math.max(0, math.min(distX, sizeCellClamped.X))
        local factorY = math.max(0, math.min(distY, sizeCellClamped.Y))
        local factorZ = math.max(0, math.min(distZ, sizeCellClamped.Z))

        local brushOcc = math.min(factorX, factorY, factorZ)

        local cellMaterial = materialVoxels[x][y][z]
        local cellOccupancy = occupancyVoxels[x][y][z]

        if brushOcc > cellOccupancy then
          occupancyVoxels[x][y][z] = brushOcc
        end

        if brushOcc >= 0.1 and cellMaterial == Enum.Material.Air then
          materialVoxels[x][y][z] = material
        end

      end
    end
  end

  workspace.Terrain:WriteVoxels(region, RESOLUTION, materialVoxels, occupancyVoxels)
  return true
end

function TerrainConverter:FillCylinder(material: Enum.Material, cframe: CFrame, height: number, radius: number): boolean
  workspace.Terrain:FillCylinder(cframe, height, radius, material)
  return true
end

function TerrainConverter:FillWedge(material: Enum.Material, cframe: CFrame, size: Vector3): boolean
  workspace.Terrain:FillWedge(cframe, size, material)
  return true
end

return TerrainConverter
