local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

Players.PlayerAdded:Connect(function(player: Player)
	local friends = Instance.new("NumberValue", player)
	friends.Name = "Friends"

	local friend_count = 0
	for _, plr in Players:GetPlayers() do
		if plr.UserId == player.UserId then continue end
		if player:IsFriendsWith(plr.UserId) then
			friend_count += 1
			plr:WaitForChild("Friends").Value += 1
		end
	end

	friends.Value = friend_count
end)

Players.PlayerRemoving:Connect(function()
	for _, player in Players:GetPlayers() do
		local friend_count = 0

		for _, plr in Players:GetPlayers() do
			if plr.UserId == player.UserId then continue end
			if player:IsFriendsWith(plr.UserId) then
				friend_count += 1
			end
		end

		player:WaitForChild("Friends").Value = friend_count
	end
end)