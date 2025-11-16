local leaderboards = {}
leaderboards.__index = leaderboards

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local templates = ReplicatedStorage:WaitForChild("Templates")
local leaderboard_template = templates:WaitForChild("LeaderboardTemplate")

local function_module = ReplicatedStorage:WaitForChild("FunctionModules")
local abbreviate = require(function_module:WaitForChild("Abbreviate"))

local rank_colours = {
	[1] = Color3.fromRGB(255, 215, 0);
	[2] = Color3.fromRGB(192, 192, 192);
	[3] = Color3.fromRGB(205, 127, 50);
	[100] = Color3.fromRGB(255, 255, 255)
}

function leaderboards:Create(model: Model, DataBase: DataStore)
	local self = setmetatable({}, leaderboards)
		
	self["DataBase"] = DataBase
	self["PlayerList"] = model:WaitForChild("ListPart"):WaitForChild("ListUI"):WaitForChild("PlayerList")
		
	return self
end

function leaderboards:Clear()
	for _, player_frame in self["PlayerList"]:GetChildren() do
		if player_frame:GetAttribute("PlayerFrame") == true then
			player_frame:Destroy()
		end
	end
end

function leaderboards:Update()
	self:Clear()
	
	local top_100 = self["DataBase"]:GetSortedAsync(false, 100):GetCurrentPage()
	
	for rank, data in ipairs(top_100) do
		local user_id = tonumber(data["key"])
		local username = "Loading..."
		if user_id >= 0 then 
			local success, err = pcall(function()
				username = Players:GetNameFromUserIdAsync(user_id)
			end)
			while not success do
				task.wait(2.5)
				success, err = pcall(function()
					username = Players:GetNameFromUserIdAsync(user_id)
				end)
			end
		else
			username = "Player"..tostring(math.abs(user_id))
		end
		local player_frame = leaderboard_template:Clone()
		local rank_label = player_frame:WaitForChild("RankLabel")
		rank_label.TextColor3 = (rank_colours[rank] or rank_colours[100])
		rank_label.Text = "#"..tostring(rank)
		player_frame:WaitForChild("NameLabel").Text = username
		player_frame:WaitForChild("ValueLabel").Text = abbreviate:AbreviateNumber(data["value"])
		player_frame.Parent = self["PlayerList"]
		if rank <= 50 then
			task.wait(0.1)
		else
			task.wait(1)
		end
	end
end

return leaderboards