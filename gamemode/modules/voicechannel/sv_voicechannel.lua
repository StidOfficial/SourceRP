function GM:PlayerCanHearPlayersVoice(listener, talker)
	return (listener:GetPos():Distance(talker:GetPos()) <= 500)
end