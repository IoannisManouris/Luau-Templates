local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function_modules = ReplicatedStorage:WaitForChild("FunctionModules")
local marketplace = require(function_modules:WaitForChild("Marketplace"))

task.wait(2.5)

local function PlayerAdded(player: Player)	
	local gamepasses = Instance.new("Folder", player)
	gamepasses.Name = "Gamepasses"

	for gamepass_name, gamepass_info in marketplace:GetCategory("Gamepasses") do
		local gamepass = Instance.new("BoolValue", gamepasses)	
		gamepass.Name = gamepass_name
		task.delay(2.5, function()
			if MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamepass_info["Id"]) then
				gamepass.Value = true
				marketplace:PurchaseGamepass(player, gamepass_name)
			end
		end)
	end
end

local function PurchaseProduct(player: Player, product_id: number)
	local product_name = marketplace:GetProductNameFromId(product_id)
	if player == nil or product_name == nil then return end

	marketplace:PurchaseProduct(player, product_name)
end

local function ProcessReceipt(receipt_info)
	local player = Players:GetPlayerByUserId(receipt_info.PlayerId)
	if player == nil then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	PurchaseProduct(player, receipt_info.ProductId)

	return Enum.ProductPurchaseDecision.PurchaseGranted
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamepassId, bought)
	if not bought then return end

	local gamepass_name = marketplace:GetGamepassNameFromId(gamepassId)
	if gamepass_name == nil then return end

	marketplace:PurchaseGamepass(player, gamepass_name)
end)

for _, player in Players:GetPlayers() do
	PlayerAdded(player)
end
Players.PlayerAdded:Connect(PlayerAdded)

MarketplaceService.ProcessReceipt = ProcessReceipt
local success, result = pcall(function()
	MarketplaceService.ProcessReceipt = ProcessReceipt
end)

if not success then
	warn("Process Receipt Error: ", result)
end