local PLAYER = FindMetaTable("Player")

function PLAYER:Thirst()
	return self:GetNWInt("Thirst")
end

function PLAYER:GetMaxThirst()
	return self:GetNWInt("MaxThirst")
end