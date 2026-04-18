local stage_service = {}

local stages_array = {
	["Skip Level"] = {
		[4275000] = 1; -- End of Stage 1 (Title 7: Rising)
		[52e11] = 2;   -- End of Stage 2 (Title 14: Focused)
		[32e18] = 3;   -- End of Stage 3 (Title 21: Apex)
		[850e24] = 4;  -- End of Stage 4 (Title 28: Mythic)
		[1e33] = 5;    -- End of Stage 5 (Title 34: Ethereal)
	};

}

stage_service["Stages"] = stages_array

function stage_service:GetStage(list: string, value: number)
	local min = math.huge

	for threshold, _ in stages_array[list] do
		if value < threshold and threshold < min then
			min = threshold
		end
	end

	return stages_array[list][min]
end

return stage_service