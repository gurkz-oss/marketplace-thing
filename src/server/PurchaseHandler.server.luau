local MarketplaceService = game:GetService("MarketplaceService")
local LeaderboardHandler = require(game.ServerStorage:WaitForChild("LeaderboardHandler", 300))

local function onPromptPurchaseFinished(player: Player, assetId: number, isPurchased: boolean)
	if isPurchased then
		print(player.Name, "bought an item with AssetID:", assetId)
		local product = MarketplaceService:GetProductInfo(assetId)
		assert(product, "product doesnt exist")
		local price: number = tonumber(product["PriceInRobux"])
		LeaderboardHandler:UpdateRobuxSpent(player, function(oldValue)
			return oldValue + price
		end)
	else
		print(player.Name, "didn't buy an item with AssetID:", assetId)
	end
end

MarketplaceService.PromptPurchaseFinished:Connect(onPromptPurchaseFinished)
