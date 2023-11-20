local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)
local Hooks = require(Plugin.Packages.RoactHooks)

local Util = Plugin.Util
local Localization = require(Util.Localization)

local StudioTheme = require(Plugin.Context.StudioTheme)

local Components = Plugin.Components
local MaterialPanel = require(Components.MaterialPanel)
local SettingsPanel = require(Components.SettingsPanel)
local TextLabel = require(Components.TextLabel)
local Header = require(Components.Header)

local useStore = require(Plugin.Hooks.useStore)

local function App(props, hooks)
  local CurrentPanel = useStore(hooks, 'Panel')

  local PanelElement = hooks.useMemo(function()
    if CurrentPanel == 'Materials' then
      return Roact.createElement(MaterialPanel, {
        Size = props.IsOutdated and UDim2.new(1, 0, 1, -78) or UDim2.new(1, 0, 1, -60)
      })
    elseif CurrentPanel == 'Settings' then
      return Roact.createElement(SettingsPanel, {
        Size = props.IsOutdated and UDim2.new(1, 0, 1, -53) or UDim2.new(1, 0, 1, -28)
      })
    else
      error('Requested unknown panel.')
    end
  end, { CurrentPanel })

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
      BorderSizePixel = 0,
      Size = UDim2.fromScale(1, 1)
    }, {
      Header = Roact.createElement(Header, {
        CurrentPanel = CurrentPanel,
        IsSearchEnabled = CurrentPanel == 'Materials'
      }),

      UIListLayout = Roact.createElement('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder
      }),

      Body = PanelElement,

      update = props.IsOutdated and Roact.createElement(TextLabel, {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Titlebar),
        LayoutOrder = -1,
        Text = Localization('Notice.Outdated'),
        TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
        TextSize = 12,
        TextWrapped = true,
        Size = UDim2.fromScale(1, 0)
      }, {
        UIPadding = Roact.createElement('UIPadding', {
          PaddingBottom = UDim.new(0, 3),
          PaddingTop = UDim.new(0, 3)
        })
      })

    })
  end)
end

App = Hooks.new(Roact)(App)

return App
