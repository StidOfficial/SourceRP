local PLAYER = FindMetaTable("Player")

function PLAYER:GetCountry()
	return self.CountryName
end

function PLAYER:GetCountryCode()
	return self.CountryCode
end

function GM:PlayerConnect(name, ip)
	PrintMessage(HUD_PRINTTALK, name.." has joined the game.")
end

function GM:PlayerAuthed(ply, steamid, uniqueid)
	http.Fetch(ply:IPAddress() != "loopback" and "http://ip-api.com/json/"..string.Split(ply:IPAddress(), ":")[1] or "http://ip-api.com/json/", function(body, len, headers, code)
		local JSONTable = util.JSONToTable(body)
		if JSONTable.status == "fail" then return end
		ply.CountryName = JSONTable.country
		ply.CountryCode = JSONTable.countryCode

		local SQLPlayer = SqlDB.Query("SELECT * FROM 'sourcerp_players' WHERE steamid = '"..ply:SteamID().."'")
		if SQLPlayer then
			local PlayerData = SQLPlayer[1]
			ply:SetMoney(tonumber(PlayerData.money))
		else
			SqlDB.Query("INSERT INTO 'sourcerp_players' ('money','steamid') VALUES (0, '"..ply:SteamID().."')")
		end

		PrintMessage(HUD_PRINTTALK, ply:Name().." has been authenticated as "..steamid.." from "..ply:GetCountry().."/"..ply:GetCountryCode()..".")
		
		if !table.KeyFromValue(GAMEMODE.Config.CountryAllowed, ply:GetCountryCode()) then
			ply:Kick("Your country is not allowed !")
		end
	end)
end

util.AddNetworkString("PlayerInitialSpawn")
hook.Add("PlayerInitialSpawn", "PlayerClientInitialSpawn", function(ply)
	ply:SetJob(JOB_DEFAULT)
	--ply:AddMoney(100)
	ply:SetMaxThirst(500)
	ply:SetThirst(500)
	ply:SetMaxHunger(500)
	ply:SetHunger(500)
	ply:SetPlayerColor(Vector(1, 0, 0))
	ply:SetModel("models/Humans/Group01/Male_04.mdl")
	net.Start("PlayerInitialSpawn")
	net.Send(ply)
end)

util.AddNetworkString("PlayerSpawn")
hook.Add("PlayerSpawn", "PlayerClientSpawn", function(ply)
	net.Start("PlayerSpawn")
	net.Send(ply)
end)

hook.Add("PlayerPostThink", "PlayerWater", function(ply)
	if ply.LastWaterLevel then
		if ply.LastWaterLevel != ply:WaterLevel() then
			ply.LastWaterLevel = ply:WaterLevel()
			if ply:WaterLevel() == 3 then
				ply.DrowningTime = CurTime() + 10
			else
				ply.DrowningTime = nil
			end
		end
	else
		ply.LastWaterLevel = ply:WaterLevel()
	end

	if ply.DrowningTime && ply.DrowningTime < CurTime() then
		ply.DrowningTime = CurTime() + 2
		ply:TakeDamage(10, ply, ply)
	end
end)

function GM:Move(ply, mv)
	--print(mv:GetForwardSpeed())
	return false
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	ply:CreateRagdoll()
	ply:CreateRagdoll()
	ply:AddDeaths(1)

	if (attacker:IsValid() && attacker:IsPlayer()) then
		if (attacker == ply) then
			attacker:AddFrags(-1)
		else
			attacker:AddFrags(1)
		end
	end
end

function GM:PlayerSwitchFlashlight(ply, enabled)
	return false
end

function GM:PlayerDisconnected(ply)
	PrintMessage(HUD_PRINTTALK, ply:Name().." has left the server.")
end