include("shared.lua")

include("utils/console.lua")
include("utils/hook.lua")
include("utils/http.lua")
include("utils/draw.lua")
include("utils/httpmaterial.lua")
include("utils/speed.lua")

include("modules/customkey/cl_customkey.lua")
include("modules/money/sh_money.lua")
include("modules/money/cl_money.lua")
include("modules/job/sh_job.lua")
include("modules/job/cl_job.lua")
include("modules/hud/cl_hud.lua")
include("modules/hud/cl_hudvehicle.lua")
include("modules/phone/sh_phone.lua")
include("modules/inventory/cl_inventory.lua")
include("modules/inventory/cl_weaponselection.lua")
include("modules/phone/cl_phone.lua")
include("modules/death/cl_death.lua")
include("modules/vehicle/sh_vehicle.lua")
include("modules/vehicle/cl_vehicle.lua")
include("modules/chair/sh_chair.lua")
include("modules/mapeditor/sh_mapeditor.lua")
include("modules/mapeditor/cl_mapeditor.lua")
include("modules/mapeditor/drive_mapeditor.lua")
include("modules/devtool/cl_gameui.lua")
include("modules/devtool/cl_devtool.lua")
include("modules/notification/cl_notification.lua")
include("modules/thirst/sh_thirst.lua")
include("modules/hunger/sh_hunger.lua")
include("config/jobs.lua")

surface.CreateFont("SourceTooltip", {
	font = "Roboto Bk",
	size = 25,
	weight = 500
})

surface.CreateFont("SourceTooltipUseKey", {
	font = "Roboto Bk",
	size = 20,
	weight = 500
})

net.Receive("PlayerInitialSpawn", function()
	
end)

--[[local AngleP = 0
local AnglePMove = "down"
hook.Add("CalcView", "MyCalcView", function(ply, pos, angles, fov)
	print(LocalPlayer():GetRunSpeed())
	if AnglePMove == "down" then
		AngleP = (AngleP - 0.009) * AngleP
		if AngleP < -2 then
			AnglePMove = "up"
		end
	end

	if AnglePMove == "up" then
		AngleP = AngleP + 0.009
		if AngleP > 2 then
			AnglePMove = "down"
		end
	end

	local view = {}

	--local AngleView = LocalPlayer():GetAttachment(4).Ang
	angles.p = angles.p + AngleP

	view.origin = pos
	view.angles = angles
	view.fov = fov
	view.drawviewer = false

	return view
end)]]

--[[function GM:SetupSkyboxFog(scale)
	render.FogMode(1)
	render.FogStart(self:GetFogStart() * scale)
	render.FogEnd(self:GetFogEnd() * scale)
	render.FogMaxDensity(self:GetDensity())

	render.FogColor(255, 255, 255)

	return true
end]]

local Mat = Material("dev/graygrid")

hook.Add("PostDraw2DSkyBox", "ExampleHook", function()
	render.OverrideDepthEnable(true, false)

	cam.Start3D(Vector(0, 0, 0), EyeAngles())
		render.SetMaterial(Mat)
		render.DrawQuadEasy(Vector(1, 0, 3) * 200, Vector(-1, 1, 0), 64, 64, Color(255, 255, 255), 0)
	cam.End3D()

	render.OverrideDepthEnable(false, false)
end)