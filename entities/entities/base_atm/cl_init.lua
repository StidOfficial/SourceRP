include("shared.lua")

function ENT:Initialize()
	net.Receive("Use_"..self:EntIndex(), function(len)
		self:Use()
	end)
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:DrawTranslucent()
	
end

function ENT:Use()
	local ATMFrame = vgui.Create("DFrame")
	ATMFrame:SetSize(400, 400)
	ATMFrame:SetTitle("ATM")
	ATMFrame:SetDraggable(true)
	ATMFrame:Center()
	ATMFrame:MakePopup()
	
	local ATMPanel = vgui.Create("DPanel", ATMFrame)
	ATMPanel:Dock(FILL)
	ATMPanel:SetBackgroundColor(Color(0, 0, 0, 0))
	
	local NewAccountButton = vgui.Create("DButton", ATMPanel)
	NewAccountButton:Dock(TOP)
	NewAccountButton:DockMargin(5, 5, 5, 5)
	NewAccountButton:SetSize(0, 50)
	NewAccountButton:SetText("Create new account")
	NewAccountButton.DoClick = function()
		print( "Button was clicked!" )
	end
	
	local ATMLoginPanel = vgui.Create("DPanel", ATMPanel)
	ATMLoginPanel:Dock(BOTTOM)
	ATMLoginPanel:DockMargin(5, 5, 5, 5)
	ATMLoginPanel:SetSize(0, 280)
end