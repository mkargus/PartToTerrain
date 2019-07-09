-- TODO: Allow to fill reather then drawing a outline on the top.
local function ConvertWedge(wedge, mat)
  local x = wedge.Size.X
  for i = 0, x do
    local point1 = wedge.CFrame*CFrame.new(x/-2+i,wedge.Size.Y/2,wedge.Size.Z/2)
    local point2 = wedge.CFrame*CFrame.new(x/-2+i,wedge.Size.Y/-2,wedge.Size.Z/-2)
    local point3 = wedge.CFrame*CFrame.new(x/-2+i,wedge.Size.Y/-2,wedge.Size.Z/2)
    local lerpGuess = (point2.p-point1.p).magnitude + (point3.p-point1.p).magnitude
    for lerpA = 0, 1, 1/lerpGuess do
      local p1 = point1.p:lerp(point2.p,lerpA)
      local p2 = point3.p:lerp(point2.p,lerpA)
      local dist = (p2-p1).magnitude
      for lerpB = 0,1,1/dist do
        local p = point1.p:lerp(point2.p,lerpB)
        workspace.Terrain:FillBall(p,1,mat)
      end
    end
  end
end

local function Convert(part, material)
  if part:IsA('Part') then
    if part.Shape == Enum.PartType.Block then
      workspace.Terrain:FillBlock(part.CFrame, part.Size, material)
      return true
    elseif part.Shape == Enum.PartType.Ball then
      workspace.Terrain:FillBall(part.Position, part.Size.X/2, material)
      return true
    --elseif part.Shape == Enum.PartType.Cylinder then
      --workspace.Terrain:FillCylinder(part.CFrame, part.Size.X, part.Size.Y/1.75, material)
    else
      error('Notice.ShapeNotSupported',0)
    end
  elseif part:IsA('WedgePart') then
    ConvertWedge(part, material)
    return true
  else
    error('Notice.ClassNotSupport',0)
  end
end

local module = {}

function module:Convert(part, material, ignoreLockedParts)
  if ignoreLockedParts then
    if part.Locked then
      error('Notice.IgnoreLockedPart',0)
    else
      return Convert(part, material)
    end
  else
    return Convert(part, material)
  end
end

return module
