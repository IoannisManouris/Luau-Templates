repeat
	task.wait()
until game:IsLoaded()

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local music_folder = SoundService:WaitForChild("Music")

local function_modules = ReplicatedStorage:WaitForChild("FunctionModules")
local signal_service = require(function_modules:WaitForChild("SignalService"))

local function PlaySFX(sfx: Sound)
	task.spawn(function()
		local temp_sfx = sfx:Clone()
		temp_sfx.Parent = sfx.Parent

		temp_sfx:Play()

		repeat
			task.wait()
		until temp_sfx.Playing == false

		temp_sfx:Destroy()
	end)
end

local function PlaySFXEvent(data: any)
	if data["Amount"] == nil then
		data["Amount"] = 1
	end
	
	if type(data["SFX"]) == "string" then
		for i = 1, data["Amount"] do
			PlaySFX(SoundService[data["SFX"]])
		end
	else	
		for i = 1, data["Amount"] do
			PlaySFX(data["SFX"])
		end
	end
end

signal_service:SetRemoteEvent("PlaySFX", PlaySFXEvent)
signal_service:SetBindableEvent("PlaySFX", PlaySFXEvent)

signal_service:SetBindableEvent("UpdateMusic", function()
	for _, music in music_folder:GetChildren() do
		music.Volume = _G.MuteMusic and 0 or 0.5
	end
end)