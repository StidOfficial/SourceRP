local PLAYER = FindMetaTable("Player")

function PLAYER:SetHunger(hunger)
	return self:SetNWInt("Hunger", hunger)
end

function PLAYER:SetMaxHunger(maxhunger)
	return self:SetNWInt("MaxHunger", maxhunger)
end