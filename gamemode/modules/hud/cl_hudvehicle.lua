local GradianTexture = surface.GetTextureID("gui/gradient")

surface.CreateFont("GHudVehicleName",
{
	font = "Roboto Bk",
	size = 20,
	weight = 1000
})

function GM:HUDVehicle(vehicle)
	surface.SetDrawColor(0, 0, 0)
	surface.SetTexture(GradianTexture)
	surface.DrawTexturedRect(0, 0, 400, 130)
	
	surface.SetFont("GHudVehicleName")
	surface.SetTextColor(255, 255, 255)
	surface.SetTextPos(5, 5)
	surface.DrawText(list.Get("Vehicles")[vehicle:GetVehicleClass()].Name)
	
	local VehicleSpeed = vehicle:GetSpeedKPH()
	surface.SetFont("GHudVehicleName")
	surface.SetTextColor(255, 255, 255)
	local w, h = surface.GetTextSize(VehicleSpeed)
	surface.SetTextPos(400 - 5 - w, 5)
	surface.DrawText(VehicleSpeed)
	
	surface.SetDrawColor(255, 255, 255)
	surface.DrawRect(0, 30, 400, 5)
end