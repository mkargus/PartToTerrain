--!strict
local Table = script:WaitForChild('LocalizationTable')
local LocaleId = game:GetService('StudioService').StudioLocaleId
local Translator
local FallbackTranslator

Translator = Table:GetTranslator(LocaleId)
if LocaleId ~= 'en_US' then
  FallbackTranslator = Table:GetTranslator('en_US')
end

local function Localization(id: string, args: {any}?): string
  assert(typeof(id) == 'string', 'id must be a string')
  assert(typeof(args) == 'nil' or typeof(args) == 'table', 'args must be a table or nil')

  local returnValue
  local success = pcall(function()
    returnValue = Translator:FormatByKey(id, args)
  end)
  if not success and FallbackTranslator or returnValue == '' then
    pcall(function()
      returnValue = FallbackTranslator:FormatByKey(id, args)
    end)
  end

  if not returnValue then
    return id
  end

  return returnValue
end

return Localization
