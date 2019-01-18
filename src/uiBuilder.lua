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

function module:CreateSettingBtn(parent, text, value, desc)
  local txt = module:createElement('TextLabel', {
    Parent = parent,
    BackgroundColor3 = Enum.StudioStyleGuideColor.Shadow,
    Size = UDim2.new(1,-12,0,25),
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
    Position = UDim2.new(1,-25,0.1,0),
    Size = UDim2.new(0,20,0,20)
  })

  local descLabel = module:createElement('TextLabel', {
    Parent = txt,
    BackgroundColor3 = Enum.StudioStyleGuideColor.InputFieldBorder,
    BackgroundTransparency = .2,
    Font = 'SourceSans',
    Position = UDim2.new(0,5,1,0),
    Size = UDim2.new(1,-7,0,80),
    ZIndex = 5000,
    Visible = false,
    Text = ' '..desc,
    TextColor3 = Enum.StudioStyleGuideColor.MainText,
    TextSize = 14,
    TextWrapped = true,
    TextXAlignment = 'Left'
  })

  txt.MouseEnter:connect(function()
    descLabel.Visible = true
  end)

  txt.MouseLeave:connect(function()
    descLabel.Visible = false
  end)

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