local Studio = settings().Studio
local module = {}

local studioThemeWhitelist = {
  ['BackgroundColor3'] = true,
  ['TextColor3'] = true,
  ['ImageColor3'] = true,
  ['ScrollBarImageColor3'] = true
}

function module:createElement(class, props)
  warn('uiBuilder is deprecated. Use Roact.createElement instead of uiBuilder:createElement.')
  local element = Instance.new(class)

  if element:IsA('GuiObject') then element.BorderSizePixel = 0 end

  for key, value in pairs(props) do
    if element:IsA('GuiObject') and studioThemeWhitelist[key] then
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

return module
