include("shared.lua")

function ENT:Initialize()
	net.Receive("Use_"..self:EntIndex(), function(len)
		self:Use()
	end)
end

function ENT:Draw()
	if self.DevMode then
		self:DrawModel()
	end
	cam.Start3D2D(self:GetPos() + (self:GetForward() * self.Poster.Forward) + (self:GetUp() *  self.Poster.Up) + (self:GetRight() *  self.Poster.Right), self:GetAngles(), 0.1)
		surface.SetDrawColor(Color(170, 170, 170))
		surface.DrawRect(-(self.Poster.Width / 2), -(self.Poster.Height / 2), self.Poster.Width, self.Poster.Height)
		
		if self.Material && self.Material:GetMaterial() then
			surface.SetDrawColor(Color(255, 255, 255))
			surface.SetMaterial(self.Material:GetMaterial())
			surface.DrawTexturedRectRotated(0, 0, self.Poster.Height, self.Poster.Width, 90)
		end
	cam.End3D2D()
end

function ENT:DrawTranslucent()
	self:Draw()
end

function ENT:SetPosterLink(link)
	net.Start("SetHTTPPoster_"..self:EntIndex())
		net.WriteString(link)
	net.SendToServer()
end

function ENT:Use()
	Derma_StringRequest("Poster", "Input the link of picture", self:GetNWString("HTTPPoster"), function(text) self:SetPosterLink(text) end)
end

function ENT:Think()
	if self.HTTPPoster != self:GetNWString("HTTPPoster") && self:GetNWString("HTTPPoster"):len() > 0 then
		self.HTTPPoster = self:GetNWString("HTTPPoster")
		self.Material = HTTPMaterial(self.HTTPPoster, "smooth")
	end
end