local Table = script:WaitForChild('LocalizationTable')
local LocaleId = game:GetService('StudioService').StudioLocaleId
local Translator
local FallbackTranslator

Translator = Table:GetTranslator(LocaleId)
if LocaleId ~= 'en-us' then
  FallbackTranslator = Table:GetTranslator('en-us')
end

local function Localization(id, args): string
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
    warn("Couldn't find '"..id.."' key in LocalizationTable.")
    return id
  end

  return returnValue
end

return Localization
