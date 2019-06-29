local Table = script.Parent:WaitForChild('localizationTable')
local LocaleId = game:GetService("StudioService").StudioLocaleId
local Translator
local FallbackTranslator

Translator = Table:GetTranslator(LocaleId)
if LocaleId ~= 'en-us' then
  FallbackTranslator = Table:GetTranslator('en-us')
end

local module = {}

function module:TranslateId(id, arg)
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
    error("Couldn't find '"..id.."' key in localizationTable.")
  end

  return returnValue
end

return module
