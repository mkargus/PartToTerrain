local Roact = require(script.Parent.Parent.Libs.Roact)
local StudioTheme = Roact.PureComponent:extend('StudioTheme')

function StudioTheme:init()
  local studioSettings = settings().Studio

  self.state = {
    theme = studioSettings.Theme,
    themeEnum = studioSettings['UI Theme']
  }

  self._themeConnection = studioSettings.ThemeChanged:connect(function()
    self:setState({
      theme = studioSettings.Theme,
      themeEnum = studioSettings['UI Theme']
    })
  end)
end

function StudioTheme:willUnmount()
  self._themeConnection:Disconnect()
end

function StudioTheme:render()
  local render = Roact.oneChild(self.props[Roact.Children])
  return render(self.state.theme, self.state.themeEnum)
end

function StudioTheme.withTheme(render)
  return Roact.createElement(StudioTheme, {}, {
    render = render
  })
end

return StudioTheme
