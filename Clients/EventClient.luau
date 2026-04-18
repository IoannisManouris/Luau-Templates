repeat
	task.wait()
until game:IsLoaded()

local SocialService = game:GetService("SocialService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local event_id = workspace:WaitForChild("EventId") -- string value in workspace
local prompt = workspace:WaitForChild("EventBoard"):WaitForChild("BoardPart"):WaitForChild("EventPrompt") -- prompt for event

local status = nil

task.wait(5)

pcall(function()
	status = SocialService:GetEventRsvpStatusAsync(event_id.Value)
end)

if status ~= Enum.RsvpStatus.Going then
	prompt.Triggered:Connect(function(plr: Player)
		if plr.UserId ~= player.UserId then return end

		pcall(function()
			status = SocialService:PromptRsvpToEventAsync(event_id.Value)

			if status == Enum.RsvpStatus.Going then
				prompt.Enabled = false
			end
		end)	
	end)
else
	prompt.Enabled = false
end