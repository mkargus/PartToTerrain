local Plugin = script.Parent.Parent

local React = require(Plugin.Packages.React)

local IconButton = require(Plugin.Components.IconButton)
local ScrollingFrame = require(Plugin.Components.ScrollingFrame)
local Search = require(Plugin.Components.Search)

local function Materials()
  return React.createElement(React.Fragment, nil, {
    Search = React.createElement(Search, {
      PlaceholderText = 'Search',
      Position = UDim2.fromOffset(3, 3)
    }),

    Settings = React.createElement(IconButton, {
      Position = UDim2.new(1, -33, 0, 3),
      Icon = 'rbxassetid://5747147099',
      onClick = function()
        print('sads')
      end
    }),

    ScrollingFrame = React.createElement(ScrollingFrame, {
      Position = UDim2.fromOffset(3, 36),
      Size = UDim2.new(1, -6, 1, -39)
    })
  })
end

return Materials
