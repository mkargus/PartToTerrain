local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Util = Plugin.Util
local Localization = require(Util.Localization)
local Store = require(Util.Store)

local Components = Plugin.Components
local StudioTheme = require(Components.StudioTheme)
local MaterialPanel = require(Components.MaterialPanel)
local SettingsPanel = require(Components.SettingsPanel)
local TextLabel = require(Components.TextLabel)
local Header = require(Components.Header)

local App = Roact.PureComponent:extend('App')

function App:renderBody(Panel)
  if Panel == 'Materials' then
    return Roact.createElement(MaterialPanel, {
      Size = self.props.IsOutdated and UDim2.new(1, 0, 1, -53) or UDim2.new(1, 0, 1, -60)
    })
  elseif Panel == 'Settings' then
    return Roact.createElement(SettingsPanel, {
      Size = self.props.IsOutdated and UDim2.new(1, 0, 1, -53) or UDim2.new(1, 0, 1, -28)
    })
  end
end

function App:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
      BorderSizePixel = 0,
      Size = UDim2.fromScale(1, 1)
    }, {
      Header = Roact.createElement(Header, {
        CurrentPanel = state.Panel,
        IsSearchEnabled = state.Panel == 'Materials'
      }),

      UIListLayout = Roact.createElement('UIListLayout', {
        SortOrder = Enum.SortOrder.LayoutOrder
      }),

      Body = self:renderBody(state.Panel),

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

return Store:Roact(App, { 'Panel' })
