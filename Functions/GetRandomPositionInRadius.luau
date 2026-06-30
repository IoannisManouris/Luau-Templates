local function GetRandomPositionInRadius(center: Vector3, radius: number)
	local rng = Random.new()
	
	local angle = rng:NextNumber(0, math.pi * 2)
	local distance = math.sqrt(rng:NextNumber()) * radius

	local offsetX = math.cos(angle) * distance
	local offsetZ = math.sin(angle) * distance

	return center + Vector3.new(offsetX, 0, offsetZ)
end
