local greenColor = Color3.fromRGB(67,160,71)
local redColor = Color3.fromRGB(229,57,53)

local outline = Instance.new('SelectionBox')
outline.Parent = game.CoreGui
outline.SurfaceTransparency = .7
outline.LineThickness = .1

local function changeColor(color)
  outline.Color3 = color
  outline.SurfaceColor3 = color
end

local module = {}

function module:Hide()
  outline.Adornee = nil
end

function module:Set(part)
  if part:IsA('BasePart') and not part:IsA('Terrain') then
    if part:IsA('Part') then
      if part.Shape == Enum.PartType.Ball or part.Shape == Enum.PartType.Block then
        changeColor(greenColor)
        outline.Adornee = part
      else
        changeColor(redColor)
        outline.Adornee = part
      end
    elseif part:IsA('WedgePart') then
      changeColor(greenColor)
      outline.Adornee = part
    else
      changeColor(redColor)
      outline.Adornee = part
    end
  else
    module:Hide()
  end
end

return module