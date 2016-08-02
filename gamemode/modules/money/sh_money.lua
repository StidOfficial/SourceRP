local PLAYER = FindMetaTable("Player")

PLAYER.Money = nil

function PLAYER:GetMoney()
	return self.Money or 0
end

function PLAYER:GetStringMoney()
	return string.Replace(string.Replace(GAMEMODE.Config.MoneyFormat, "%money", tostring(self:GetMoney())), "%symbol", GAMEMODE.Config.MoneySymbol)
end