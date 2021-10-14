-- Modified code from Rojo's plugin.
local Plugin = script.Parent.Parent

local Roact = require(Plugin.Packages.Roact)

local Constants = require(Plugin.Util.Constants)

--------------------------------------------
-- APIs
--------------------------------------------
local Settings = {}
Settings.__index = Settings

function Settings.fromPlugin(plugin)
  local values = {}

  for name, test in pairs(Constants.SETTINGS_TABLE) do
    local savedValue = plugin:GetSetting(name)

    if savedValue == nil then
      values[name] = test.defaultValue
      plugin:SetSetting(name, test.defaultValue)
    else
      values[name] = savedValue
    end
  end

  return setmetatable({
    __values = values,
    __plugin = plugin,
    __updateListeners = {}
  }, Settings)
end

function Settings:Get(name)
  if Constants.SETTINGS_TABLE[name] == nil then
    error('Invaild setting name.')
  end

  return self.__values[name]
end

function Settings:Set(name, value)
  self.__plugin:SetSetting(name, value)
  self.__values[name] = value

  for callback in pairs(self.__updateListeners) do
    callback(name, value)
  end
end

function Settings:onUpdate(newCallback)
  local newListeners = {}
  for callback in pairs(self.__updateListeners) do
    newListeners[callback] = true
  end

  newListeners[newCallback] = true
  self.__updateListeners = newListeners

  return function()
    newListeners = {}
    for callback in pairs(self.__updateListeners) do
      if callback ~= newCallback then
        newListeners[callback] = true
      end
    end

    self.__updateListeners = newListeners
  end
end

--------------------------------------------
-- Studio Provider
--------------------------------------------
local Context = Roact.createContext(nil)

local StudioProvider = Roact.Component:extend('StudioProvider')

function StudioProvider:init()
  self.settings = Settings.fromPlugin(self.props.plugin)
end

function StudioProvider:render()
  return Roact.createElement(Context.Provider, {
    value = self.settings
  }, self.props[Roact.Children])
end

--------------------------------------------
-- Internal Consumer
--------------------------------------------
local InternalConsumer = Roact.Component:extend('InternalConsumer')

function InternalConsumer:render()
  return self.props.render(self.props.settings)
end

function InternalConsumer:didMount()
  self.disconnect = self.props.settings:onUpdate(function()
    self:setState({})
  end)
end

function InternalConsumer:willUnmount()
  self.disconnect()
end

local function with(callback)
  return Roact.createElement(Context.Consumer, {
    render = function(settings)
      return Roact.createElement(InternalConsumer, {
        settings = settings,
        render = callback
      })
    end
  })
end

--------------------------------------------
-- Public functions
--------------------------------------------
return {
  StudioProvider = StudioProvider,
  with = with
}
