local PLAYER = FindMetaTable("Player")

util.AddNetworkString("SetMoney")
function PLAYER:SetMoney(money)
	self.Money = money
	
	net.Start("SetMoney")
		net.WriteDouble(money)
	net.Send(self)
	
	SqlDB.Query("UPDATE sourcerp_players SET money = '"..money.."' WHERE  steamid = '"..self:SteamID().."'")
end

function PLAYER:AddMoney(money)
	self:SetMoney(self:GetMoney() + money)
end

function PLAYER:RemoveMoney(money)
	self:SetMoney(self:GetMoney() - money)
end

function PLAYER:ResetMoney()
	self:SetMoney(0)
end

function GM:PostPlayerDeath(ply)
	if ply:GetMoney() <= 0 then return end
	local MoneyEntity = ents.Create("money")
	MoneyEntity:SetPos(ply:GetPos())
	MoneyEntity:Spawn()
	MoneyEntity:Activate()

	MoneyEntity:SetNWFloat("Money", ply:GetMoney())
	ply:ResetMoney()
end