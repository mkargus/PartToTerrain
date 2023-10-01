--[[
  A toggle button with on and off state.

  Props:
    bool isEnabled
    UDim2 Position

    callback onClick()
]]

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local StudioTheme = require(Plugin.Context.StudioTheme)

local function ToggleButton(props)
  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('ImageButton', {
      AutoButtonColor = false,
      AnchorPoint = props.AnchorPoint,
      BackgroundColor3 = props.isEnabled and Color3.fromRGB(64, 166, 81) or theme:GetColor(Enum.StudioStyleGuideColor.ScriptWhitespace),
      Size = UDim2.fromOffset(40, 24),
      Position = props.Position,
      [Roact.Event.MouseButton1Click] = props.onClick
    }, {
      UICorner = Roact.createElement('UICorner', {
        CornerRadius = UDim.new(1, 0)
      }),
      StateFrame = Roact.createElement('Frame', {
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
        Position = UDim2.fromOffset(props.isEnabled and 18 or 2, 2),
        Size = UDim2.fromOffset(20, 20)
      }, {
        UICorner = Roact.createElement('UICorner', {
          CornerRadius = UDim.new(1, 0)
        })
      })
    })
  end)
end

return ToggleButton
