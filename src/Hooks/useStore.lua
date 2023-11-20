local Store = require(script.Parent.Parent.Util.Store)

local function useStore(hooks, key: string)
  local value, setValue = hooks.useState(Store:Get(key))

  hooks.useEffect(function()
    local connection = Store:GetChangedSignal(key):Connect(function(newValue)
      setValue(newValue)
    end)

    return function()
      connection:Disconnect()
    end
  end, {})

  return value
end

return useStore
