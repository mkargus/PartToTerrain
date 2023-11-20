local function useEventConnection(hooks, event: RBXScriptSignal, callback: (...any) -> ())
  hooks.useEffect(function()
    local connection = event:Connect(callback)

    return function()
      connection:Disconnect()
    end
  end, {})
end

return useEventConnection
