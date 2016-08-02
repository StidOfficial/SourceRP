AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self.SeatEntity = {}
	
	if self.DevMode then
		PrintTable(self.Chairs)
	end
	for kIndex, v in pairs(self.Chairs) do
		local Seat_Airboat = list.Get("Vehicles")["Seat_Airboat"]
		self.SeatEntity[kIndex] = ents.Create(Seat_Airboat.Class)
		self.SeatEntity[kIndex]:SetParent(self, -1)
		self.SeatEntity[kIndex]:SetModel(Seat_Airboat.Model)
		self.SeatEntity[kIndex]:SetNoDraw(!self.DevMode)

		if (Seat_Airboat.KeyValues) then
			for k, v in pairs(Seat_Airboat.KeyValues) do
				local kLower = string.lower(k)
				if (kLower == "vehiclescript" || kLower == "limitview" || kLower == "vehiclelocked" || kLower == "cargovisible" || kLower == "enablegun") then
					self.SeatEntity[kIndex]:SetKeyValue(k, v)
				end
			end
		end

		local EntityForward = self:GetAngles()
		EntityForward.y = self:GetRight():Angle().y + v.Rotate
		self.SeatEntity[kIndex]:SetAngles(EntityForward)
		self.SeatEntity[kIndex]:SetPos(self:GetPos() + (self:GetForward() * v.Forward) + (self:GetUp() * v.Up) + (self:GetRight() * v.Right))

		self.SeatEntity[kIndex]:Spawn()
		self.SeatEntity[kIndex]:Activate()

		self.SeatEntity[kIndex]:SetNotSolid(true)
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
	local ChairSelected
	for k, v in pairs(self.SeatEntity) do
		if ChairSelected then
			if v:GetPos():Distance(ply:GetPos()) < ChairSelected:GetPos():Distance(ply:GetPos()) then
				ChairSelected = v
			end
		else
			ChairSelected = v
		end
	end
	
	if ChairSelected then
		ply:EnterVehicle(ChairSelected)
	end
end

function ENT:OnRemove()
	for k,v in pairs(self.Chairs) do
		self.SeatEntity[k]:Remove()
	end
end