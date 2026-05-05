local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function_modules = ReplicatedStorage:WaitForChild("FunctionModules")
local marketplace = require(function_modules:WaitForChild("Marketplace"))
local signal_service = require(function_modules:WaitForChild("SignalService"))

local channel = TextChatService:WaitForChild("TextChannels"):WaitForChild("RBXSystem")

local function AddPrefix(text: string, message: string, colour: Color3)
	local r = math.floor(colour.R * 255)
	local g = math.floor(colour.G * 255)
	local b = math.floor(colour.B * 255)
	local prefixed_message = string.format('<font color="rgb(%d,%d,%d)">[%s]</font>%s', r, g, b, text, message)
	return prefixed_message
end

local function FormMessage(data)
	return '<font color="#'..data["Colour"]..'"><font size="'..data["Size"]..'"><font face="'..data["Font"]..'">'..data["Text"]..'</font></font></font>'
end

TextChatService.OnIncomingMessage = function(message)
	local TextSource = message.TextSource
	local properties = Instance.new("TextChatMessageProperties")
	properties.Text = message.Text
	if not TextSource then return properties end
	local player = Players:GetPlayerByUserId(TextSource.UserId)
	local prefix_message = ""
	if marketplace:UserOwnsGamepass(player, "VIP") then
		prefix_message = AddPrefix("⭐", prefix_message, Color3.fromRGB(255, 255, 0))
	end
	properties.PrefixText = prefix_message..player.DisplayName..":"
	return properties
end

signal_service:SetRemoteEvent("SystemMessage", function(data: any)
	if data["Custom"] then
		channel:DisplaySystemMessage(data["Message"])
	else
		if data["Colour"] == nil then
			data["Colour"] = Color3.fromRGB(255, 255, 255)
		end
		if data["Font"] == nil then
			data["Font"] = "Montserrat"
		end
		if data["Size"] == nil then
			data["Size"] = "17"
		else
			data["Size"] = tostring(data["Size"])
		end
		channel:DisplaySystemMessage(FormMessage({
			["Text"] = string.format("<b>%s</b>", data["Message"]);
			["Colour"] = data["Colour"]:ToHex();
			["Font"] = data["Font"];
			["Size"] = data["Size"];
		}))
	end
end)