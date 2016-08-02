AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	util.AddNetworkString("Use_"..self:EntIndex())
end

function ENT:SpawnFunction(ply, trace, ClassName)
	if !trace.Hit then return end

	local SpawnPos = trace.HitPos + trace.HitNormal * 50
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 180

	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(SpawnAng)
	ent:Spawn()
	ent:Activate()

	ent:DropToFloor()

	return ent
end

function ENT:Use(ply)
	net.Start("Use_"..self:EntIndex())
	net.Send(ply)
end