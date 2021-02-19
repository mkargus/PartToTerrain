local Constants = require(script.Parent.Constants)

local function IsPartValid(part)
  local validShapes = {
    [Enum.PartType.Block] = true,
    [Enum.PartType.Ball] = true,
    [Enum.PartType.Cylinder] = true
  }

  if part:IsA('WedgePart') or part:IsA('Part') and validShapes[part.Shape] then
    return true
  else
    return false
  end
end

local function ChangeColor(self, color)
  self.Gui.SelectionBox.Color3 = color
  self.Gui.SelectionBox.SurfaceColor3 = color
end

local Outline = {}
Outline.__index = Outline

function Outline.new()
  local newOutline = {}
  setmetatable(newOutline, Outline)

  newOutline.Part = nil

  newOutline.Gui = Instance.new('Folder')
  newOutline.Gui.Name = 'PTT'
  newOutline.Gui.Parent = game:GetService('CoreGui')

  local SelectionBox = Instance.new('SelectionBox')
  SelectionBox.Parent = newOutline.Gui
  SelectionBox.SurfaceTransparency = 0.7
  SelectionBox.LineThickness = 0.1

  return newOutline
end

function Outline:Set(part)
  self.Part = part
  self.Gui.SelectionBox.Adornee = self.Part

  if part and IsPartValid(part) then
    ChangeColor(self, Constants.OUTLINE_COLOR_ALLOW)
  else
    ChangeColor(self, Constants.OUTLINE_COLOR_ERROR)
  end

end

function Outline:Despawn()
  self.Gui:Destroy()
  self = nil
end

return Outline
