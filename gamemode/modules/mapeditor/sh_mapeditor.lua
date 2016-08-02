local PLAYER = FindMetaTable("Player")

function PLAYER:InMapEditor()
	return self:GetNWBool("InMapEditor")
end