AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("utils/console.lua")
AddCSLuaFile("utils/hook.lua")
AddCSLuaFile("utils/http.lua")
AddCSLuaFile("utils/draw.lua")
AddCSLuaFile("utils/httpmaterial.lua")
AddCSLuaFile("utils/speed.lua")

AddCSLuaFile("config/config.lua")

AddCSLuaFile("modules/customkey/cl_customkey.lua")
AddCSLuaFile("modules/money/sh_money.lua")
AddCSLuaFile("modules/money/cl_money.lua")
AddCSLuaFile("modules/job/sh_job.lua")
AddCSLuaFile("modules/job/cl_job.lua")
AddCSLuaFile("modules/hud/cl_hud.lua")
AddCSLuaFile("modules/hud/cl_hudvehicle.lua")
AddCSLuaFile("modules/inventory/cl_inventory.lua")
AddCSLuaFile("modules/inventory/cl_weaponselection.lua")
AddCSLuaFile("modules/phone/cl_phone.lua")
AddCSLuaFile("modules/phone/sh_phone.lua")
AddCSLuaFile("modules/death/cl_death.lua")
AddCSLuaFile("modules/vehicle/sh_vehicle.lua")
AddCSLuaFile("modules/vehicle/cl_vehicle.lua")
AddCSLuaFile("modules/chair/sh_chair.lua")
AddCSLuaFile("modules/mapeditor/cl_mapeditor.lua")
AddCSLuaFile("modules/mapeditor/sh_mapeditor.lua")
AddCSLuaFile("modules/mapeditor/drive_mapeditor.lua")
AddCSLuaFile("modules/devtool/cl_gameui.lua")
AddCSLuaFile("modules/devtool/cl_devtool.lua")
AddCSLuaFile("modules/notification/cl_notification.lua")
AddCSLuaFile("modules/thirst/sh_thirst.lua")
AddCSLuaFile("modules/hunger/sh_hunger.lua")

AddCSLuaFile("config/jobs.lua")

include("shared.lua")
include("utils/console.lua")
include("utils/hook.lua")
include("utils/http.lua")
include("utils/sqldb.lua")
include("utils/speed.lua")

include("config/sql.lua")

include("extensions/player_class.lua")

include("modules/chatcommand/sv_chatcommand.lua")
include("modules/money/sh_money.lua")
include("modules/money/sv_money.lua")
include("modules/job/sh_job.lua")
include("modules/job/sv_job.lua")
include("modules/phone/sh_phone.lua")
include("modules/phone/sv_phone.lua")
include("modules/death/sv_death.lua")
include("modules/vehicle/sh_vehicle.lua")
include("modules/vehicle/sv_vehicle.lua")
include("modules/chair/sh_chair.lua")
include("modules/mapeditor/sh_mapeditor.lua")
include("modules/mapeditor/sv_mapeditor.lua")
include("modules/mapeditor/drive_mapeditor.lua")
include("modules/player/sv_player.lua")
include("modules/devtool/sv_devtool.lua")
include("modules/notification/sv_notification.lua")
include("modules/thirst/sh_thirst.lua")
include("modules/thirst/sv_thirst.lua")
include("modules/hunger/sh_hunger.lua")
include("modules/hunger/sv_hunger.lua")
include("config/jobs.lua")

resource.AddFile("materials/hud/radial_gradient_effect.png")

function GM:Initialize()
	SqlDB.Initialize()
	SqlDB.Query("CREATE TABLE IF NOT EXISTS 'sourcerp_players' ('id' INTEGER PRIMARY KEY  NOT NULL  UNIQUE , 'money' INTEGER, 'steamid' CHAR)")
	SqlDB.Query("CREATE TABLE IF NOT EXISTS 'sourcerp_bankaccounts' ('id' INTEGER PRIMARY KEY  NOT NULL  UNIQUE , 'name' CHAR, 'card_code' CHAR, 'code' CHAR, 'money' INTEGER)")


	local ModulesList = {}
	local _, Modules = file.Find("SourceRP/gamemode/modules/*", "LUA")
	for k, v in pairs(Modules) do
		local InfoFilePath = "SourceRP/gamemode/modules/"..v.."/module.txt"
		if file.Exists(InfoFilePath, "LUA") then
			local InfoContent = util.JSONToTable(file.Read(InfoFilePath, "LUA"))
			ModulesList[v] = InfoContent
		else
			ErrorNoHalt("[MODULES] module.txt file not found for "..v.." module !\n")
		end
	end
end

concommand.Add("largage", function(ply)
	timer.Create("Largage", 1.5, 5, function() 
		local LOL = ents.Create("prop_physics")
		LOL:SetModel("models/props_phx/mk-82.mdl")
		LOL:SetPos(ply:GetPos() + ply:GetUp() * 2000)
		LOL:Spawn()
		LOL:Activate()
	end)
end)