local function FillCylinder(part, material)
  -- FillCylinder will use the wrong orientation without this fix:
  -- https://twitter.com/m_kargus/status/1164330550917832704
  local fixPart = Instance.new('Part')
  fixPart.Orientation = Vector3.new(part.Orientation.X, part.Orientation.Y, part.Orientation.Z - 90)
  fixPart.Position = part.Position
  fixPart.Size = Vector3.new(part.Size.Y, part.Size.X, part.Size.Z)

  workspace.Terrain:FillCylinder(fixPart.CFrame, part.Size.X, part.Size.Y/2, material)
  fixPart:Destroy()
  return true
end

local function Convert(part, material)
  if part:IsA('Part') then
    if part.Shape == Enum.PartType.Block then
      workspace.Terrain:FillBlock(part.CFrame, part.Size, material)
      return true
    elseif part.Shape == Enum.PartType.Ball then
      workspace.Terrain:FillBall(part.Position, part.Size.X/2, material)
      return true
    elseif part.Shape == Enum.PartType.Cylinder then
      FillCylinder(part, material)
      return true
    else
      error('Notice.ShapeNotSupported',0)
    end
  elseif part:IsA('WedgePart') then
    workspace.Terrain:FillWedge(part.CFrame, part.Size, material)
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
