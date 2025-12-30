local StudioService = game:GetService('StudioService')

local Table = script.LocalizationTable
local LocaleId = StudioService.StudioLocaleId
local Translator
local FallbackTranslator

Translator = Table:GetTranslator(LocaleId)
if LocaleId ~= 'en_US' then
  FallbackTranslator = Table:GetTranslator('en_US')
end

local function Localization(id: string, args: { any }?): string
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
