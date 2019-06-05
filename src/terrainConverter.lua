local ChangeHistoryService = game:GetService('ChangeHistoryService')

ChangeHistoryService.OnUndo:connect(function(waypoint)
  if waypoint == 'PartToTerrain' then
    game.Selection:Set({})
  end
end)

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

local function RemovePart(part, bool)
  if bool then
    part:remove()
  end
end

local module = {}

function module:Convert(part, material, deleteAfterConvert)
  if part:IsA('Part') then
    if part.Shape == Enum.PartType.Block then
      workspace.Terrain:FillBlock(part.CFrame, part.Size, material)
      RemovePart(part, deleteAfterConvert)
      ChangeHistoryService:SetWaypoint('PartToTerrain')
      return true
    elseif part.Shape == Enum.PartType.Ball then
      workspace.Terrain:FillBall(part.Position, part.Size.X/2, material)
      RemovePart(part, deleteAfterConvert)
      ChangeHistoryService:SetWaypoint('PartToTerrain')
      return true
    else
      error('Part shape is not supported.',0)
    end
  elseif part:IsA('WedgePart') then
    ConvertWedge(part, material)
    RemovePart(part, deleteAfterConvert)
    ChangeHistoryService:SetWaypoint('PartToTerrain')
    return true
  else
    error('Part class is not supported.',0)
  end
end

return module
