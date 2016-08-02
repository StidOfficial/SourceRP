surface.CreateFont("NumberPlate", {
	font = "Car-Go 2",
	size = 90,
	weight = 400
})

surface.CreateFont("NumberPlate_Country", {
	font = "Car-Go 2",
	size = 30,
	weight = 400
})

surface.CreateFont("NumberPlate_Region", {
	font = "Car-Go 2",
	size = 40,
	weight = 400
})

hook.Add("CustomKeyDown", "CarEngineDown", function(key)
	if key == KEY_M then
		if !LocalPlayer():InVehicle() then return end
		local vehicle = LocalPlayer():GetVehicle()
		if vehicle:IsEngineStarted() then
			net.Start("PlayerStopEngineVehicle")
			net.SendToServer()
		else
			net.Start("PlayerStartEngineVehicle")
			net.SendToServer()
		end
		--net.Start("PlayerCarEngine")
		--net.SendToServer()
	end
end)

hook.Add("CustomKeyDown", "CarLockDown", function(key)
	if key == KEY_K then
		local VehicleTrace = LocalPlayer():GetEyeTrace().Entity
		if !VehicleTrace:IsVehicle() then return end
		if VehicleTrace:GetPos():Distance(LocalPlayer():GetPos()) > 150 then return end
		if VehicleTrace:IsLocked() then
			net.Start("PlayerUnlockVehicle")
			net.SendToServer()
		else
			net.Start("PlayerLockVehicle")
			net.SendToServer()
		end
	end
end)

local LastTime = 0
hook.Add("Think", "VehicleThink", function()
	if gui.IsGameUIVisible() then return end
	if input.IsMouseDown(MOUSE_LEFT) && LocalPlayer():GetVehicle():IsVehicle() then
		if LastTime < CurTime() then
			LocalPlayer():EmitSound("effect/vehicle_klaxon.wav") 			
			LastTime = CurTime() + SoundDuration("effect/vehicle_klaxon.wav")
		end
	end
end)

local NumberPlate_EU = Material("materials/vehicle/numberplate_eu.png")
local NumberPlate_51 = Material("materials/vehicle/logo-51.png")

local function DrawNumberPlate(entity)
	local w, h = 500, 110
	local border = 5
	local temp = 60

	draw.RoundedBox(10, -(w / 2), -(h / 2), w, h, Color(0, 0, 0))
	draw.RoundedBoxEx(10, -(w / 2) + border, -((h - border * 2) / 2), temp, h - border * 2, Color(0, 105, 204), true, false, true, false)
	surface.SetDrawColor(255, 255, 255)
	surface.DrawRect(-(w / 2) + border + temp, -((h - border * 2) / 2), w - temp * 2 - border * 2, h - border * 2, Color(0, 105, 204))
	draw.RoundedBoxEx(10, -(w / 2) - border + w - temp, -((h - border * 2) / 2), temp, h - border * 2, Color(0, 105, 204), false, true, false, true)
			
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(NumberPlate_EU)
	surface.DrawTexturedRect(-235, -40, 40, 40)

	surface.SetFont("NumberPlate_Country")
	surface.SetTextColor(255, 255, 255)
	surface.SetTextPos(-222, 15)
	surface.DrawText("F")
			
	surface.SetFont("NumberPlate")
	local NumberPlateWidth, NumberPlateHeight = surface.GetTextSize(entity:GetNumberPlate())
	surface.SetTextColor(0, 0, 0)
	surface.SetTextPos(-(NumberPlateWidth / 2), -(NumberPlateHeight / 2))
	surface.DrawText(entity:GetNumberPlate())

	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(NumberPlate_51)
	surface.DrawTexturedRect(195, -45, 40, 40)

	surface.SetFont("NumberPlate_Region")
	surface.SetTextColor(255, 255, 255)
	surface.SetTextPos(200, 10)
	surface.DrawText("51")
end

hook.Add("PostDrawOpaqueRenderables", "VehicleDrawNumberPlate", function()
	for k, v in pairs(ents.FindByClass("prop_vehicle_*")) do
		if v:GetVehicleClass() != "c4tdm" then continue end
		if v:GetPos():Distance(LocalPlayer():GetPos()) > 1000 then continue end
		if !v:IsVehicle() && v:IsChair() then continue end

		if v:GetRenderMode() != RENDERMODE_NONE && v:GetModel() != "models/airboat.mdl" && v:GetModel() != "models/buggy.mdl" then
			v:SetRenderMode(RENDERMODE_NONE)
		end

		--cam.Start3D2D(v:GetPos() +  v:GetRight() * -64.5 + v:GetUp() * 15, v:GetAngles() + Angle(0, 180, 90), 0.04)
		cam.Start3D2D(v:GetPos() +  v:GetRight() * -95.9 + v:GetUp() * 23, Angle(-v:GetAngles().p, v:GetAngles().y + 180, -v:GetAngles().r + 90), 0.04)
			DrawNumberPlate(v)
		cam.End3D2D()

		cam.Start3D2D(v:GetPos() +  v:GetRight() * 99.6 + v:GetUp() * 26, Angle(-v:GetAngles().p + 180, v:GetAngles().y + 180, v:GetAngles().r - 90), 0.04)
			DrawNumberPlate(v)
		cam.End3D2D()
	end
end)