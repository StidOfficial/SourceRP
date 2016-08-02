local VEHICLE = FindMetaTable("Vehicle")

function VEHICLE:IsEngineStarted()
	return self:GetNWBool("EngineStarted")
end

function VEHICLE:IsEngineStopped()
	return !self:GetNWBool("EngineStarted")
end

function VEHICLE:IsLocked()
	return self:GetNWBool("Lock")
end

function VEHICLE:IsUnlocked()
	return !self:GetNWBool("Lock")
end

function VEHICLE:GetNumberPlate()
	return self:GetNWString("NumberPlate") == "" and "ERROR" or self:GetNWString("NumberPlate")
end

function VEHICLE:GetSpeedKPH()
	return speed.VelocityToKPH(self:GetVelocity():Length())
end

function VEHICLE:GetSpeedMPH()
	return speed.VelocityToMPH(self:GetVelocity():Length())
end