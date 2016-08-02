resource.AddFile("sound/effect/vehicle_lock.wav")
resource.AddFile("sound/effect/vehicle_klaxon.wav")
resource.AddFile("resource/fonts/Face_Off_M54.ttf")
resource.AddFile("resource/fonts/CarGo2.ttf")
resource.AddFile("materials/vehicle/numberplate_eu.png")
resource.AddFile("materials/vehicle/logo-51.png")

function GM:CanPlayerEnterVehicle(ply, vehicle, sRole)
	if vehicle:IsEngineStopped() then
		vehicle:Fire("TurnOff")
	end
	return vehicle:IsUnlocked()
end

function GM:PlayerEnteredVehicle(ply, vehicle, role)
end

function GM:CanExitVehicle(vehicle, ply)
	if vehicle:IsEngineStarted() then
		vehicle:Fire("TurnOn")
	end
	return vehicle:IsUnlocked()
end

function GM:PlayerLeaveVehicle(ply, vehicle)
end

function GM:CanStartEngineVehicle(ply, vehicle)
	return vehicle:IsEngineStopped()
end

function GM:PlayerStartedEngineVehicle(ply, vehicle)
end

function GM:CanStopEngineVehicle(ply, vehicle)
	return vehicle:IsEngineStarted()
end

function GM:PlayerStoppedEngineVehicle(ply, vehicle)
end

function GM:CanLockVehicle(ply, vehicle)
	return vehicle:IsUnlocked() && vehicle:GetPos():Distance(ply:GetPos()) < 150
end

function GM:PlayerLockedVehicle(ply, vehicle)
	ply:ChatPrint("Vehicle is locked !")
end

function GM:CanUnlockVehicle(ply, vehicle)
	return vehicle:IsLocked() && vehicle:GetPos():Distance(ply:GetPos()) < 150
end

function GM:PlayerUnlockedVehicle(ply, vehicle)
	ply:ChatPrint("Vehicle is unlocked !")
end

util.AddNetworkString("PlayerStartEngineVehicle")
net.Receive("PlayerStartEngineVehicle", function(length, ply)
	if (IsValid(ply) && ply:IsPlayer() && ply:InVehicle()) then
		if !GAMEMODE:CanStartEngineVehicle(ply, ply:GetVehicle()) then return end
		ply:GetVehicle():Fire("TurnOn")
		ply:GetVehicle():SetNWBool("EngineStarted", true)
		GAMEMODE:PlayerStartedEngineVehicle(ply, ply:GetVehicle())
	end
end)

util.AddNetworkString("PlayerStopEngineVehicle")
net.Receive("PlayerStopEngineVehicle", function(length, ply)
	if (IsValid(ply) && ply:IsPlayer() && ply:InVehicle()) then
		if !GAMEMODE:CanStopEngineVehicle(ply, ply:GetVehicle()) then return end
		ply:GetVehicle():Fire("TurnOff")
		ply:GetVehicle():Fire("HandBrakeOff")
		ply:GetVehicle():SetNWBool("EngineStarted", false)
		GAMEMODE:PlayerStoppedEngineVehicle(ply, ply:GetVehicle())
	end
end)


util.AddNetworkString("PlayerLockVehicle")
net.Receive("PlayerLockVehicle", function(length, ply)
	if (IsValid(ply) && ply:IsPlayer()) then
		local VehicleTrace = ply:GetEyeTrace().Entity
		if !VehicleTrace:IsVehicle() then return end
		if VehicleTrace:GetPos():Distance(ply:GetPos()) > 150 then return end
		if !GAMEMODE:CanLockVehicle(ply, VehicleTrace) then return end
		VehicleTrace:EmitSound("effect/vehicle_lock.wav")
		VehicleTrace:SetNWBool("Lock", true)
		GAMEMODE:PlayerLockedVehicle(ply, VehicleTrace)
	end
end)

util.AddNetworkString("PlayerUnlockVehicle")
net.Receive("PlayerUnlockVehicle", function(length, ply)
	if (IsValid(ply) && ply:IsPlayer()) then
		local VehicleTrace = ply:GetEyeTrace().Entity
		if !VehicleTrace:IsVehicle() then return end
		if VehicleTrace:GetPos():Distance(ply:GetPos()) > 150 then return end
		if !GAMEMODE:CanUnlockVehicle(ply, VehicleTrace) then return end
		VehicleTrace:EmitSound("effect/vehicle_lock.wav")
		VehicleTrace:SetNWBool("Lock", false)
		GAMEMODE:PlayerUnlockedVehicle(ply, VehicleTrace)
	end
end)