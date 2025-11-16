local Marketplace = {}

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local local_player = Players.LocalPlayer

local remote_events = ReplicatedStorage:WaitForChild("RemoteEvents")

local marketplace_information = {
	["Gamepasses"] = {
		["Example"] = {
			["Id"] = 000000000;
			["Function"] = function(player: Player)
				
			end;
		};
	};
	["Developer Products"] = {
		["Example"] = {
			["Id"] = 000000000;
			["Function"] = function(player: Player)
				
			end;
		};
	};
}

for product_name, product_info in marketplace_information["Developer Products"] do
	task.spawn(function()
		local success, _ = nil, nil

		repeat
			success, _ = pcall(function()
				marketplace_information["Developer Products"][product_name]["Price"] = MarketplaceService:GetProductInfo(product_info["Id"], Enum.InfoType.Product).PriceInRobux
			end)
			task.wait(1)
		until success
	end)
end

for gamepass_name, gamepass_info in marketplace_information["Gamepasses"] do
	task.spawn(function()
		local success, _ = nil, nil

		repeat
			success, _ = pcall(function()
				marketplace_information["Gamepasses"][gamepass_name]["Price"] = MarketplaceService:GetProductInfo(gamepass_info["Id"], Enum.InfoType.GamePass).PriceInRobux
			end)
			task.wait(1)
		until success
	end)
end

function Marketplace:GetCategory(category: string)
	return marketplace_information[category]
end

function Marketplace:UserOwnsGamepass(player: Player, gamepass_name: string)
	local gamepass = marketplace_information["Gamepasses"][gamepass_name]
	if gamepass == nil then return end
	return player:WaitForChild("Gamepasses"):WaitForChild(gamepass_name).Value
end

function Marketplace:GetGamepassNameFromId(id: number)
	local gamepasses = marketplace_information["Gamepasses"]
	for name, info in gamepasses do
		if info["Id"] == id then
			return name
		end
	end
end

function Marketplace:GetProductNameFromId(id: number)
	local products = marketplace_information["Developer Products"]
	for name, info in products do
		if info["Id"] == id then
			return name
		end
	end
end

function Marketplace:GetGamepassId(name: string)
	local item = marketplace_information["Gamepasses"][name]
	if item == nil then return end
	return item["Id"]
end

function Marketplace:GetProductId(name: string)
	local item = marketplace_information["Developer Products"][name]
	if item == nil then return end
	return item["Id"]
end

function Marketplace:GetGamepassPrice(name: string)
	local item = marketplace_information["Gamepasses"][name]
	if item == nil then return end
	return item["Price"]
end

function Marketplace:GetProductPrice(name: string)
	local item = marketplace_information["Developer Products"][name]
	if item == nil then return end
	return item["Price"]
end

function Marketplace:PurchaseGamepass(player: Player, name: string)
	if player == nil then return end
	local item = marketplace_information["Gamepasses"][name]
	if item == nil or not MarketplaceService:UserOwnsGamePassAsync(player.UserId, item["Id"]) then return end
	item["Function"](player)
	player:WaitForChild("Gamepasses"):WaitForChild(name).Value = true
end

function Marketplace:PurchaseProduct(player: Player, name: string)
	if player == nil then return end
	local item = marketplace_information["Developer Products"][name]
	if item == nil then return end
	item["Function"](player)
end

function Marketplace:PromptGamepass(name: string, player: Player)
	if player == nil and local_player ~= nil then
		player = local_player
	end
	local item = marketplace_information["Gamepasses"][name]
	if item == nil then return end
	MarketplaceService:PromptGamePassPurchase(player, item["Id"])
end

function Marketplace:PromptProduct(name: string, player: Player)
	if player == nil and local_player ~= nil then
		player = local_player
	end
	local item = marketplace_information["Developer Products"][name]
	if item == nil then return end
	MarketplaceService:PromptProductPurchase(player, item["Id"])
end

return Marketplace