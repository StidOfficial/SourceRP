local PLAYER = FindMetaTable("Player")

function PLAYER:Hunger()
	return self:GetNWInt("Hunger")
end

function PLAYER:GetMaxHunger()
	return self:GetNWInt("MaxHunger")
end