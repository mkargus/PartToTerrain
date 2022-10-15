local plugin = plugin or script:FindFirstAncestorWhichIsA('Plugin')

local DEFAULT_SETTINGS = {
  CheckUpdates = true,
  DeletePart = true,
  EnabledSelectionBox = true,
  IgnoreLockedParts = false,
  PreserveTerrain = true,
  IgnoreInvisibleParts = true
}

local Settings = {}
Settings._values = DEFAULT_SETTINGS
Settings._updateListeners = {}

for key, defaultValue in pairs(Settings._values) do
  local savedValue = plugin:GetSetting(key)

  if savedValue == nil then
    Settings._values[key] = defaultValue
    plugin:SetSetting(key, defaultValue)
  else
    Settings._values[key] = savedValue
  end
end

function Settings:Get(key: string)
  if self._values[key] == nil then
    error('Invaild setting name: ' ..tostring(key), 2)
  end

  return self._values[key]
end

function Settings:Set(key: string, value: any)
  self._values[key] = value
  plugin:SetSetting(key, value)

  if self._updateListeners[key] then
    for callback in pairs(self._updateListeners[key]) do
      task.spawn(callback, value)
    end
  end
end

function Settings:onUpdate(key: string, callback)
  local listeners = self._updateListeners[key]
  if listeners == nil then
    listeners = {}
    self._updateListeners[key] = listeners
  end
  listeners[callback] = true

  return function()
    listeners[callback] = nil
  end
end

return Settings
