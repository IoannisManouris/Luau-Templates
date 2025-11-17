local SoundService = game:GetService("SoundService")

local music_folder = SoundService:WaitForChild("Music")

repeat
	local music_options = music_folder:GetChildren()
	local random_music = music_options[math.random(1, #music_options)]
	random_music:Play()
	task.wait(random_music.TimeLength)
	random_music:Stop()
until not task.wait(2.5)