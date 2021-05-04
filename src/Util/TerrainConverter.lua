local TerrainEnum = require(script.Parent.TerrainEnum)

local RESOLUTION = 4
local MAX_VOXEL_LIMIT_READWRITE = 4194304
local MAX_VOXEL_LIMIT_FILLAPIS = 67108864

local function GetAABBRegion(cframe: CFrame, size: Vector3)
  local inv = cframe:Inverse()
  local x = size * inv.RightVector
  local y = size * inv.UpVector
  local z = size * inv.LookVector

  local w = math.abs(x.X) + math.abs(x.Y) + math.abs(x.Z)
  local h = math.abs(y.X) + math.abs(y.Y) + math.abs(y.Z)
  local d = math.abs(z.X) + math.abs(z.Y) + math.abs(z.Z)

  local pos = cframe.Position
  local halfSize = Vector3.new(w, h, d) / 2

  local region = Region3.new(pos - halfSize, pos + halfSize):ExpandToGrid(RESOLUTION)
  local regionVolume = (region.Size.X / RESOLUTION) * (region.Size.Y / RESOLUTION) * (region.Size.Z / RESOLUTION)

  return region, regionVolume
end

local TerrainConverter = {}

function TerrainConverter:FillBall(material, center, radius)
  workspace.Terrain:FillBall(center, radius, material)
  return true
end

function TerrainConverter:FillBlock(material, cframe, size, preserveTerrain)
  if not preserveTerrain or material == Enum.Material.Air then
    local _, regionVolume = GetAABBRegion(cframe, size)

    if MAX_VOXEL_LIMIT_FILLAPIS < regionVolume then
      return false, TerrainEnum.ConvertError.RegionTooLarge
    end

    workspace.Terrain:FillBlock(cframe, size, material)
    return true
  end

  local region, regionVolume = GetAABBRegion(cframe, size)

  if MAX_VOXEL_LIMIT_READWRITE < regionVolume then
    return false, TerrainEnum.ConvertError.RegionTooLarge
  end

  local min = region.CFrame.Position - region.Size / 2
  local materialVoxels, occupancyVoxels = workspace.Terrain:ReadVoxels(region, RESOLUTION)

  local RegionSize = materialVoxels.Size

  local sizeCellClamped = size / RESOLUTION
  sizeCellClamped = Vector3.new(
    math.min(1, sizeCellClamped.X),
    math.min(1, sizeCellClamped.Y),
    math.min(1, sizeCellClamped.Z))

  local sizeCellsHalfOffset = size * (0.5 / RESOLUTION) + Vector3.new(0.5, 0.5, 0.5)

  for x = 1, RegionSize.X do
    local cellPosX = min.X + (x - 0.5) * RESOLUTION

    for y = 1, RegionSize.Y do
      local cellPosY = min.Y + (y - 0.5) * RESOLUTION

      for z = 1, RegionSize.Z do
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

function TerrainConverter:FillCylinder(material, cframe, height, radius)
  workspace.Terrain:FillCylinder(cframe, height, radius, material)
  return true
end

function TerrainConverter:FillWedge(material, cframe, size)
  workspace.Terrain:FillWedge(cframe, size, material)
  return true
end

return TerrainConverter
