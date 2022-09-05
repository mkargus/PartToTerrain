-- This grabs the DockWidget Gui to be used for top level stuff.
-- Forked from Roblox's internal UI framework:
-- https://github.com/CloneTrooper1019/Roblox-Client-Tracker/blob/roblox/BuiltInPlugins/Toolbox/Libs/UILibrary/_internal/Focus.lua

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

-- For some unexplained reason, Roact keeps putting the context value to nil even if the PluginGui is noted.
-- If someone is able to improve this script to use Roact's Context system, that would be awesome!
-- Please sumbit a PR because I've wasted 2 days on this dumb thing.

local PluginGUI = nil

-- local Context = Roact.createContext(nil)

--------------------------------------------
-- Provider
--------------------------------------------
local FocusProvider = Roact.PureComponent:extend('FocusProvider')

function FocusProvider:init()
  local pluginGui = self.props.pluginGui
  assert(pluginGui ~= nil, 'No pluginGui was given to this FocusProvider.')

  PluginGUI = pluginGui
end

function FocusProvider:render()
  return Roact.oneChild(self.props[Roact.Children])
end

--------------------------------------------
-- Internal Consumer
--------------------------------------------
local InternalConsumer = Roact.PureComponent:extend('InternalConsumer')

function InternalConsumer:init()
  assert(PluginGUI ~= nil, 'No FocusProvider found.')
  assert(self.props.focusedRender ~= nil, 'Use withFocus, not FocusConsumer.')

  self.pluginGui = PluginGUI
end

function InternalConsumer:render()
  return self.props.focusedRender(self.pluginGui)
end

local function withFocus(callback)
  return Roact.createElement(InternalConsumer, {
    focusedRender = callback
  })
end

return {
  Provider = FocusProvider,
  withFocus = withFocus
}
