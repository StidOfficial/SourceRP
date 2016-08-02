function GM:PlayerSay(ply, text, public)
	prefix = string.sub(text, 0, 1)
	if (prefix == "/") then
		return "eee"
	elseif (prefix == "!")  then
		return text
	else
		return text
	end
end

function GM:PlayerCanSeePlayersChat(text, teamOnly, listener, speaker)
	return speaker:GetPos():Distance(listener:GetPos()) <= 250
end