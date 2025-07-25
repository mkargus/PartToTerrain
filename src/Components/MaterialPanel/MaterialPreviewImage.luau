local React = require(script.Parent.Parent.Parent.Packages.React)

local MATERIAL_IMAGE_BASE = 'rbxasset://textures/TerrainTools/mtrl_%s.png'

type Props = {
  Material: Enum.Material,
  LayoutOrder: number?,
  Size: UDim2?,
  Use2022Materials: boolean?,
}

local function MaterialPreviewImage(props: Props)
  local materialKey = string.lower(props.Material.Name)

  if props.Use2022Materials and props.Material ~= Enum.Material.Air then
    materialKey ..= '_2022'
  end

  return React.createElement('ImageLabel', {
    BackgroundTransparency = 1,
    Image = string.format(MATERIAL_IMAGE_BASE, materialKey),
    LayoutOrder = props.LayoutOrder,
    Size = props.Size,
  }, {
    UICorner = React.createElement('UICorner', {
      CornerRadius = UDim.new(0, 3),
    }),
  })
end

return MaterialPreviewImage
