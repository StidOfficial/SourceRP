AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

resource.AddFile("sound/effect/light_on.wav")
resource.AddFile("sound/effect/light_off.wav")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	if self.SkinOff then
		self:SetSkin(self.SkinOff)
	end
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
	if self:GetNWBool("Light") then
		if self.SkinOff then
			self:SetSkin(self.SkinOff)
		elseif self.ModelOff then
			self:SetModel(self.ModelOff)
		end
		self:EmitSound("effect/light_off.wav")
	else
		if self.SkinOn then
			self:SetSkin(self.SkinOn)
		elseif self.ModelOn then
			self:SetModel(self.ModelOn)
		end
		self:EmitSound("effect/light_on.wav")
	end
	self:SetNWBool("Light", !self:GetNWBool("Light"))
end