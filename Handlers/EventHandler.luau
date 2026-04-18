local ConfigService = game:GetService("ConfigService")

local event_thumbnail_label = workspace:WaitForChild("EventBoard"):WaitForChild("BoardPart"):WaitForChild("UI"):WaitForChild("EventThumbnail") -- image of even'ts thumbnail
local event_id = workspace:WaitForChild("EventId") -- string value in workspace

local config = ConfigService:GetConfigAsync()

local function UpdateConfigs()
	config:Refresh()

	event_id.Value = config:GetValue("EventId") or ""

	local event_image = config:GetValue("EventImage")
	event_thumbnail_label.Visible = (event_image ~= nil and event_image ~= "NONE")
	event_thumbnail_label.Image = event_image or ""
end

repeat
	pcall(UpdateConfigs)
until not task.wait(900)