function GM:HUDShouldDraw(HUDName)
	return !self.Config.DrawHUD[HUDName] && self.Config.DrawHUD[HUDName] != false
end

function GM:HUDDrawTargetID()
end

local PlayerInfo = {}

surface.CreateFont("GHudNumber",
{
	font = "Roboto",
	size = 20,
	weight = 800
})

surface.CreateFont("GHudPlayerName",
{
	font = "Roboto Bk",
	size = 24
})

surface.CreateFont("GHudGamemodeVersion",
{
	font = "Roboto Condensed",
	size = 17,
	weight = 800
})

surface.CreateFont("GHudInstruction", {
	font = "Roboto Bk",
	size = 17,
	weight = 400
})

local function RefreshModel()
	-- Source : GMOD
	PlayerInfo.Entity = ClientsideModel(LocalPlayer():GetModel(), RENDER_GROUP_OPAQUE_ENTITY)
	PlayerInfo.Entity:SetPos(Vector(-100, 0, -61))
	PlayerInfo.Entity:SetNoDraw(true)
	PlayerInfo.Entity:SetIK(false)

	local iSeq = PlayerInfo.Entity:LookupSequence("walk_all")
	if (iSeq <= 0) then iSeq = PlayerInfo.Entity:LookupSequence("WalkUnarmed_all") end
	if (iSeq <= 0) then iSeq = PlayerInfo.Entity:LookupSequence("walk_all_moderate") end

	if (iSeq > 0) then PlayerInfo.Entity:ResetSequence(iSeq) end

	PlayerInfo.Entity.GetPlayerColor = function() return LocalPlayer():GetPlayerColor() end
end

local RadialGradient = Material("materials/hud/radial_gradient_effect.png")
local GradianTexture = surface.GetTextureID("gui/gradient")

local Time = 0
local RadialI = 100
local RadialType = "up"

