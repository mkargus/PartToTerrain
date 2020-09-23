local Modules = script.Parent.Parent.Parent
local Roact = require(Modules.Libs.Roact)

local Store = require(script.Parent.Parent.Store)

local Constants = require(Modules.Util.Constants)
local Localization = require(Modules.Util.Localization)
local ThemedTextLabel = require(script.Parent.Parent.ThemedTextLabel)

local function getTextSize(Text)
  local TextService = game:GetService("TextService")
  local tb = TextService:GetTextSize(Text, 16, 'SourceSans', Vector2.new(100000, 100000))
  return UDim2.new(0, tb.X + 3, 0, tb.Y + 3)
end

local function MaterialItem()
  local elements = {}

  for i=1, #Constants.MATERIALS do
    local item = Constants.MATERIALS[i]
    elements[item.enum.Name] = Roact.createElement('ImageButton', {
      BackgroundTransparency = 1,
      Image = item.img,
      [Roact.Event.MouseButton1Click] = function()
        Store:Set('Material', item.enum)
      end,
      [Roact.Event.MouseEnter] = function(rbx)
        local tooltip = rbx:WaitForChild('Tooltip')
        tooltip.Visible = true
      end,
      [Roact.Event.MouseLeave] = function(rbx)
        local tooltip = rbx:WaitForChild('Tooltip')
        tooltip.Visible = false
      end,
      [Roact.Event.MouseMoved] = function(rbx, x, y)
        local tooltip = rbx:WaitForChild('Tooltip')
        tooltip.Position = UDim2.new(0, x - rbx.AbsolutePosition.X - 5, 0, y - rbx.AbsolutePosition.Y - 20)
      end
    }, {
      SelectedImage = Roact.createElement('ImageLabel', {
        BackgroundTransparency = 1,
        Image = Constants.MATERIAL_SELECTED_IMAGE,
        Size = UDim2.new(0.5,0,0.5,0),
        Position = UDim2.new(0.5,0,0,0),
        Visible = Store:Get('Material') == item.enum
      }),
      Tooltip = Roact.createElement(ThemedTextLabel, {
        BackgroundTransparency = 0.3,
        TextSize = 16,
        TextWrapped = false,
        Visible = false,
        Text = Localization('Materials.'..item.enum.Name),
        Size = getTextSize(Localization('Materials.'..item.enum.Name)),
        ZIndex = 10^3
      })
    })
  end

  return Roact.createFragment(elements)
end

return MaterialItem
