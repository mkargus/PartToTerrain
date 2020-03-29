local Marketplace = game:GetService('MarketplaceService')

local Constants = require(script.Parent.Constants)

local module = {}

local cachedUpdate = nil

function module:IsUpdateAvailable()
  if cachedUpdate == nil then
    -- local id = Constants.IS_DEV_CHANNEL and Constants.DEV_UPDATE_CHECKER_ID or Constants.UPDATE_CHECKER_ID
    local ok = pcall(function()
      -- local productInfo = Marketplace:GetProductInfo(id)
      cachedUpdate = true
    end)

    if not ok then
      cachedUpdate = false
    end

  end

  return cachedUpdate
end

return module
