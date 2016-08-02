speed = {}

function speed.VelocityToKPH(velocity)
	return math.Round(velocity * 3600 * 0.0000254 * 0.75)
end

function speed.VelocityToMPH(velocity)
	return math.Round(velocity * 3600 / 63360 * 0.75)
end