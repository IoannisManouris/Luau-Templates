local animations = {}

local TweenService = game:GetService("TweenService")

local original_size = {}

local hover_sound = script:WaitForChild("HoverSound")
local click_sound = script:WaitForChild("ClickSound")

local hover_increase = 0.05
local click_increase = 0.15

local button_debounce = {}
local frame_debounce = {}

local frame_to_close = nil
local frame_closing = false

function animations:CloseFrame(frame: Frame)
	frame_closing = true
	local close_tween = TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)})
	close_tween:Play()
	close_tween.Completed:Connect(function()
		frame.Visible = false
		frame_closing = false
		frame_to_close = nil
		task.wait(0.05)
		frame_debounce[frame] = false
	end)
end

function animations:OpenFrame(frame: Frame)
	if frame == nil then return end
	if not frame_debounce[frame] then
		frame_debounce[frame] = true
		if frame_to_close then
			animations:CloseFrame(frame_to_close)
			if frame_to_close == frame then return end
		end
		
		repeat 
            task.wait() 
        until frame_closing == false
		
		frame.Size = UDim2.new(0, 0, 0, 0)
		frame_to_close = frame
				
		local open_tween = TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = original_size[frame]})
		frame.Visible = true
		open_tween:Play()
		open_tween.Completed:Connect(function()
			task.wait(0.05)
			frame_debounce[frame] = false
		end)
	end
end

local function onHover(button: GuiButton)
	if not button.Interactable then return end
	hover_sound:Play()
	TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(original_size[button].X.Scale * (1+hover_increase), 0, original_size[button].Y.Scale * (1+hover_increase), 0)}):Play()
end

local function onLeave(button: GuiButton)
	TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(original_size[button].X.Scale * (1-hover_increase), 0, original_size[button].Y.Scale * (1-hover_increase), 0)}):Play()
end

local function onClick(button: GuiButton)
	click_sound:Play()
	TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, true), {Size = UDim2.new(original_size[button].X.Scale * (1-click_increase), 0, original_size[button].Y.Scale * (1-click_increase), 0)}):Play()
end

function animations:SetUpFrame(frame: Frame)
	original_size[frame] = frame.Size
	--FrameModule.CloseFrame(Frame)
end

function animations:SetUpButton(buttons)
	for i, button in buttons do
		original_size[button] = button.Size
		button.MouseEnter:Connect(function()
			onHover(button)
		end)

		button.MouseLeave:Connect(function()
			onLeave(button)
		end)

		button.MouseButton1Click:Connect(function()
			onClick(button)
		end)
	end
end

return animations