include("shared.lua")

surface.CreateFont("SourceNPCName", {
	font = "Roboto Bk",
	size = 35,
	weight = 200
})

function ENT:Initialize()
	net.Receive("Use_"..self:EntIndex(), function()
		self:Use()
	end)
end

function ENT:Use()
	print("ee")
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	self:Draw()
	
	if self:GetPos():Distance(LocalPlayer():GetPos()) > 150 then return end
	cam.Start3D2D(self:GetPos() + self:GetUp() * 74, Angle(0, LocalPlayer():GetAngles().y - 90, 90), 0.1)
		draw.DrawText("Pôle Emploie", "SourceNPCName", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end