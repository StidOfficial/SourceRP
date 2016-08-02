local PLAYER = FindMetaTable("Player")

function PLAYER:SetThirst(thirst)
	return self:SetNWInt("Thirst", thirst)
end

function PLAYER:SetMaxThirst(maxthirst)
	return self:SetNWInt("MaxThirst", maxthirst)
end