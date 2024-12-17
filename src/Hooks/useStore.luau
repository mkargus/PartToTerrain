local React = require(script.Parent.Parent.Packages.React)
local useEventConnection = require(script.Parent.useEventConnection)
local Store = require(script.Parent.Parent.Util.Store)

local function useStore(key: string)
  local value, setValue = React.useState(Store:Get(key))

  useEventConnection(Store:GetChangedSignal(key), function(newValue)
    setValue(newValue)
  end)

  return value
end

return useStore
