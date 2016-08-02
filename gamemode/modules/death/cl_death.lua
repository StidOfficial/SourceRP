hook.Add("CalcView", "PlayerDeathView", function()
	local RagdollEntity = LocalPlayer():GetRagdollEntity()
	if !IsEntity(RagdollEntity) then return end
	local RagdollEye = RagdollEntity:GetAttachment(RagdollEntity:LookupAttachment("eyes"))

	return {
		origin = RagdollEye.Pos,
		angles = RagdollEye.Ang,
		fov = LocalPlayer():GetFOV()
	}
end)

surface.CreateFont("GHudDeathUnconscious",
{
	font = "Roboto Bk",
	size = 40,
	weight = 1000
})

local AlphaDeath = 240
function GM:HUDDeath()
	surface.SetDrawColor(0, 0, 0, AlphaDeath)
	surface.DrawRect(0, 0, ScrW(), ScrH())

	DrawMotionBlur(0.055, 1, 0.05)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material("death/death_hud.png"))
	surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

	--surface.SetDrawColor(Color(0, 0, 0))
	--surface.DrawRect(0, 0, ScrW(), ScrH())

	draw.SimpleText("You are unconscious", "GHudDeathUnconscious", ScrW() / 2, 30, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("Respawn in 1 seconde(s)", "GHudDeathUnconscious", ScrW() / 2, ScrH() - 50, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("Medic reviving...", "GHudDeathUnconscious", ScrW() / 2, 70, Color(0, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function GM:PlayerDeath()

end

net.Receive("PlayerDeath", function()
	AlphaDeath = 240
	timer.Create("PlayerDeathEffect", 15, 0, function()
		if AlphaDeath == 240 then
			timer.Create("PlayerDeathEye", 0.1, 15, function()
				AlphaDeath = AlphaDeath + 1
			end)
		elseif AlphaDeath == 255 then
			timer.Create("PlayerDeathEye", 0.1, 15, function()
				AlphaDeath = AlphaDeath - 1
			end)
		end
	end)

	timer.Create("PlayerDeathSound", SoundDuration("effect/player_heartbeat.wav"), 0, function()
		LocalPlayer():EmitSound("effect/player_heartbeat.wav")
	end)
end)

net.Receive("PlayerSpawn", function()
	timer.Destroy("PlayerDeathEffect")
	timer.Destroy("PlayerDeathSound")
end)