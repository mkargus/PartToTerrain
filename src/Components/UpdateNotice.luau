local MarketplaceService = game:GetService('MarketplaceService')

local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Constants = require(Plugin.Util.Constants)
local Localization = require(Plugin.Util.Localization)

local useTheme = require(Plugin.Hooks.useTheme)

local function UpdateNotice()
  local theme = useTheme()
  local isUpdated, setUpdate = React.useState(false)

  React.useEffect(function()
    local pluginId = Constants.IS_DEV_CHANNEL and Constants.DEV_UPDATE_CHECKER_ID or Constants.UPDATE_CHECKER_ID

    local thread = task.spawn(function()
      local success, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, pluginId)

      if success then
        local latestVersion = string.match(info.Description, '([0-9]+%.[0-9]+%.[0-9]+)')
        if latestVersion and latestVersion ~= Constants.VERSION then
          setUpdate(true)
        end
      end
    end)

    return function()
      task.cancel(thread)
    end
  end, {})

  return isUpdated and React.createElement('Frame', {
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
