local studioSettings = settings():GetService('Studio')

local Roact = require(script.Parent.Parent.Packages.Roact)
local StudioTheme = Roact.Component:extend('StudioTheme')

function StudioTheme:init()
  self.state = {
    theme = studioSettings.Theme
  }
end

function StudioTheme:didMount()
  self._themeConnection = studioSettings.ThemeChanged:Connect(function()
    self:setState({
      theme = studioSettings.Theme
    })
  end)
end

function StudioTheme:render()
  local render = Roact.oneChild(self.props[Roact.Children])
  return render(self.state.theme)
end

function StudioTheme:willUnmount()
  self._themeConnection:Disconnect()
end

function StudioTheme.withTheme(callback)
  return Roact.createElement(StudioTheme, {}, {
    render = callback
  })
end

return StudioTheme
