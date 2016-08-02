AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/mossman.mdl")
	self:SetUseType(SIMPLE_USE)
	self:StartActivity(ACT_IDLE)
	
	util.AddNetworkString("Use_"..self:EntIndex())
end

function ENT:Use(activator, caller, useType, value)
	net.Start("Use_"..self:EntIndex())
	net.Send(activator)
end

function ENT:Think()
	for k, v in pairs( player.GetAll() ) do
		if (v:EyePos():Distance(self:EyePos()) < 60) then
			self:SetEyeTarget(v:EyePos())
			break
		end
	end
end