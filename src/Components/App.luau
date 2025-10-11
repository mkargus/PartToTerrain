local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local Localization = require(Plugin.Util.Localization)
local Store = require(Plugin.Util.Store)

local Tooltip = require(Plugin.Components.Tooltip)
local TabSet = require(Plugin.Components.TabSet)
local UpdateNotice = require(Plugin.Components.UpdateNotice)

-- TODO: Put these in a separate folder
local MaterialPanel = require(Plugin.Components.MaterialPanel)
local SettingsPanel = require(Plugin.Components.SettingsPanel)

local useStore = require(Plugin.Hooks.useStore)
local useTheme = require(Plugin.Hooks.useTheme)
local usePlugin = require(Plugin.Hooks.usePlugin)

local function App()
  local theme = useTheme()
  local selectedPanel: string = useStore('Panel')
  local plugin = usePlugin()
  print(plugin)

  local panelElement = React.useMemo(function()
    if selectedPanel == 'Materials' then
      return React.createElement(MaterialPanel)
    elseif selectedPanel == 'Settings' then
      return React.createElement(SettingsPanel)
    else
      return React.createElement('TextLabel', {
        Size = UDim2.fromScale(1, 1),
        Text = "You shouldn't be able to see this.",
      })
    end
  end, { selectedPanel })

  return React.createElement('Frame', {
    BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1),
  }, {
    TooltipContainer = React.createElement(Tooltip.Container),

    Content = React.createElement('Frame', {
      BackgroundTransparency = 1,
      Size = UDim2.fromScale(1, 1),
    }, {
      UIListLayout = React.createElement('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder,
      }),

      UpdateNotice = React.createElement(UpdateNotice),

      Navbar = React.createElement(TabSet, {
        AutomaticSize = Enum.AutomaticSize.Y,
        SelectedTab = selectedPanel,
        LayoutOrder = 2,
        Size = UDim2.fromScale(1, 0),
        Tabs = {
          { Key = 'Materials', Icon = 'rbxassetid://5741677639', Text = Localization('Button.Materials') },
          { Key = 'Settings', Icon = 'rbxassetid://5747147099', Text = Localization('Button.Settings') },
        },
        OnTabSelected = function(tabName)
          Store:Set('Panel', tabName)
        end,
      }),

      Body = React.createElement('Frame', {
        BackgroundTransparency = 1,
        LayoutOrder = 3,
        Size = UDim2.fromScale(1, 1),
      }, {
        UIFlexItem = React.createElement('UIFlexItem', {
          FlexMode = Enum.UIFlexMode.Fill,
        }),
        PanelContent = React.createElement(React.Fragment, nil, panelElement),
      }),
    }),
  })
end

return App
