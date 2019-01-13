local Studio = settings().Studio
local module = {}

function module:createElement(class, input)
  local element = Instance.new(class)
  element.BorderSizePixel = 0
  for key, value in pairs(input) do
    -- For now, use Enums only for Studio Color Styles.
    if typeof(value) == 'EnumItem' then
      element[key] = Studio.Theme:GetColor(value)
      Studio.ThemeChanged:connect(function()
        element[key] = Studio.Theme:GetColor(value)
      end)
    else
      element[key] = value
    end
  end
  return element
end

function module:CreateSettingBtn(parent, text, value)
  local txt = module:createElement('TextLabel', {
    Parent = parent,
    BackgroundColor3 = Enum.StudioStyleGuideColor.InputFieldBorder,
    Size = UDim2.new(1,-7,0,30),
    Font = 'SourceSans',
    -- Text needs a padding on the side hence why the space is there.
    Text = ' '..text,
    TextColor3 = Enum.StudioStyleGuideColor.MainText,
    TextSize = 14,
    TextXAlignment = 'Left'
  })

  local btn = module:createElement('ImageButton',{
    Parent = txt,
    BackgroundColor3 = Enum.StudioStyleGuideColor.MainBackground,
    ImageColor3 = Enum.StudioStyleGuideColor.MainText,
    Position = UDim2.new(1,-25,0,5),
    Size = UDim2.new(0,20,0,20)
  })

  if value then
    btn.Image = 'rbxasset://textures/ui/LuaChat/icons/ic-check@3x.png'
  end
  return txt
end

function module:CreateGrid(class, input)
  local grid = Instance.new(class)
  for key, value in pairs(input) do
    grid[key] = value
  end
  return grid
end

return module