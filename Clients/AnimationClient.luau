repeat 
	task.wait() 
until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = players.LocalPlayer

local function_modules = ReplicatedStorage:WaitForChild("FunctionModules")
local animations = require(function_modules:WaitForChild("Animations"))

local player_gui = player.PlayerGui

local frames = {
	--{["Frame"] = example; ["Open"] = example; ["Close"] = example;};
}

UserInputService.InputBegan:Connect(function(input: InputObject, gpe: boolean)
	if gpe then return end

	for _, frame_array in frames do
		if input.KeyCode == frame_array["KeyCode"] then
			animations:OpenFrame(frame_array["Frame"])
		end
	end
end)

for _, frame_array in frames do
	animations:SetUpFrame(frame_array["Frame"])

	if frame_array["Open"] then
		animations:SetUpButton({frame_array["Open"];})

		frame_array["Open"].MouseButton1Click:Connect(function()
			animations:OpenFrame(frame_array["Frame"])
		end)
	end

	if frame_array["Close"] then
		animations:SetUpButton({frame_array["Close"];})

		frame_array["Close"].MouseButton1Click:Connect(function()
			animations:CloseFrame(frame_array["Frame"])
		end)
	end
end

for i, button in player_gui:GetDescendants() do
	if button:IsA("GuiButton") then
		if button:GetAttribute("Animate") then
			animations:SetUpButton({button})
		end
	end
end

player_gui.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("GuiButton") then
		if descendant:GetAttribute("Animate") then
			animations:SetUpButton({descendant})
		end
	end
end)