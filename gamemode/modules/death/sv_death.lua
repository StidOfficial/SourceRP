resource.AddFile("sound/effect/player_dying.wav")
resource.AddFile("sound/effect/player_heartbeat.wav")

resource.AddFile("materials/death/death_hud.png")

util.AddNetworkString("PlayerDeath")
function GM:PlayerDeath(ply, inflictor, attacker)
	ply.NextSpawnTime = CurTime() + 2
	ply.DeathTime = CurTime()

	ply:EmitSound("effect/player_dying.wav")

	net.Start("PlayerDeath")
	net.Send(ply)
end

function GM:PlayerDeathSound()
	return true
end