function GM:HUDPaint()
	if GetConVarNumber("hidehud") == 1 then return end
	if CurTime() > Time then
		if RadialType == "up" then
			RadialI = RadialI + 1
			if RadialI > 255 then
				RadialType = "down"
			end
		elseif RadialType == "down" then
			RadialI = RadialI - 1
			if RadialI < 100 then
				RadialType = "up"
			end
		end

		Time = CurTime() + 0.009
	end

	--surface.SetDrawColor(0, 0, 0, RadialI)
	--surface.SetMaterial(RadialGradient)
	--surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	
	--draw.Blur((ScrW() - 500) / 2, (ScrH() - 500) / 2, 500, 500, 10, 20, 255)
	
	--draw.Blur(100, 100, 10, 20, 255)
	
	surface.SetFont("GHudGamemodeVersion")
	surface.SetTextColor(255, 0, 0)
	surface.SetTextPos(ScrW() - 170, 10)
	surface.DrawText(string.upper("SourceRP Alpha 0.0.1"))

	surface.SetTextPos(ScrW() - 170, 30)
	surface.DrawText("Voice Volume : "..LocalPlayer():VoiceVolume())

	surface.SetTextPos(ScrW() - 170, 50)
	surface.DrawText("Lua Memory : "..math.Round(gcinfo() / 1024).." MB")

	if LocalPlayer():InMapEditor() then return end
	if (self:HUDShouldDraw("CHudPlayerDeath") && !LocalPlayer():Alive()) then self:HUDDeath() end
	if gui.IsGameUIVisible() then return end
	if (!self:HUDShouldDraw("CHudPlayerInfo") || !LocalPlayer():Alive()) then return end
	if (LocalPlayer():GetVehicle():IsValid() && !LocalPlayer():GetVehicle():IsChair()) then hook.Run("HUDVehicle", LocalPlayer():GetVehicle()) end
	
	surface.SetDrawColor(0, 0, 0)
	surface.SetTexture(GradianTexture)
	surface.DrawTexturedRect(0, ScrH() - 130, 400, 130)
	
	surface.SetDrawColor(0, 0, 0)
	surface.SetTexture(GradianTexture)
	surface.DrawTexturedRectRotated(ScrW() - 400 + 400 / 2, ScrH() - 130 + 130 / 2, 400, 130, 180)

	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(ScrW() - 310, ScrH() - 120, 300, 30)

	surface.SetDrawColor(0, 100, 0, 180)
	surface.DrawRect(ScrW() - 306, ScrH() - 116, (292 * LocalPlayer():Health() / LocalPlayer():GetMaxHealth()), 22)

	surface.SetFont("GHudNumber")
	surface.SetTextColor(255, 255, 255, 100)
	local w, h = surface.GetTextSize(LocalPlayer():Health())
	surface.SetTextPos((ScrW() - 306 + 292 / 2) - w / 2, (ScrH() - 116 + 22 / 2) - h / 2)
	surface.DrawText(LocalPlayer():Health())

	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(ScrW() - 310, ScrH() - 80, 300, 30)

	surface.SetDrawColor(0, 0, 100, 180)
	surface.DrawRect(ScrW() - 306, ScrH() - 76, (292 * LocalPlayer():Thirst() / LocalPlayer():GetMaxThirst()), 22)

	surface.SetFont("GHudNumber")
	surface.SetTextColor(255, 255, 255, 100)
	local w, h = surface.GetTextSize(LocalPlayer():Thirst())
	surface.SetTextPos((ScrW() - 306 + 292 / 2) - w / 2, (ScrH() - 76 + 22 / 2) - h / 2)
	surface.DrawText(LocalPlayer():Thirst())

	surface.SetDrawColor(0, 0, 0, 200)
	surface.DrawRect(ScrW() - 310, ScrH() - 40, 300, 30)

	surface.SetDrawColor(255, 140, 0, 180)
	surface.DrawRect(ScrW() - 306, ScrH() - 36, (292 * LocalPlayer():Hunger() / LocalPlayer():GetMaxHunger()), 22)

	surface.SetFont("GHudNumber")
	surface.SetTextColor(255, 255, 255, 100)
	local w, h = surface.GetTextSize(LocalPlayer():Hunger())
	surface.SetTextPos((ScrW() - 306 + 292 / 2) - w / 2, (ScrH() - 36 + 22 / 2) - h / 2)
	surface.DrawText(LocalPlayer():Hunger())

	local PlayerName = {}
	PlayerName.font = "GHudPlayerName"
	PlayerName.color = Color(255, 255, 255)
	PlayerName.pos = {150, ScrH() - 120}
	PlayerName.text = LocalPlayer():GetName()
	draw.TextShadow(PlayerName, 2)

	local PlayerJobName = {}
	PlayerJobName.font = "GHudPlayerName"
	PlayerJobName.color = LocalPlayer():GetJob() and LocalPlayer():GetJob():GetColor() or Color(255, 0, 0)
	PlayerJobName.pos = {150, ScrH() - 95}
	PlayerJobName.text = LocalPlayer():GetJob() and LocalPlayer():GetJob():GetName() or "No Job"
	draw.TextShadow(PlayerJobName, 2)

	local PlayerMoney = {}
	PlayerMoney.font = "GHudPlayerName"
	PlayerMoney.color = Color(255, 255, 255)
	PlayerMoney.pos = {150, ScrH() - 50}
	PlayerMoney.text = LocalPlayer():GetStringMoney()
	draw.TextShadow(PlayerMoney, 2)

	if ((LocalPlayer():GetModel() and !PlayerInfo.Entity) or (!PlayerInfo.Entity and LocalPlayer():GetModel() != PlayerInfo.Entity:GetModel())) then
		RefreshModel()
	end

	-- Source : GMOD
	if (!IsValid(PlayerInfo.Entity)) then return end
	PlayerInfo.x = 0
	PlayerInfo.y = ScrH() - 200
	PlayerInfo.w = 130
	PlayerInfo.h = 200
	PlayerInfo.FOV = 15
	PlayerInfo.CamPos = Vector(0, 0, 0)
	PlayerInfo.LookAt = Vector(-320, 0, -22)
	PlayerInfo.AmbientLight = Color(50, 50, 50)
	PlayerInfo.Color = Color(255, 255, 255, 255)
	PlayerInfo.DirectionalLight = {}
	PlayerInfo.DirectionalLight[BOX_TOP] = Color(255, 255, 255)
	PlayerInfo.DirectionalLight[BOX_FRONT] = Color(255, 255, 255, 255)

	cam.Start3D(PlayerInfo.CamPos, (PlayerInfo.LookAt - PlayerInfo.CamPos):Angle(), PlayerInfo.FOV, PlayerInfo.x, PlayerInfo.y, PlayerInfo.w, PlayerInfo.h, 5, 4096)
		render.SuppressEngineLighting(true)
		render.SetLightingOrigin(PlayerInfo.Entity:GetPos())
		render.ResetModelLighting(PlayerInfo.AmbientLight.r/255, PlayerInfo.AmbientLight.g/255, PlayerInfo.AmbientLight.b/255)
		render.SetColorModulation(PlayerInfo.Color.r/255, PlayerInfo.Color.g/255, PlayerInfo.Color.b/255)
		render.SetBlend(PlayerInfo.Color.a/255)

		for i=0, 6 do
			local col = PlayerInfo.DirectionalLight[i]
			if (col) then
				render.SetModelLighting(i, col.r/255, col.g/255, col.b/255)
			end
		end

		local rightx = PlayerInfo.w
		local leftx = 0
		local topy = 0
		local bottomy = PlayerInfo.h
		local x = PlayerInfo.x
		local y = PlayerInfo.y
		topy = math.Max(y, topy + y)
		leftx = math.Max(x, leftx + x)
		bottomy = math.Min(y + PlayerInfo.h, bottomy + y)
		rightx = math.Min(x + PlayerInfo.w, rightx + x)
		render.SetScissorRect(leftx, topy, rightx, bottomy, true)

		PlayerInfo.Entity:DrawModel()

		render.SetScissorRect(0, 0, 0, 0, false)

		render.SuppressEngineLighting(false)
	cam.End3D()

	surface.SetDrawColor(205, 55, 0)
	surface.DrawRect(0, ScrH() - 3, 400, 3)

	local Entity = LocalPlayer():GetEyeTrace().Entity
	if !Entity:IsValid() || (Entity:IsValid() && (Entity:GetClass() == "worldspawn" || Entity:GetClass() == "prop_physics")) then return end
	if !Entity.Instructions then return end

	if Entity:GetPos():Distance(LocalPlayer():GetPos()) > 150 then return end
	surface.SetFont("GHudInstruction")
	local x, y = ScrW() / 2, ScrH() / 2
	local ToolTipTextWidth, ToolTipTextHeigth = surface.GetTextSize(string.upper(Entity.Instructions))

	surface.SetTextColor(255, 255, 255)
	surface.SetTextPos(x - (ToolTipTextWidth / 2), y - (ToolTipTextHeigth / 2) - 30)
	surface.DrawText(string.upper(Entity.Instructions))

	surface.SetDrawColor(255, 255, 255)
	draw.NoTexture()
	draw.Circle(ScrW() / 2, ScrH() / 2, 3, 40)
end