local Constants = require(script.Parent.Constants)

local outline = Instance.new('SelectionBox')
outline.Parent = game:GetService('CoreGui')
outline.SurfaceTransparency = .7
outline.LineThickness = .1

local function changeColor(color)
  outline.Color3 = color
  outline.SurfaceColor3 = color
end

local module = {}

function module:Destroy()
  outline:Destroy()
end

function module:Hide()
  outline.Adornee = nil
end

function module:Set(part)
  assert(typeof(part) == 'Instance', 'part must be a Instance')

  if part:IsA('BasePart') and not part:IsA('Terrain') then
    if part:IsA('Part') then
      if part.Shape == Enum.PartType.Ball or part.Shape == Enum.PartType.Block or part.Shape == Enum.PartType.Cylinder then
        changeColor(Constants.OUTLINE_COLOR_GREEN)
        outline.Adornee = part
      else
        changeColor(Constants.OUTLINE_COLOR_RED)
        outline.Adornee = part
      end
    elseif part:IsA('WedgePart') then
      changeColor(Constants.OUTLINE_COLOR_GREEN)
      outline.Adornee = part
    else
      changeColor(Constants.OUTLINE_COLOR_RED)
      outline.Adornee = part
    end
  else
    module:Hide()
  end
end

return module
