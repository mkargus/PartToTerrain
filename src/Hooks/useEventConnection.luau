local React = require(script.Parent.Parent.Packages.React)

local function useEventConnection(event: RBXScriptSignal, callback: (...any) -> ())
  React.useEffect(function()
    local connection = event:Connect(callback)

    return function()
      connection:Disconnect()
    end
  end, {})
end

return useEventConnection
