local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local drachma_database = DataStoreService:GetOrderedDataStore("Drachma_Database_1")
local kills_database = DataStoreService:GetOrderedDataStore("Kills_Database_1")

local function PlayerAdded(player: Player)
	local leaderstats = Instance.new("Folder", player) do
		leaderstats.Name = "leaderstats"
		
		local drachma = Instance.new("NumberValue", player) do
			drachma.Name = "Drachma"
			
			local drachma_data = nil
			pcall(function()
				drachma_data = drachma_database:GetAsync(player.UserId)
			end)
			
			drachma.Value = drachma_data or 0
		end
		
		local kills = Instance.new("IntValue", player) do
			kills.Name = "Kills"

			local kill_data = nil
			pcall(function()
				kill_data = kills_database:GetAsync(player.UserId)
			end)

			kills.Value = kill_data or 0
		end
	end
end

local function PlayerRemoving(player: Player)
	local user_id = player.UserId
	
	local leaderstats = nil
	
	pcall(function()
		leaderstats = player.leaderstats
	end)
	
	local drachma_data = nil
	
	pcall(function()
		drachma_data = leaderstats.Drachma.Value
	end)
	
	local kills_data = nil
	
	pcall(function()
		kills_data = leaderstats.Kills.Value
	end)
	
	drachma_database:UpdateAsync(user_id, function()
		return drachma_data
	end)
	
	drachma_database:UpdateAsync(user_id, function()
		return kills_data
	end)
end

for _, player in Players:GetPlayers() do
	PlayerAdded(player)
end
Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoving)
game:BindToClose(function()
	for _, player in Players:GetPlayers() do
		PlayerRemoving(player)
	end
end)