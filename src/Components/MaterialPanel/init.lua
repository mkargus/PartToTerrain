local Plugin = script.Parent.Parent

local Roact = require(Plugin.Libs.Roact)

local Constants = require(Plugin.Util.Constants)

local Components = Plugin.Components
local ScrollingFrame = require(Components.ScrollingFrame)
local Store = require(Components.Store)
local Search = require(Components.Search)
local StudioTheme = require(Components.StudioTheme)

-- Might move this to the root Components folder.
local MaterialItem = require(script.Item)

local MaterialPanel = Roact.PureComponent:extend('MaterialPanel')

function MaterialPanel:init()
  self.state = {
    height = 0
  }

  function self._createElements()
    local elements = {}

    for i=1, #Constants.MATERIALS do
      local item = Constants.MATERIALS[i]
      elements[item.enum.Name] = Roact.createElement(MaterialItem, {
        Id = item.enum,
        Image = item.img
      })
    end

    return Roact.createFragment(elements)
  end

  function self._gridSizeChange(rbx)
    self:setState({
      height = rbx.AbsoluteContentSize.Y
    })
  end
end

function MaterialPanel:render()
  local props = self.props
  local state = self.state

  return StudioTheme.withTheme(function(theme)
    return Roact.createElement('Frame', {
      BackgroundTransparency = 1,
      Size = props.Size
    }, {
      UIListLayout = Roact.createElement('UIListLayout', {
        HorizontalAlignment = 'Center',
        Padding = UDim.new(0, 3),
        SortOrder = 'LayoutOrder'
      }),

      topBar = Roact.createElement('Frame', {
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Titlebar),
        BorderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border),
        BorderSizePixel = 1,
        Size = UDim2.new(1, 0, 0, 32)
      }, {
        Searchbar = Roact.createElement(Search, {
          onTextChange = function(rbx)
            Store:Set('SearchTerm', rbx.Text)
          end
        })
      }),

      MaterialContainer = Roact.createElement(ScrollingFrame, {
        CanvasSize = UDim2.new(0, 0, 0, state.height),
        LayoutOrder = 2,
        Size = UDim2.new(1, -3, 1, -30)
      }, {
        Grid = Roact.createElement('UIGridLayout', {
          CellPadding = Constants.MATERIAL_GRID_PADDING,
          CellSize = Constants.MATERIAL_GRID_SIZE,
          FillDirectionMaxCells = 6,
          HorizontalAlignment = Enum.HorizontalAlignment.Center,
          [Roact.Change.AbsoluteContentSize] = self._gridSizeChange
        }),

        Items = Roact.createElement(self._createElements)

      })
    })
  end)
end

return MaterialPanel
