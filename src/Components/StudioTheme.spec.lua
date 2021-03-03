-- local Studio = settings():GetService('Studio')

local Roact = require(script.Parent.Parent.Libs.Roact)

local StudioTheme = require(script.Parent.StudioTheme)

return function()
  it('should mount and unmount without errors', function()

    local element = StudioTheme.withTheme(function(theme)
      return Roact.createElement('Frame', {
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
      })
    end)

    local instance = Roact.mount(element)
    Roact.unmount(instance)
  end)

end
