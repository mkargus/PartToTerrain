local React = require(script.Parent.Parent.Packages.React)

local Localization = require('../Util/Localization')

local useTheme = require('../Hooks/useTheme')

local function UpdateNotice()
  local theme = useTheme()

  return React.createElement('Frame', {
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Titlebar),
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 0),
  }, {
    UIListLayout = React.createElement('UIListLayout', {
      FillDirection = Enum.FillDirection.Horizontal,
      Padding = UDim.new(0, 6),
      SortOrder = Enum.SortOrder.LayoutOrder,
    }),

    TextLabel = React.createElement('TextLabel', {
      AutomaticSize = Enum.AutomaticSize.Y,
      BackgroundTransparency = 1,
      FontFace = Font.fromEnum(Enum.Font.BuilderSans),
      LayoutOrder = 2,
      RichText = true,
      Text = Localization('Notice.Outdated'),
      TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
      TextSize = 16,
      TextWrapped = true,
      TextXAlignment = Enum.TextXAlignment.Left,
    }, {
      UIFlexItem = React.createElement('UIFlexItem', {
        FlexMode = Enum.UIFlexMode.Fill,
        ItemLineAlignment = Enum.ItemLineAlignment.Stretch,
      }),
    }),

    UIPadding = React.createElement('UIPadding', {
      PaddingBottom = UDim.new(0, 3),
      PaddingLeft = UDim.new(0, 3),
      PaddingRight = UDim.new(0, 3),
      PaddingTop = UDim.new(0, 3),
    }),

    ImageLabel = React.createElement('ImageLabel', {
      BackgroundTransparency = 1,
      Image = 'rbxassetid://7152791295',
      ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
      Size = UDim2.fromOffset(18, 18),
    }),
  })
end

return UpdateNotice
