local VFX = {}

function VFX:Emit(attachment: Attachment, speed: number)
	if speed == nil then speed = 1 end
	
	for _, effect in attachment:GetChildren() do
		if effect:IsA("ParticleEmitter") then
			local emit_delay = (effect:GetAttribute("EmitDelay") or 0)/speed
			local emit_count = (effect:GetAttribute("EmitCount") or 1)*speed
			local emit_duration = (effect:GetAttribute("EmitDuration") or 0)/speed

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

return VFX
