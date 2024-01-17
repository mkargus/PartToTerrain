local useEventConnection = require(script.Parent.useEventConnection)
local Store = require(script.Parent.Parent.Util.Store)

local function useStore(hooks, key: string)
  local value, setValue = hooks.useState(Store:Get(key))

  useEventConnection(hooks, Store:GetChangedSignal(key), function(newValue)
    setValue(newValue)
  end)

  return value
end

return useStore
