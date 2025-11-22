local vfx = {}

function vfx:Emit(attachment: Attachment, speed: number)
	if speed == nil then speed = 1 end

	for _, effect in attachment:GetChildren() do
		if effect:IsA("ParticleEmitter") then
			local emit_delay = effect:GetAttribute("EmitDelay") or 0
			local emit_count = effect:GetAttribute("EmitCount")  or 1
			local emit_duration = effect:GetAttribute("EmitDuration") or 0

			task.delay(emit_delay, function()
				if emit_duration > 0 then
					effect.Enabled = true
					task.delay(emit_duration, function()
						effect.Enabled = false
					end)
				else
					effect:Emit(emit_count)
				end
			end)
		end
	end
end

function vfx:SetColour(attachment: Attachment, colour_sequence: ColorSequence)
	for _, effect in attachment:GetChildren() do
		if effect:IsA("ParticleEmitter") then
			effect.Color = colour_sequence
		end
	end
end

function vfx:Enable(attachment: Attachment, enabled: boolean)
	for _, effect in attachment:GetChildren() do
		if effect:IsA("ParticleEmitter") then
			effect.Enabled = enabled
		end
	end
end

return vfx
