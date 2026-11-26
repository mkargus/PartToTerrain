--!native
local Constants = require(script.Parent.Constants)
local GetAABBRegion = require(script.Parent.GetAABBRegion)

local RESOLUTION = Constants.VOXEL_RESOLUTION

local TerrainConverter = {}

local function processVoxelRegion(
  cframe: CFrame,
  size: Vector3,
  material: Enum.Material,
  occCallback: (cellPosition: Vector3) -> number
)
  local region = GetAABBRegion(cframe, size)
  local min = region.CFrame.Position - region.Size / 2

  local materialVoxels, occVoxels = workspace.Terrain:ReadVoxels(region, RESOLUTION)
  local regionSize = materialVoxels.Size

  for x = 1, regionSize.X do
    local cellPosX = min.X + (x - 0.5) * RESOLUTION

    for y = 1, regionSize.Y do
      local cellPosY = min.Y + (y - 0.5) * RESOLUTION

      for z = 1, regionSize.Z do
        local cellPosZ = min.Z + (z - 0.5) * RESOLUTION

        local cellPosition = Vector3.new(cellPosX, cellPosY, cellPosZ)
        local targetOcc = occCallback(cellPosition)

        local cellMaterial = materialVoxels[x][y][z]
        local cellOccupancy = occVoxels[x][y][z]

        if targetOcc > cellOccupancy then
          occVoxels[x][y][z] = targetOcc
        end

        if targetOcc >= 0.1 and cellMaterial == Enum.Material.Air then
          materialVoxels[x][y][z] = material
        end
      end
    end
  end

  workspace.Terrain:WriteVoxels(region, RESOLUTION, materialVoxels, occVoxels)
end

function TerrainConverter:FillBall(material: Enum.Material, cframe: CFrame, radius: number, preserveTerrain: boolean?)
  local center = cframe.Position
  local diameter = Vector3.new(radius, radius, radius) * 2

  if not preserveTerrain or material == Enum.Material.Air then
    workspace.Terrain:FillBall(center, radius, material)
    return
  end

  processVoxelRegion(cframe, diameter, material, function(cellPosition)
    local distance = (cellPosition - center).Magnitude
    return math.clamp((radius + 0.5 * RESOLUTION - distance) / RESOLUTION, 0, 1)
  end)
end

function TerrainConverter:FillBlock(material: Enum.Material, cframe: CFrame, size: Vector3, preserveTerrain: boolean?)
  if not preserveTerrain or material == Enum.Material.Air then
    workspace.Terrain:FillBlock(cframe, size, material)
    return
  end

  local sizeCellClamped = (size / RESOLUTION):Min(Vector3.one)
  local sizeCellsHalfOffset = size * (0.5 / RESOLUTION) + Vector3.new(0.5, 0.5, 0.5)

  processVoxelRegion(cframe, size, material, function(cellPosition)
    local offset = cframe:PointToObjectSpace(cellPosition) / RESOLUTION

    local distX = sizeCellsHalfOffset.X - math.abs(offset.X)
    local distY = sizeCellsHalfOffset.Y - math.abs(offset.Y)
    local distZ = sizeCellsHalfOffset.Z - math.abs(offset.Z)

    local factorX = math.max(0, math.min(distX, sizeCellClamped.X))
    local factorY = math.max(0, math.min(distY, sizeCellClamped.Y))
    local factorZ = math.max(0, math.min(distZ, sizeCellClamped.Z))

    return math.min(factorX, factorY, factorZ)
  end)
end

function TerrainConverter:FillCylinder(material: Enum.Material, cframe: CFrame, height: number, radius: number)
  workspace.Terrain:FillCylinder(cframe, height, radius, material)
end

function TerrainConverter:FillWedge(material: Enum.Material, cframe: CFrame, size: Vector3)
  workspace.Terrain:FillWedge(cframe, size, material)
end

return TerrainConverter
