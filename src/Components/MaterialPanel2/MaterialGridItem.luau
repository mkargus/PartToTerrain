local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)

local MaterialImage = require(script.Parent.MaterialImage)

local useTheme = require(Plugin.Hooks.useTheme)

type Props = {
  Material: Enum.Material,
  Selected: boolean?,
  OnClick: () -> ()?
}

local function MaterialGridItem(props: Props)
  local theme = useTheme()

  local borderColor = Enum.StudioStyleGuideColor.Border
  if props.Selected then
    borderColor = Enum.StudioStyleGuideColor.LinkText
  end

  local onClick = React.useCallback(function()
    if props.OnClick then
      props.OnClick()
    end
  end, { props.OnClick })

  return React.createElement('ImageButton', {
    AutoButtonColor = false,
    BackgroundColor3 = theme:GetColor(borderColor),
    [React.Event.MouseButton1Click] = onClick
  }, {
    UICorner = React.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3),
    }),

    UIPadding = React.createElement('UIPadding', {
      PaddingBottom = UDim.new(0, 1),
      PaddingLeft = UDim.new(0, 1),
      PaddingRight = UDim.new(0, 1),
      PaddingTop = UDim.new(0, 1),
    }),

    Frame = React.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Button),
      Size = UDim2.fromScale(1, 1),
    }, {
      UICorner = React.createElement('UICorner', {
        CornerRadius = UDim.new(0, 3),
      }),

      MaterialImage = React.createElement(MaterialImage, {
        Material = props.Material,
        Size = UDim2.fromScale(1, 1)
      }),

      UIPadding = React.createElement('UIPadding', {
        PaddingBottom = UDim.new(0, 2),
        PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 2),
        PaddingTop = UDim.new(0, 2),
      }),
    }),
  })
end

return MaterialGridItem
