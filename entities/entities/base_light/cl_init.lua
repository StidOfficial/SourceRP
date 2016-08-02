include("shared.lua")
local matLight = Material( "sprites/light_ignorez" )

function ENT:Initialize()
	self.PixVis = util.GetPixelVisibleHandle()
end

function ENT:Draw()
	self:DrawModel()
	
	if !self.DevMode then return end
	for k, v in pairs(self.Lights) do
		local LightPos = self:GetPos() - (self:GetForward() * v.Forward) - (self:GetUp() * v.Up) - (self:GetRight() * v.Right)
		render.SetMaterial(Material("color"))
		render.DrawSphere(LightPos, 1, 20, 20, Color(255, 255, 0, 50))
		render.DrawSphere(LightPos, v.Size, 20, 20, Color(255, 0, 0, 50))
	end
end

function ENT:DrawTranslucent()
	if !self:GetNWBool("Light") then return end
	for k, v in pairs(self.Lights) do
		local LightPos = self:GetPos() - (self:GetForward() * v.Forward) - (self:GetUp() * v.Up) - (self:GetRight() * v.Right)
		render.SetMaterial(matLight)
		
		local Visibile	= util.PixelVisible(LightPos, 4, self.PixVis)
		if (!Visibile || Visibile < 0.1) then return end
		if (!self:GetNWBool("Light")) then return end
		
		local Alpha = 255 * Visibile

		render.DrawSprite(LightPos, 20, 20, Color(v.Color.r, v.Color.g, v.Color.b, Alpha), Visibile)
	end
end

function ENT:Think()
	if !self:GetNWBool("Light") then return end
	for k, v in pairs(self.Lights) do
		local dlight = DynamicLight(LocalPlayer():EntIndex())
		if (dlight) then
			dlight.pos = self:GetPos() - (self:GetForward() * v.Forward) - (self:GetUp() * v.Up) - (self:GetRight() * v.Right)
			dlight.r = v.Color.r
			dlight.g = v.Color.g
			dlight.b = v.Color.b
			dlight.brightness = v.Brightness
			dlight.Decay = v.Decay
			dlight.Size = v.Size
			dlight.DieTime = CurTime() + 1
		end
	end
end