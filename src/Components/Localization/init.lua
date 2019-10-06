local Table = script:WaitForChild('LocalizationTable')
local LocaleId = game:GetService("StudioService").StudioLocaleId
local Translator
local FallbackTranslator

Translator = Table:GetTranslator(LocaleId)
if LocaleId ~= 'en-us' then
  FallbackTranslator = Table:GetTranslator('en-us')
end

return function(id, arg)
  local returnValue
  local success = pcall(function()
    returnValue = Translator:FormatByKey(id, arg)
  end)
  if not success and FallbackTranslator or returnValue == '' then
    pcall(function()
      returnValue = FallbackTranslator:FormatByKey(id, arg)
    end)
  end

  if not returnValue then
    warn("Couldn't find '"..id.."' key in LocalizationTable.")
    return id
  end

  return returnValue
end
