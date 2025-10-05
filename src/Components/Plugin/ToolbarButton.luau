local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)

local ToolbarContext = require(Plugin.Context.Toolbar)

type Props = {
  Id: string,

  Tooltip: string?,
  Icon: string?,
  Text: string?,
  ClickableWhenViewportHidden: boolean?,
  Enabled: boolean?,
  Active: boolean?,
  OnClick: () -> ()?,
}

local function ToolbarButton(props: Props)
  local toolbar = React.useContext(ToolbarContext)

  local tooltip = props.Tooltip or ''
  local icon = props.Icon or ''
  local active = props.Active or false

  local button = React.useRef(nil :: PluginToolbarButton?)

  React.useEffect(function()
    local newButton = toolbar:CreateButton(props.Id, tooltip, icon, props.Text)
    button.current = newButton
  end, {})

  React.useEffect(function()
    if button.current and props.OnClick then
      local connection = button.current.Click:Connect(props.OnClick)
      return function()
        connection:Disconnect()
      end
    end
  end, { props.OnClick })

  React.useEffect(function()
    if button.current then
      button.current:SetActive(active)
    end
  end, { active })

  return nil
end

return ToolbarButton
