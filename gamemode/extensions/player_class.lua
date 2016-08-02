AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local PLAYER = {}

PLAYER.WalkSpeed 			= 150
PLAYER.RunSpeed				= 250

function PLAYER:Loadout()
	
end

player_manager.RegisterClass("player_sandbox", PLAYER, "player_default")