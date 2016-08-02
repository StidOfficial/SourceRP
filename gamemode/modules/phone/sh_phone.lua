local PLAYER = FindMetaTable("Player")

PLAYER.PhoneNumber = nil

function PLAYER:GetPhoneNumber()
	return self.PhoneNumber or "11"..self:UserID()
end