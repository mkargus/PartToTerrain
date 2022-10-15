--!nocheck
local Studio = settings():GetService('Studio')

local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Context = Roact.createContext(nil)
local StudioThemeProvider = Roact.Component:extend('StudioThemeProvider')

function StudioThemeProvider:init()
  self.state = {
    theme = Studio.Theme
  }
end

function StudioThemeProvider:render()
  return Roact.createElement(Context.Provider, {
    value = self.state.theme
  }, self.props[Roact.Children])
end

function StudioThemeProvider:didMount()
  self._themeConnection = Studio.ThemeChanged:Connect(function()
    self:setState({ theme = Studio.Theme })
  end)
end

function StudioThemeProvider:willUnmount()
  self._themeConnection:Disconnect()
end

local function withTheme(callback: (theme: StudioTheme) -> any)
  return Roact.createElement(Context.Consumer, {
    render = callback
  })
end

return {
  StudioProvider = StudioThemeProvider,
  withTheme = withTheme
}
