local RESOLUTION = require(script.Parent.Constants).VOXEL_RESOLUTION

return function(cframe: CFrame, size: Vector3): (Region3, number)
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
