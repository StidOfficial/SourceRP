include("shared.lua")

surface.CreateFont("SourceMoney", {
	font = "Roboto Bk",
	size = 100,
	weight = 800
})

function ENT:Draw()
	self:DrawModel()
	
	cam.Start3D2D(self:GetPos() + self:GetUp() * 0.9, self:GetAngles(), 0.01)
		surface.SetFont("SourceMoney")
		local w, h = surface.GetTextSize(self:GetNWFloat("Money"))
		surface.SetTextColor(255, 255, 0)
		surface.SetTextPos(-(w / 2), -(h / 2))
		surface.DrawText(self:GetStringMoney())
	cam.End3D2D()
	
	cam.Start3D2D(self:GetPos(), self:GetAngles() + Angle(0, 0, 180), 0.01)
		surface.SetFont("SourceMoney")
		local w, h = surface.GetTextSize(self:GetNWFloat("Money"))
		surface.SetTextColor(255, 255, 0)
		surface.SetTextPos(-(w / 2), -(h / 2))
		surface.DrawText(self:GetStringMoney())
	cam.End3D2D()
end