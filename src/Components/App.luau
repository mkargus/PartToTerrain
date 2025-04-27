local React = require(script.Parent.Parent.Packages.React)

local Localization = require('../Util/Localization')
local Store = require('../Util/Store')

local Tooltip = require('./Tooltip')
local TabSet = require('./TabSet')
-- local UpdateNotice = require('./UpdateNotice')

-- TODO: Put these in a separate folder
local MaterialPanel = require('./MaterialPanel')
local SettingsPanel = require('./SettingsPanel')

local useStore = require('../Hooks/useStore')
local useTheme = require('../Hooks/useTheme')

local function App(props)
  local theme = useTheme()
  local CurrentPanel = useStore('Panel')

  local PanelElement = React.useMemo(function()
    if CurrentPanel == 'Materials' then
      return React.createElement(MaterialPanel)
    elseif CurrentPanel == 'Settings' then
      return React.createElement(SettingsPanel)
    else
      return React.createElement('TextLabel', {
        Size = UDim2.fromScale(1, 1),
        Text = "You shouldn't be able to see this."
      })
    end
  end, { CurrentPanel })

  return React.createElement('Frame', {
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1)
  }, {
    TooltipContainer = React.createElement(Tooltip.Container),

    Content = React.createElement('Frame', {
      BackgroundTransparency = 1,
      Size = UDim2.fromScale(1, 1)
    }, {
      UIListLayout = React.createElement('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder
      }),
      -- UpdateNotice = React.createElement(UpdateNotice),

      Navbar = React.createElement(TabSet, {
        AutomaticSize = Enum.AutomaticSize.Y,
        CurrentTab = CurrentPanel,
        LayoutOrder = 2,
        Size = UDim2.new(1, 0, 0, 0),
        Tabs = {
          { Key = 'Materials', Icon = 'rbxassetid://5741677639', Text = Localization('Button.Materials') },
          { Key = 'Settings', Icon = 'rbxassetid://5747147099', Text = Localization('Button.Settings') },
        },
        onTabSelected = function(tabName)
          Store:Set('Panel', tabName)
        end
      }),

      Body = React.createElement('Frame', {
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Size = UDim2.fromScale(1, 1)
      }, {
        UIFlexItem =  React.createElement("UIFlexItem", {
          FlexMode = Enum.UIFlexMode.Fill,
        }),
        PanelElement
      })
    })
  })
end

return App
