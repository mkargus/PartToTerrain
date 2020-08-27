local ChangeHistoryService = game:GetService('ChangeHistoryService')

-- This is a fix for a unintended side effect when undoing,
-- where it will select the part and give it a outline.
ChangeHistoryService.OnUndo:Connect(function(waypoint)
  if waypoint == 'PartToTerrain' then
    game:GetService('Selection'):Set({})
  end
end)

local function FillCylinder(part, material)
  -- FillCylinder will use the wrong orientation without this fix:
  -- https://devforum.roblox.com/t/terrain-fillcylinder-rotating-incorrectly/336086

  -- Clone the orignal part
  local fixPart = part:Clone()

  -- Fix to use the correct orientation
  fixPart.Orientation = Vector3.new(part.Orientation.X, part.Orientation.Y, part.Orientation.Z - 90)

  -- Convert using the fixed part.
  workspace.Terrain:FillCylinder(fixPart.CFrame, part.Size.X, part.Size.Y / 2, material)

  -- Delete the clone as it's no longer needed.
  fixPart:Destroy()
end

local function convertTerrain(part, material)
  if part:IsA('Part') then
    if part.Shape == Enum.PartType.Block then
      workspace.Terrain:FillBlock(part.CFrame, part.Size, material)
    elseif part.Shape == Enum.PartType.Ball then
      workspace.Terrain:FillBall(part.Position, part.Size.X / 2, material)
    elseif part.Shape == Enum.PartType.Cylinder then
      FillCylinder(part, material)
    else
      -- Shape is not supported, so throw a error.
      error('Notice.ShapeNotSupported', 0)
    end

  elseif part:IsA('WedgePart') then
    workspace.Terrain:FillWedge(part.CFrame, part.Size, material)

  else
    -- Acts as a fallback if the class is not support.
    error('Notice.ClassNotSupport', 0)
  end
end

function Convert(part, material, deletePart, ignoreLockedParts)
  -- Type checking since "strict" mode doesn't do anything.
  assert(part:IsA('BasePart'), 'part must be a Basepart')

  assert(typeof(material) == 'EnumItem', 'material must be a EnumItem')
  assert(material.EnumType == Enum.Material, 'material needs to be from the Material enum')

  assert(typeof(deletePart) == 'boolean', 'deletePart must be a boolean')
  assert(typeof(ignoreLockedParts) == 'boolean', 'ignoreLockedParts must be a boolean')

  -- If ignoreLockedParts is true and the part is locked then return nothing.
  if ignoreLockedParts and part.Locked then
    return
  end

  -- Converts the part
  convertTerrain(part, material)

  -- If deletePart is set to true, change the part's Parent to nil.
  -- Don't use :Destory() as the user might undo the converting and the part needs to be restored.
  if deletePart then
    part.Parent = nil
  end

  -- Allows the user to undo the change.
  ChangeHistoryService:SetWaypoint('PartToTerrain')

  -- Everything worked as intended, return success.
  return true

end

return Convert
