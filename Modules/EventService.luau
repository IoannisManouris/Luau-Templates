local remote = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote_event = ReplicatedStorage:WaitForChild("RemoteEvent")
local bindable_event = ReplicatedStorage:WaitForChild("BindableEvent")

local remote_callbacks = {}
local bindable_callbacks = {}

local is_server = RunService:IsServer()

function remote:SetRemoteEvent(event_name: string, callback: Function)
	if remote_callbacks[event_name] ~= nil then
		warn(event_name.." is already a registered remote event!")
		return
	end
	remote_callbacks[event_name] = callback
end

function remote:SetBindableEvent(event_name: string, callback: Function)
	if bindable_callbacks[event_name] ~= nil then
		warn(event_name.." is already a registered bindable event!")
		return
	end
	bindable_callbacks[event_name] = callback
end

function remote:FireServer(event_name: string, data: any)
	if is_server == true then return end
	
	remote_event:FireServer(event_name, data)
end

function remote:FireClient(player: Player, event_name: string, data: any)
	if is_server == false then return end

	remote_event:FireClient(player, event_name, data)
end

function remote:FireAllClients(event_name: string, data: any)
	if is_server == false then return end

	remote_event:FireAllClients(event_name, data)
end

function remote:Fire(event_name: string, data: any)
	bindable_event:Fire(event_name, data)
end

if is_server == true then
	remote_event.OnServerEvent:Connect(function(player: Player, event_name: string, data: any)
		local callback = remote_callbacks[event_name]
		if callback == nil then return end
		callback(player, data)
	end)
else
	remote_event.OnClientEvent:Connect(function(event_name: string, data: any)
		local callback = remote_callbacks[event_name]
		if callback == nil then return end
		callback(data)
	end)
end

bindable_event.Event:Connect(function(event_name: string, data: any)
	local callback = bindable_callbacks[event_name]
	if callback == nil then return end
	callback(data)
end)

return remote