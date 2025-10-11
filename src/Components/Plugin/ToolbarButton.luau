local Plugin = script.Parent.Parent.Parent

local React = require(Plugin.Packages.React)

local ToolbarContext = require(Plugin.Context.Toolbar)

export type Props = {
  Id: string,

  Tooltip: string?,
  Icon: string?,
  Text: string?,
  ClickableWhenViewportHidden: boolean?,
  Enabled: boolean?,
  Active: boolean?,

  --- asfd
  onClick: () -> ()?,
}

local function ToolbarButton(props: Props)
  local toolbar = React.useContext(ToolbarContext)

  local tooltip = props.Tooltip or ''
  local icon = props.Icon or ''
  local active = props.Active or false
  local enabled = props.Enabled or true
  local clickableWhenViewportHidden = props.ClickableWhenViewportHidden or false

  local button = React.useRef(nil :: PluginToolbarButton?)

  React.useEffect(function()
    local newButton = toolbar:CreateButton(props.Id, tooltip, icon, props.Text)
    newButton.ClickableWhenViewportHidden = clickableWhenViewportHidden
    newButton.Enabled = enabled
    button.current = newButton
  end, {})

  React.useEffect(function()
    if button.current and props.onClick then
      local connection = button.current.Click:Connect(props.onClick)
      return function()
        connection:Disconnect()
      end
    end
  end, { props.onClick })

  React.useEffect(function()
    if button.current then
      button.current:SetActive(active)
    end
  end, { active })

  React.useEffect(function()
    if button.current then
      button.current.Enabled = enabled
    end
  end, { enabled })

  React.useEffect(function()
    if button.current then
      button.current.Icon = icon
    end
  end, { icon })

  return nil
end

return ToolbarButton
