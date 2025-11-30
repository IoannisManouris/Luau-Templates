local SignalService = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote_event = ReplicatedStorage:WaitForChild("RemoteEvent")
local bindable_event = ReplicatedStorage:WaitForChild("BindableEvent")

local remote_function = ReplicatedStorage:WaitForChild("RemoteFunction")

local remote_callbacks = {}
local bindable_callbacks = {}

local is_server = RunService:IsServer()

function SignalService:SetRemoteEvent(event_name: string, callback: Function)
	if remote_callbacks[event_name] ~= nil then
		warn(event_name.." is already a registered remote event!")
		return
	end
	remote_callbacks[event_name] = callback
end

function SignalService:SetBindableEvent(event_name: string, callback: Function)
	if bindable_callbacks[event_name] ~= nil then
		warn(event_name.." is already a registered bindable event!")
		return
	end
	bindable_callbacks[event_name] = callback
end

function SignalService:SetRemoteFunction(function_name: string, callback: Function)
	if remote_callbacks[function_name] ~= nil then
		warn(function_name.." is already a registered remote function!")
		return
	end
	remote_callbacks[function_name] = callback
end

function SignalService:FireServer(event_name: string, data: any)
	if is_server == true then return end
	
	remote_event:FireServer(event_name, data)
end

function SignalService:FireClient(player: Player, event_name: string, data: any)
	if is_server == false then return end

	remote_event:FireClient(player, event_name, data)
end

function SignalService:FireAllClients(event_name: string, data: any)
	if is_server == false then return end

	remote_event:FireAllClients(event_name, data)
end

function SignalService:Fire(event_name: string, data: any)
	bindable_event:Fire(event_name, data)
end

function SignalService:InvokeServer(function_name: string, data: any)
	local response = remote_function:InvokeServer(function_name, data)
	return response
end

function SignalService:InvokeClient(player: Player, function_name: string, data: any)
	local response = remote_function:InvokeClient(player, function_name, data)
	return response
end

if is_server == true then
	remote_event.OnServerEvent:Connect(function(player: Player, event_name: string, data: any)
		local callback = remote_callbacks[event_name]
		if callback == nil then return end
		callback(player, data)
	end)
	
	remote_function.OnServerInvoke = function(player: Player, function_name: string, data: any)
		local callback = remote_callbacks[function_name]
		if callback == nil then return end
		return callback(player, data)
	end
else
	remote_event.OnClientEvent:Connect(function(event_name: string, data: any)
		local callback = remote_callbacks[event_name]
		if callback == nil then return end
		callback(data)
	end)
	
	remote_function.OnClientInvoke = function(function_name: string, data: any)
		local callback = remote_callbacks[function_name]
		if callback == nil then return end
		return callback(data)
	end
end

bindable_event.Event:Connect(function(event_name: string, data: any)
	local callback = bindable_callbacks[event_name]
	if callback == nil then return end
	callback(data)
end)

return SignalService