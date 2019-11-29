local Modules = script.Parent
local Roact = require(Modules.Parent.Roact)

local StudioTheme = require(Modules.StudioTheme)
local TextLabel = require(Modules.TextLabel)

return function(props)
  local kind = props.TextColor or 'MainText'
  local state = props.state or 'Default'

  return StudioTheme.withTheme(function(theme)
    local newProps = {
      TextColor3 = theme:GetColor(kind, state)
    }
    for key, value in pairs(props) do
      if key ~= 'TextColor' and key ~= 'state' then
        newProps[key] = value
      end
    end
    return Roact.createElement(TextLabel, newProps)
  end)
end