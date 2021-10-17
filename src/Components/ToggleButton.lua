--[[
  A toggle button with on and off state.

  Props:
    bool isEnabled
    UDim2 Position

    callback onClick()
]]

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local StudioTheme = require(Plugin.Components.StudioTheme)

local ToggleButton = Roact.PureComponent:extend('ToggleButton')

function ToggleButton:render()
  local props = self.props

  return StudioTheme.withTheme(function(theme)

    return Roact.createElement('ImageButton', {
      AutoButtonColor = false,
      AnchorPoint = props.AnchorPoint,
      BackgroundColor3 = props.isEnabled and Color3.fromRGB(64, 166, 81) or theme:GetColor(Enum.StudioStyleGuideColor.ScriptWhitespace),
      Size = UDim2.new(0, 40, 0, 24),
      Position = props.Position,
      [Roact.Event.MouseButton1Click] = props.onClick
    }, {
      UICorner = Roact.createElement('UICorner', {
        CornerRadius = UDim.new(1, 0)
      }),

      StateFrame = Roact.createElement('Frame', {
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
        Position = UDim2.new(0, props.isEnabled and 18 or 2, 0, 2),
        Size = UDim2.new(0, 20, 0, 20),
      }, {
        UICorner = Roact.createElement('UICorner', {
          CornerRadius = UDim.new(1, 0)
        })
      })

    })

  end)

end

return ToggleButton
