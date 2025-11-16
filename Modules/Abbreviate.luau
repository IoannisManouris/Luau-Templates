local abbreviate = {}

local abbreviations = {"", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc", "Ud", "Dd", "Td", "Qad", "Qid", "Sxd", "Spd", "Ocd", "Nod", "Vg", "Uvg", "Dvg", "Tvg", "Qavg", "Qivg", "Sxvg", "Spvg", "Ocvg", "Nov", "Tt", "Unt", "Dtt", "Ttt", "Qut", "Qat", "Sst", "Spt", "Oct", "Nvt", "Qdt", "Qqt", "Sxt", "Sgt", "Oi", "Noi", "C"}

function abbreviate:AbreviateNumber(number: number, style: string)
	if number then
		if style == nil then
			if number >= 1000 then
				for i = 1, #abbreviations do
					if number < 10^((i) * 3) or i == #abbreviations then
						local new_number = number / 10^((i-1) * 3)
						local formatted = string.format("%.2f", new_number)
						formatted = formatted:gsub("%.?0+$", "")
						return formatted..abbreviations[i]
					end
				end
			else
				return string.format("%.2f", number):gsub("%.?0+$", "")
			end
		elseif style == "Comma" then
			return string.format("%0.0f", number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
		end
	end
	return "0"
end

function abbreviate:AbreviateSeconds(seconds)
	local days = math.floor(seconds / 86400)
	local hours = math.floor(seconds % 86400 / 3600)
	local minutes = math.floor(seconds % 3600 / 60)
	seconds = math.floor(seconds % 60)

	if days > 0 then
		return string.format("%i:%02i:%02i:%02i", days, hours, minutes, seconds)
	elseif hours > 0 then
		return string.format("%02i:%02i:%02i", hours, minutes, seconds)
	else
		return string.format("%02i:%02i", minutes, seconds)
	end
end

return abbreviate