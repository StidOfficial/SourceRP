ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Money"
ENT.Author = "StidOfficial"
ENT.Contact = "N/A"
ENT.Purpose = "Money"
ENT.Instructions = "Use to pick up"
ENT.Category = "Money"

ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:GetStringMoney()
	return string.Replace(string.Replace(GAMEMODE.Config.MoneyFormat, "%money", tostring(self:GetNWFloat("Money"))), "%symbol", GAMEMODE.Config.MoneySymbol)
end