local React = require(script.Parent.Parent.Packages.React)

local function useEventConnection<T...>(event: RBXScriptSignal<T...>, callback: (T...) -> ())
  React.useEffect(function()
    local connection = event:Connect(callback)

    return function()
      connection:Disconnect()
    end
  end, {})
end

return useEventConnection
